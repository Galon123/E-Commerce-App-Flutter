import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const BASE_URL = "http://192.168.1.12:8000";

class ApiClient {
  ApiClient._internal();

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  static late PersistCookieJar _cookieJar;

  static Future<void> setup() async {
    // 1. Initialize Path & CookieJar
    final appDocDir = await getApplicationDocumentsDirectory();
    final String path = "${appDocDir.path}/.cookies/";
    _cookieJar = PersistCookieJar(storage: FileStorage(path));

    // 2. INTERCEPTOR 1: The Cleaner (Must be first!)
    // This removes the "Bearer " prefix from the backend cookie before CookieManager sees it
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final cookies = response.headers['set-cookie'];
          if (cookies != null) {
            List<String> cleanedCookies = cookies.map((cookie) {
              return cookie.replaceAll("Bearer ", "").replaceAll("Bearer%20", "");
            }).toList();
            // Overwrite the dirty header with the clean one
            response.headers.set('set-cookie', cleanedCookies);
          }
          return handler.next(response);
        },
      ),
    );

    // 3. INTERCEPTOR 2: Cookie Manager
    _dio.interceptors.add(CookieManager(_cookieJar));

    // 4. INTERCEPTOR 3: Log Interceptor (Optional, for debugging)
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestHeader: true));

    // 5. INTERCEPTOR 4: The 401 & Refresh Logic
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 && e.response?.data['detail'] == "Token Expires") {
            try {
              final refreshDio = Dio(BaseOptions(baseUrl: BASE_URL));
              refreshDio.interceptors.add(CookieManager(_cookieJar));

              // 1. Call refresh. The CookieManager handles sending the refresh cookie 
              // and SAVING the new access_token cookie automatically.
              final refreshResponse = await refreshDio.post('/refresh');

              if (refreshResponse.statusCode == 200) {
                // 2. REMOVE the manual Authorization header entirely.
                // We want the backend to rely ONLY on the cookie we just saved.
                _dio.options.headers.remove("Authorization");
                e.requestOptions.headers.remove("Authorization");

                // 3. Retry the request. The CookieManager will now attach the fresh cookie.
                final retryResponse = await _dio.fetch(e.requestOptions);
                return handler.resolve(retryResponse);
              }
            } catch (refreshError) {
              debugPrint("Refresh failed: $refreshError");
            }
          }
        },
      ),
    );
  }

  // Helper to check if we have a session
  static Future<bool> hasValidSession() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse(BASE_URL));
    return cookies.isNotEmpty;
  }

  // Function to set initial token after a fresh Login
  static void setToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  static Dio get dio => _dio;
}
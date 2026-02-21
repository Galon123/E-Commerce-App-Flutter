import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

const BASE_URL = "http://192.168.1.12:8000";

class ApiClient {

  ApiClient._internal();

  static final Dio _dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3)
    ));

    static late PersistCookieJar _cookieJar;

  static Future <void> setup() async{

    //PATH to store cookies
    final appDocDir = await getApplicationDocumentsDirectory();
    final String path = "${appDocDir.path}/.cookies/";


    _cookieJar = PersistCookieJar(storage: FileStorage(path));

    _dio.interceptors.add(LogInterceptor(responseBody: true));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {

          final cookies = response.headers['set-cookie'];

          if (cookies != null) {
            for (var i = 0; i < cookies.length; i++) {
              cookies[i] = cookies[i].replaceAll("Bearer ", "");
            }
          }

          return handler.next(response);
        },
      ),
    );

    

_dio.interceptors.add(InterceptorsWrapper(
  onError: (DioException e, handler) async {
    if (e.response?.statusCode == 401 && e.response?.data['detail'] == "Token Expires") {
      try {
        // 1. Create a clean Dio instance
        final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
        
        // 2. Attach the same CookieJar to this temporary Dio
        // This ensures the refresh cookie is sent!
        refreshDio.interceptors.add(CookieManager(_cookieJar)); 

        // 3. Make the call (Cookies are sent automatically)
        final refreshResponse = await refreshDio.post('/refresh');

        if (refreshResponse.statusCode == 200) {
          // 4. Get the NEW access token from the JSON body
          final newAccessToken = refreshResponse.data['access_token'];

          // 5. Update your global headers
          _dio.options.headers["Authorization"] = "Bearer $newAccessToken";

          // 6. Update the failed request and retry
          e.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";
          final response = await _dio.fetch(e.requestOptions);
          
          return handler.resolve(response);
        }
      } catch (refreshError) {
        debugPrint("Refresh failed: $refreshError");
        // Token is truly dead, time to log out
      }
    }
    return handler.next(e);
  },
));

    _dio.interceptors.add(CookieManager(_cookieJar));

    

  }

  static Future<bool>hasValidSession() async{

    final cookies = await _cookieJar.loadForRequest(Uri.parse(BASE_URL));

    return cookies.isNotEmpty;

  }



  static void addInterceptor(String token) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Authorization"] = "Bearer $token";
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            debugPrint("Token expired! Redirecting to login...");
          }
          return handler.next(e);
        },
      ),
    );
  }

  //Getter 
  static Dio get dio => _dio;



}


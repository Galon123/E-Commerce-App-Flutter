import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

const BASE_URL = "http://10.175.149.47:8000";

class ApiClient {

  ApiClient._internal();

  static final Dio _dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 10),
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
      onError: (DioException e, handler) async{
        if(e.response?.statusCode == 401){
          try{

            final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));

            await refreshDio.post('/refresh');

            final response = await _dio.fetch(e.requestOptions);

            return handler.resolve(response);
          }
          catch(refreshError){
            print("Error Refreshing token...");
          }
        }
        return handler.next(e);
      }
    )
    );

    _dio.interceptors.add(CookieManager(_cookieJar));

    

  }

  static Future<bool>hasValidSession() async{

    final cookies = await _cookieJar.loadForRequest(Uri.parse(BASE_URL));

    return cookies.isNotEmpty;

  }

  //Getter 
  static Dio get dio => _dio;

}
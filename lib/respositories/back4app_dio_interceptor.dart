import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Back4AppDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["X-Parse-Application-Id"] =
        dotenv.get("BACK4APPAPPLICATIONID");
    options.headers["X-Parse-REST-API-Key"] = dotenv.get("BACK4APPRESTAPIKEY");
    // ignore: avoid_print
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // ignore: avoid_print
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

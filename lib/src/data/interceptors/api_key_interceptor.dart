import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${dotenv.env['API_KEY']}';
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }
}

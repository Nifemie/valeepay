import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'https://valar-pay-api.up.railway.app';
  static const String apiKey = '5821039487621507';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': apiKey, // ✅ global auth header
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('[API REQUEST] => ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('[API RESPONSE] => ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('[API ERROR] => ${e.response?.statusCode} ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  /// POST Request
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return await dio.post(path, data: data);
  }

  /// GET Request
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await dio.get(path, queryParameters: query);
  }

  /// PUT Request
  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    return await dio.put(path, data: data);
  }

  /// DELETE Request
  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}

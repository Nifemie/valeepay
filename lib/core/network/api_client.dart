import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:valarpay/core/services/session_service.dart';
import 'package:flutter/material.dart';

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
          'x-api-key': apiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('[API REQUEST] => ${options.method} ${options.path}');
          print('[API HEADERS] => ${options.headers}');
          print('[API DATA] => ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 200) {
            final data = response.data;

            // Skip validation for endpoints that return data directly (not wrapped in 'data' field)
            final proceedWithValidation = response.requestOptions.path.contains(
              '/verify-account',
            );

            if (proceedWithValidation) {
              if (data is Map &&
                  (data['data'] == null || data['data'].toString() == '{}')) {
                return handler.reject(
                  DioException(
                    requestOptions: response.requestOptions,
                    error: "Invalid response returned by server.",
                    type: DioExceptionType.badResponse,
                  ),
                );
              }
            }
          }

          if (response.requestOptions.path.contains('/me')) {
            print('[API /me RESPONSE] => Status: ${response.statusCode}');
            print(
              '[API /me RESPONSE] => Has wallet: ${response.data['wallet'] != null}',
            );
            if (response.data['wallet'] != null) {
              print(
                '[API /me RESPONSE] => Wallet type: ${response.data['wallet'].runtimeType}',
              );
              print(
                '[API /me RESPONSE] => Wallet content: ${response.data['wallet']}',
              );
            }
          }

          print('[API RESPONSE] => ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          print('[API ERROR] => ${e.response?.statusCode} ${e.message}');

          // ✅ Handle 401 Unauthorized
          if (e.response?.statusCode == 401) {
            print('[API ERROR] => Unauthorized! Logging out...');
            // await _handleUnauthorized();
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _withAuth(Options options) async {
    final token = await SessionService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers ??= {};
      options.headers!['Authorization'] = 'Bearer $token';
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    final options = Options();
    await _withAuth(options);
    return await dio.post(path, data: data, options: options);
  }

  Future<Response> postFormData(String path, {required FormData data}) async {
    final options = Options(contentType: 'multipart/form-data');
    await _withAuth(options);
    return await dio.post(path, data: data, options: options);
  }

  Future<Response> putFormData(String path, {required FormData data}) async {
    final options = Options(contentType: 'multipart/form-data');
    await _withAuth(options);
    return await dio.put(path, data: data, options: options);
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    final options = Options();
    await _withAuth(options);
    return await dio.get(path, queryParameters: query, options: options);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    final options = Options();
    await _withAuth(options);
    return await dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path) async {
    final options = Options();
    await _withAuth(options);
    return await dio.delete(path, options: options);
  }
}

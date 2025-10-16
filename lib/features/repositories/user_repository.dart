import 'package:dio/dio.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/login.dart';
import '../../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response =
          await apiClient.post(ApiEndpoints.login, data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<LoginResponse> loginWithPasscode(PasscodeLoginRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.loginWithPasscode,
          data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }
}

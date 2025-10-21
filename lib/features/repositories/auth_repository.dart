import 'package:dio/dio.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/create_passcode_request.dart';
import 'package:valarpay/features/models/create_passcode_response.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/username_request.dart';
import 'package:valarpay/features/models/verify_otp_request.dart';
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

  Future<LoginResponse> resend2fa(UsernameRequest request) async {
    try {
      final response =
          await apiClient.post(ApiEndpoints.resend2fa, data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<LoginResponse> verify2fa(VerifyOtpRequest request) async {
    try {
      final response =
          await apiClient.post(ApiEndpoints.verify2fa, data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<CreatePasscodeResponse> createPasscode(
      CreatePasscodeRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.createPasscode,
        data: request.toJson(),
      );
      return CreatePasscodeResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to create passcode');
    }
  }
}

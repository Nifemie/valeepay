import 'package:dio/dio.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/api_response.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/models/user.dart';
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

  Future<LoginResponse> signUp(SignUpRequest request) async {
    try {
      final response =
          await apiClient.post(ApiEndpoints.register, data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Sign up failed');
    }
  }

  Future<ApiResponse> resendVerificationCode(String email) async {
    try {
      final response = await apiClient.post(ApiEndpoints.resendVerificationCode, data: {
        'email': email,
      });
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to resend verification code');
    }
  }

  Future<ApiResponse> verifyEmail(String email, String otpCode) async {
    try {
      final response = await apiClient.post(ApiEndpoints.verifyEmail, data: {
        'email': email,
        'otpCode': otpCode,
      });
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Email verification failed');
    }
  }

  Future<LoginResponse> registerBusiness(SignUpRequest request) async {
    try {
      final response =
          await apiClient.post(ApiEndpoints.registerBusiness, data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Business registration failed');
    }
  }

  Future<ApiResponse> forgotPassword(String email) async {
    try {
      final response = await apiClient.post(ApiEndpoints.forgotPassword, data: {
        'email': email,
      });
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send reset link');
    }
  }

  Future<ApiResponse> verifyForgotPassword(String email, String otp) async {
    try {
      final response = await apiClient.post(ApiEndpoints.verifyForgotPassword, data: {
        'email': email,
        'otpCode': otp,
      });
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to verify OTP');
    }
  }

  Future<ApiResponse> resetPassword(String email, String otp, String password) async {
    try {
      final response = await apiClient.post(ApiEndpoints.resetPassword, data: {
        'email': email,
        'otp': otp,
        'password': password,
      });
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to reset password');
    }
  }
}

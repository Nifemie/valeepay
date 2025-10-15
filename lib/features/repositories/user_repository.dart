import 'package:dio/dio.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/api_response.dart';
import 'package:valarpay/features/models/email_request.dart';
import 'package:valarpay/features/models/forgot_password.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/phone_number_request.dart';
import 'package:valarpay/features/models/reset_password.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/models/user_availablity_request.dart';
import 'package:valarpay/features/models/verify_email_request.dart';
import 'package:valarpay/features/models/verify_forgot_password.dart';
import 'package:valarpay/features/models/verify_phone_number.dart';
import '../../../core/network/api_client.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository(this.apiClient);

  Future<LoginResponse> register(SignUpRequest request) async {
    try {
      final response =
          await apiClient.post(ApiEndpoints.register, data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Sign up failed');
    }
  }

  Future<LoginResponse> registerBusiness(SignUpRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.registerBusiness,
          data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Business registration failed');
    }
  }

  Future<ApiResponse> checkUserExistance(
      UserAvailabilityRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.existanceCheck,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'User existance check failed');
    }
  }

  Future<ApiResponse> validateEmail(EmailRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.validateEmail,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to resend verification code');
    }
  }

  Future<ApiResponse> verifyEmail(VerifyEmailRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.verifyEmail,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Email verification failed');
    }
  }

  Future<ApiResponse> validatePhone(PhoneNumberRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.validatePhone,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to resend verification code');
    }
  }

  Future<ApiResponse> verifyPhone(VerifyPhoneOtpRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.verifyPhone,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Phone verification failed');
    }
  }

  Future<ApiResponse> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.forgotPassword,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to send reset link');
    }
  }

  Future<ApiResponse> verifyForgotPassword(VerifyForgotPassword request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.verifyForgotPassword,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to verify OTP');
    }
  }

  Future<ApiResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await apiClient.post(ApiEndpoints.resetPassword,
          data: request.toJson());
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to reset password');
    }
  }
}

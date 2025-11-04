import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/api_response.dart';
import 'package:valarpay/features/models/email_request.dart';
import 'package:valarpay/features/models/forgot_password.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/phone_number_request.dart';
import 'package:valarpay/features/models/reset_password.dart';
import 'package:valarpay/features/models/set_wallet_pin_request.dart';
import 'package:valarpay/features/models/set_wallet_pin_response.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/models/user.dart';
import 'package:valarpay/features/models/user_availablity_request.dart';
import 'package:valarpay/features/models/verify_email_request.dart';
import 'package:valarpay/features/models/verify_otp_request.dart';
import 'package:valarpay/features/models/verify_phone_number.dart';
import 'package:valarpay/features/models/verify_wallet_pin_request.dart';
import 'package:valarpay/features/models/verify_wallet_pin_response.dart';
import 'package:valarpay/features/models/nin_verification_request.dart';
import 'package:valarpay/features/models/nin_verification_response.dart';
import '../../../core/network/api_client.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository(this.apiClient);

  Future<LoginResponse> register(SignUpRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Sign up failed');
    }
  }

  Future<LoginResponse> registerBusiness(SignUpRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.registerBusiness,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Business registration failed',
      );
    }
  }

  Future<ApiResponse> checkUserAvailablity(
    UserAvailabilityRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.existanceCheck,
        data: request.toJson(),
      );

      // Log full response to confirm structure
      print('[UserRepo] Response code: ${response.statusCode}');
      print('[UserRepo] Response data: ${response.data}');

      // Handle expected structure gracefully
      if (response.statusCode == 200 && response.data != null) {
        return ApiResponse.fromJson(response.data);
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final serverMessage =
          e.response?.data != null
              ? e.response?.data['message'] ?? 'User existance check failed'
              : 'User existance check failed';
      print('[UserRepo] DioException: $serverMessage');
      throw Exception(serverMessage);
    } catch (e) {
      print('[UserRepo] Unexpected error: $e');
      throw Exception('User existance check failed');
    }
  }

  Future<ApiResponse> validateEmail(EmailRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.validateEmail,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to resend verification code',
      );
    }
  }

  Future<ApiResponse> verifyEmail(VerifyEmailRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyEmail,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Email verification failed',
      );
    }
  }

  Future<ApiResponse> validatePhone(PhoneNumberRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.validatePhone,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to resend verification code',
      );
    }
  }

  Future<ApiResponse> verifyPhone(VerifyPhoneOtpRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyPhone,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Phone verification failed',
      );
    }
  }

  Future<ApiResponse> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to send reset link',
      );
    }
  }

  Future<ApiResponse> verifyForgotPassword(VerifyOtpRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyForgotPassword,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to verify OTP');
    }
  }

  Future<ApiResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to reset password',
      );
    }
  }

  Future<SetWalletPinResponse> setWalletPin(SetWalletPinRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.setWalletPin,
        data: request.toJson(),
      );
      return SetWalletPinResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to set wallet PIN',
      );
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      log('[UserRepository] Calling GET ${ApiEndpoints.getUserProfile}');
      final response = await apiClient.get(ApiEndpoints.getUserProfile);
      log('[UserRepository] Response status: ${response.statusCode}');
      log(
        '[UserRepository] 🔍 Has wallet field: ${response.data['wallet'] != null}',
      );
      if (response.data['wallet'] != null) {
        log(
          '[UserRepository] 🔍 Wallet type: ${response.data['wallet'].runtimeType}',
        );
        log('[UserRepository] 🔍 Wallet content: ${response.data['wallet']}');
      } else {
        log('[UserRepository] ⚠️ WARNING: wallet field is NULL in response!');
      }

      final user = UserModel.fromJson(response.data);
      log(
        '[UserRepository] Parsed user - isPasscodeSet: ${user.isPasscodeSet}',
      );
      log(
        '[UserRepository] Parsed user - wallets count: ${user.wallets.length}',
      );
      return user;
    } on DioException catch (e) {
      log('[UserRepository] Error fetching profile: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch user profile',
      );
    }
  }

  Future<VerifyWalletPinResponse> verifyWalletPin(
    VerifyWalletPinRequest request,
  ) async {
    try {
      log('[UserRepository] Verifying wallet PIN...');
      final response = await apiClient.post(
        ApiEndpoints.verifyWalletPin,
        data: request.toJson(),
      );
      log('[UserRepository] PIN verification response: ${response.statusCode}');
      return VerifyWalletPinResponse.fromJson(response.data);
    } on DioException catch (e) {
      log('[UserRepository] PIN verification failed: ${e.response?.data}');
      throw Exception(
        e.response?.data['message'] ?? 'Failed to verify wallet PIN',
      );
    }
  }

  /// Upload profile image using multipart PUT
  Future<ApiResponse> editProfileImage(String filePath, String fullName) async {
    try {
      final file = File(filePath);
      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'profile-image': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'fullName': fullName,
      });

      final response = await apiClient.putFormData(
        ApiEndpoints.editProfile,
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception(
          response.data?['message'] ?? 'Failed to upload profile image',
        );
      }
      // Success - backend returns message. Caller may refresh profile afterwards.
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to upload profile image',
      );
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// Verify NIN for Tier 2 KYC upgrade
  Future<NinVerificationResponse> verifyNinTier2(
    NinVerificationRequest request,
  ) async {
    try {
      log('[UserRepository] Verifying NIN for Tier 2...');
      log('[UserRepository] NIN: ${request.nin}');
      log('[UserRepository] Selfie length: ${request.selfieImage.length}');

      final response = await apiClient.post(
        ApiEndpoints.kycTier2,
        data: request.toJson(),
      );

      log('[UserRepository] NIN verification response: ${response.statusCode}');
      log('[UserRepository] Response data: ${response.data}');

      return NinVerificationResponse.fromJson(response.data);
    } on DioException catch (e) {
      log('[UserRepository] NIN verification failed: ${e.response?.data}');

      // Return error response with proper structure
      return NinVerificationResponse(
        message: e.response?.data['message'] ?? 'NIN verification failed',
        error: e.response?.data['error'] ?? 'Bad Request',
        statusCode: e.response?.statusCode ?? 400,
      );
    } catch (e) {
      log('[UserRepository] Unexpected error: $e');
      return NinVerificationResponse(
        message: 'Unexpected error: $e',
        error: 'Internal Error',
        statusCode: 500,
      );
    }
  }

  /// Submit address for Tier 3 KYC upgrade
  Future<ApiResponse> submitKycTier3(Map<String, dynamic> addressData) async {
    try {
      log('[UserRepository] Submitting KYC Tier 3...');
      log('[UserRepository] Address data: $addressData');

      final response = await apiClient.post(
        ApiEndpoints.kycTier3,
        data: addressData,
      );

      log('[UserRepository] KYC Tier 3 response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(response.data);
      } else {
        throw Exception(
          response.data?['message'] ?? 'Failed to submit address verification',
        );
      }
    } on DioException catch (e) {
      log('[UserRepository] KYC Tier 3 DioException:');
      log('  Status Code: ${e.response?.statusCode}');
      log('  Response Data: ${e.response?.data}');
      log('  Error Message: ${e.message}');

      // Try to extract the error message from the response
      String errorMessage = 'Failed to submit address verification';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage =
              e.response!.data['message'] ??
              e.response!.data['error'] ??
              errorMessage;
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }
      }

      throw Exception(errorMessage);
    } catch (e) {
      log('[UserRepository] KYC Tier 3 unexpected error: $e');
      throw Exception('Failed to submit address verification: $e');
    }
  }
}

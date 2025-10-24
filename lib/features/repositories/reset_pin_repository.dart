import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/api_response.dart';
import 'package:valarpay/features/models/bvn_initialize_request.dart';
import 'package:valarpay/features/models/bvn_initialize_response.dart';
import 'package:valarpay/features/models/bvn_validate_request.dart';
import 'package:valarpay/features/models/bvn_validate_response.dart';
import 'package:valarpay/features/models/email_request.dart';
import 'package:valarpay/features/models/forgot_password.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/phone_number_request.dart';
import 'package:valarpay/features/models/reset_password.dart';
import 'package:valarpay/features/models/reset_pin_model.dart';
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
import '../../../core/network/api_client.dart';

class ResetPinRepository {
  final ApiClient apiClient;

  ResetPinRepository(this.apiClient);

  
  Future<ApiResponse> forgotPin() async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.forgotWalletPin,
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to send reset link',
      );
    }
  }

    Future<ApiResponse> resetPin(ResetPinRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.resetWalletPin,
        data: request.toJson(),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to reset pin',
      );
    }
  }

}

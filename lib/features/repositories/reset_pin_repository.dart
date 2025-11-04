import 'package:dio/dio.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/api_response.dart';
import 'package:valarpay/features/models/reset_pin_model.dart';
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

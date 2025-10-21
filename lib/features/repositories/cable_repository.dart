import 'package:dio/dio.dart';
import 'package:valarpay/features/models/cable_models.dart';
import 'package:valarpay/core/network/api_client.dart';

class CableRepository {
  final ApiClient apiClient;

  CableRepository(this.apiClient);

  Future<CablePlanResponse> getCablePlans({required String currency}) async {
    try {
      final response = await apiClient.get(
        '/api/v1/bill/cable/get-plan',
        query: {'currency': currency},
      );
      return CablePlanResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get plans');
    }
  }

  Future<CableVariationResponse> getCableVariation(
      {required String billerCode}) async {
    try {
      final response = await apiClient.get(
        '/api/v1/bill/cable/get-bill-info',
        query: {'billerCode': billerCode},
      );
      return CableVariationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to get variations');
    }
  }

  Future<void> verifyCableNumber(VerifyCableRequest request) async {
    try {
      await apiClient.post('/api/v1/bill/cable/verify-cable-number',
          data: request.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Verification failed');
    }
  }

  Future<CablePaymentResponse> payCable(CablePayRequest request) async {
    try {
      final response = await apiClient.post('/api/v1/bill/cable/pay',
          data: request.toJson());
      if (response.data != null && response.data is Map<String, dynamic>) {
        return CablePaymentResponse.fromJson(response.data);
      }
      return CablePaymentResponse(
          message: 'Payment initiated', statusCode: response.statusCode ?? 200);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Payment failed');
    }
  }
}

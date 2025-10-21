import 'package:dio/dio.dart';
import 'package:valarpay/features/models/internet_models.dart';
import 'package:valarpay/core/network/api_client.dart';

class InternetRepository {
  final ApiClient apiClient;

  InternetRepository(this.apiClient);

  Future<InternetPlanResponse> getInternetPlans(
      {required String currency}) async {
    try {
      final response = await apiClient
          .get('/api/v1/bill/internet/get-plan', query: {'currency': currency});
      return InternetPlanResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to get internet plans');
    }
  }

  Future<InternetVariationResponse> getInternetVariation(
      {required String billerCode}) async {
    try {
      final response = await apiClient.get(
          '/api/v1/bill/internet/get-bill-info',
          query: {'billerCode': billerCode});
      return InternetVariationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to get internet variations');
    }
  }

  Future<InternetPaymentResponse> payInternet(
      InternetPayRequest request) async {
    try {
      final response = await apiClient.post('/api/v1/bill/internet/pay',
          data: request.toJson());
      if (response.data != null && response.data is Map<String, dynamic>) {
        return InternetPaymentResponse.fromJson(response.data);
      }
      return InternetPaymentResponse(
          message: 'Payment initiated', statusCode: response.statusCode ?? 200);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Payment failed');
    }
  }
}

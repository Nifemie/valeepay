import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/beneficiary_models.dart';
import 'package:valarpay/core/network/api_client.dart';

class BeneficiaryRepository {
  final ApiClient apiClient;

  BeneficiaryRepository(this.apiClient);

  Future<BeneficiariesResponse> getBeneficiaries({
    required String category,
    required String transferType,
    String? userId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'category': category,
        'transferType': transferType,
      };

      if (userId != null && userId.isNotEmpty) {
        queryParams['userId'] = userId;
      }

      final response = await apiClient.get(
        ApiEndpoints.getBeneficiaries,
        query: queryParams,
      );

      return BeneficiariesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

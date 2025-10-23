import 'package:dio/dio.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/change_password_models.dart';

class ChangePasswordRepository {
  final ApiClient apiClient;

  ChangePasswordRepository(this.apiClient);

  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.changePassword,
        data: request.toJson(),
      );
      return ChangePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to change password',
      );
    }
  }
}

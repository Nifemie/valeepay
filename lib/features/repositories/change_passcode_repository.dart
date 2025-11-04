import 'package:dio/dio.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/change_passcode_models.dart';

class ChangePasscodeRepository {
  final ApiClient apiClient;

  ChangePasscodeRepository(this.apiClient);

  Future<ChangePasscodeResponse> changePasscode(
    ChangePasscodeRequest request,
  ) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.changePasscode,
        data: request.toJson(),
      );
      return ChangePasscodeResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to change password',
      );
    }
  }
}

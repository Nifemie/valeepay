import 'package:dio/dio.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/decode_qr_response.dart';

class DecodeQrRepository {
  final ApiClient apiClient;

  DecodeQrRepository(this.apiClient);

  /// Decode a QR payload. The caller may pass either a raw QR string or a
  /// base64-encoded image string. We send whatever is provided as 'qrCode' and
  /// expect the backend to handle it.
  Future<DecodeQrResponse> decodeQr(String qrPayload) async {
    try {
      final body = {'qrCode': qrPayload};
      final response = await apiClient.post(
        ApiEndpoints.decodeQRCode,
        data: body,
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception(response.data['message'] ?? 'No data returned');
      }

      return DecodeQrResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to decode QR');
    }
  }
}

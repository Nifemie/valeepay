import 'dart:io';

import 'package:dio/dio.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/features/models/api_response.dart';

class ReportScamRepository {
  final ApiClient apiClient;

  ReportScamRepository(this.apiClient);

  Future<ApiResponse> submitReport({
    required String title,
    required String description,
    File? screenshot,
  }) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('title', title));
      formData.fields.add(MapEntry('description', description));

      if (screenshot != null) {
        final fileName = screenshot.path.split(Platform.pathSeparator).last;
        formData.files.add(MapEntry(
          'screenshot',
          await MultipartFile.fromFile(screenshot.path, filename: fileName),
        ));
      }

      final response = await apiClient.postFormData(
        ApiEndpoints.reportScam,
        data: formData,
      );

      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to submit report');
    }
  }
}

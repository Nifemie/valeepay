import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/constants/api_endpoints.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/api_response.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class UpdateDetailsNotifier extends StateNotifier<DataState<String>> {
  final ApiClient apiClient;

  UpdateDetailsNotifier(this.apiClient) : super(DataState<String>.initial());

  /// update profile details and update state

  Future<ApiResponse> updateUserName(String userName, String fullName) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final response = await apiClient.put(
        ApiEndpoints.editProfile,
        data: {"username": userName, "fullName": fullName},
      );
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: response.data,
      );

      if (response.statusCode != 200) {
        throw Exception(
          response.data?['message'] ?? 'Failed to update username',
        );
      }
      // Success - backend returns message. Caller may refresh profile afterwards.
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to update username',
      );
    } catch (e, stack) {
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
      throw Exception('Failed to update username: $e');
    }
  }
}

final updateDetailsNotifierProvider =
    StateNotifierProvider<UpdateDetailsNotifier, DataState<String>>(
  (ref) => UpdateDetailsNotifier(ref.read(apiClientProvider)),
);

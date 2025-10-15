import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/user.dart';
import 'package:valarpay/features/repositories/auth_repository.dart';

class AuthNotifier extends StateNotifier<DataState<UserModel>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(DataState<UserModel>.initial());

  /// 🔹 Normal Email/Password Login
  Future<void> login(LoginRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.login(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res.user],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Login Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  Future<void> loginWithPasscode(PasscodeLoginRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.loginWithPasscode(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res.user],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Passcode Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  void reset() => state = DataState<UserModel>.initial();
}

// 🔹 Providers
final apiClientProvider = Provider((ref) => ApiClient());

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.read(apiClientProvider)),
);

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, DataState<UserModel>>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);

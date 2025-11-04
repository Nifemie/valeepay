import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/username_request.dart';
import 'package:valarpay/features/models/verify_otp_request.dart';
import 'package:valarpay/features/repositories/auth_repository.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class AuthNotifier extends StateNotifier<DataState<LoginResponse>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(DataState<LoginResponse>.initial());

  /// 🔹 Normal Email/Password Login
  Future<void> login(LoginRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.login(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res],
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
        data: [res],
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

  Future<void> resend2fa(UsernameRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.resend2fa(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier 2fa Sending Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  Future<void> verify2fa(VerifyOtpRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.verify2fa(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier 2fa Verification Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  void reset() => state = DataState<LoginResponse>.initial();
}

// 🔹 Providers


final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.read(apiClientProvider)),
);

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, DataState<LoginResponse>>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);

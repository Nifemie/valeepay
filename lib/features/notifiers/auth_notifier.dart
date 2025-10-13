import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/models/user.dart';
import '../repositories/auth_repository.dart';

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
        message: 'Login failed: ${e.toString()}',
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
        message: 'Passcode login failed: ${e.toString()}',
      );
    }
  }

  Future<void> signUp(SignUpRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.signUp(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res.user],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier SignUp Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Sign up failed: ${e.toString()}',
      );
    }
  }

  Future<void> resendVerificationCode(String email) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.resendVerificationCode(email);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Resend Code Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to resend verification code: ${e.toString()}',
      );
    }
  }

  Future<void> verifyEmail(String email, String otpCode) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.verifyEmail(email, otpCode);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Verify Email Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Email verification failed: ${e.toString()}',
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.forgotPassword(email);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Forgot Password Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to send reset link: ${e.toString()}',
      );
    }
  }

  Future<void> verifyForgotPassword(String email, String otp) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.verifyForgotPassword(email, otp);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Verify OTP Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to verify OTP: ${e.toString()}',
      );
    }
  }

  Future<void> resetPassword(String email, String otp, String password) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.resetPassword(email, otp, password);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Reset Password Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to reset password: ${e.toString()}',
      );
    }
  }

  Future<void> registerBusiness(SignUpRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.registerBusiness(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res.user],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[AuthNotifier Register Business Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Business registration failed: ${e.toString()}',
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

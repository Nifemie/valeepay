// ignore: file_names
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/email_request.dart';
import 'package:valarpay/features/models/forgot_password.dart';
import 'package:valarpay/features/models/reset_password.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/models/user.dart';
import 'package:valarpay/features/models/verify_email_request.dart';
import 'package:valarpay/features/models/verify_forgot_password.dart';
import 'package:valarpay/features/repositories/auth_repository.dart';

class UserNotifier extends StateNotifier<DataState<UserModel>> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(DataState<UserModel>.initial());

  Future<void> register(SignUpRequest request) async {
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
      log('[UserNotifier SignUp Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Sign up failed: ${e.toString()}',
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
      log('[UserNotifier Register Business Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Business registration failed: ${e.toString()}',
      );
    }
  }

  Future<void> validateEmail(EmailRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.validateEmail(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[UserNotifier Resend Code Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to resend verification code: ${e.toString()}',
      );
    }
  }

  Future<void> verifyEmail(VerifyEmailRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.verifyEmail(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[UserNotifier Verify Email Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Email verification failed: ${e.toString()}',
      );
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.forgotPassword(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[UserNotifier Forgot Password Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to send reset link: ${e.toString()}',
      );
    }
  }

  Future<void> verifyForgotPassword(VerifyForgotPassword request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.verifyForgotPassword(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[UserNotifier Verify OTP Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to verify OTP: ${e.toString()}',
      );
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.resetPassword(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[UserNotifier Reset Password Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to reset password: ${e.toString()}',
      );
    }
  }

  void reset() => state = DataState<UserModel>.initial();
}

// 🔹 Providers
final apiClientProvider = Provider((ref) => ApiClient());

final userRepositoryProvider = Provider(
  (ref) => UserRepository(ref.read(apiClientProvider)),
);

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, DataState<UserModel>>(
  (ref) => UserNotifier(ref.read(userRepositoryProvider)),
);

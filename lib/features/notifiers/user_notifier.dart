// ignore: file_names
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/bvn_initialize_request.dart';
import 'package:valarpay/features/models/bvn_initialize_response.dart';
import 'package:valarpay/features/models/bvn_validate_request.dart';
import 'package:valarpay/features/models/bvn_validate_response.dart';
import 'package:valarpay/features/models/email_request.dart';
import 'package:valarpay/features/models/set_wallet_pin_request.dart';
import 'package:valarpay/features/models/set_wallet_pin_response.dart';
import 'package:valarpay/features/models/forgot_password.dart';
import 'package:valarpay/features/models/phone_number_request.dart';
import 'package:valarpay/features/models/reset_password.dart';
import 'package:valarpay/features/models/signup_request.dart';
import 'package:valarpay/features/models/user.dart';
import 'package:valarpay/features/models/user_availablity_request.dart';
import 'package:valarpay/features/models/verify_email_request.dart';
import 'package:valarpay/features/models/verify_forgot_password.dart';
import 'package:valarpay/features/models/verify_phone_number.dart';
import 'package:valarpay/features/repositories/user_repository.dart';

class UserNotifier extends StateNotifier<DataState<UserModel>> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(DataState<UserModel>.initial());

  Future<void> register(SignUpRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.register(request);
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
        message: e.toString(),
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
        message: e.toString(),
      );
    }
  }

  Future<void> checkUserExistance(UserAvailabilityRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.checkUserExistance(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[UserNotifier Availablity Check Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
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
        message: e.toString(),
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
        message: e.toString(),
      );
    }
  }

  Future<void> validatePhone(PhoneNumberRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.validatePhone(request);
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
        message: e.toString(),
      );
    }
  }

  Future<void> verifyPhone(VerifyPhoneOtpRequest request) async {
    log(request.phoneNumber.toString());
    log(request.otpCode.toString());

    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.verifyPhone(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[UserNotifier Verify Phone Number Error] $e\n$stack');
      log(e.toString());
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
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
        message: e.toString(),
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
        message: e.toString(),
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
        message: e.toString(),
      );
    }
  }

  Future<BvnInitializeResponse?> initializeBvn(
      BvnInitializeRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.initializeBvn(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
      return res; // Return the response so caller can access verificationId
    } catch (e, stack) {
      log('[UserNotifier BVN Initialize Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
      return null;
    }
  }

  Future<BvnValidateResponse?> validateBvn(BvnValidateRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.validateBvn(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
      return res;
    } catch (e, stack) {
      log('[UserNotifier BVN Validate Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
      return null;
    }
  }

  Future<SetWalletPinResponse?> setWalletPin(
      SetWalletPinRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.setWalletPin(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: res.message,
      );
      return res;
    } catch (e, stack) {
      log('[UserNotifier Set Wallet PIN Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
      return null;
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

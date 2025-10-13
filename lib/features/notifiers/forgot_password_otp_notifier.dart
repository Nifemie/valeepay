import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordOtpNotifier extends StateNotifier<String?> {
  ForgotPasswordOtpNotifier() : super(null);

  void setOtp(String otp) {
    state = otp;
  }
}

final forgotPasswordOtpNotifierProvider =
    StateNotifierProvider<ForgotPasswordOtpNotifier, String?>(
  (ref) => ForgotPasswordOtpNotifier(),
);

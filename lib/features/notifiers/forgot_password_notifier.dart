import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordNotifier extends StateNotifier<String?> {
  ForgotPasswordNotifier() : super(null);

  void setEmail(String email) {
    state = email;
  }
}

final forgotPasswordNotifierProvider =
    StateNotifierProvider<ForgotPasswordNotifier, String?>(
  (ref) => ForgotPasswordNotifier(),
);

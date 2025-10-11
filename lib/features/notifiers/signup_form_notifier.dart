
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/models/signup_request.dart';

class SignUpFormNotifier extends StateNotifier<SignUpRequest> {
  SignUpFormNotifier() : super(const SignUpRequest());

  void saveAccountInfo({required String accountType, required String countryCode}) {
    state = state.copyWith(accountType: accountType, countryCode: countryCode);
  }

  void savePersonalDetails({String? fullname, String? username, String? dateOfBirth, String? referralCode}) {
    state = state.copyWith(fullname: fullname, username: username, dateOfBirth: dateOfBirth, referralCode: referralCode);
  }

  void saveEmailAndPassword({required String email, required String password}) {
    state = state.copyWith(email: email, password: password);
  }
}

final signUpFormNotifierProvider =
    StateNotifierProvider<SignUpFormNotifier, SignUpRequest>(
  (ref) => SignUpFormNotifier(),
);

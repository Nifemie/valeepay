import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class for the Passcode
@immutable
class PasscodeState {
  const PasscodeState({this.passcode = '', this.confirmPasscode = ''});

  final String passcode;
  final String confirmPasscode;

  PasscodeState copyWith({String? passcode, String? confirmPasscode}) {
    return PasscodeState(
      passcode: passcode ?? this.passcode,
      confirmPasscode: confirmPasscode ?? this.confirmPasscode,
    );
  }
}

// State Notifier for the Passcode
class PasscodeNotifier extends StateNotifier<PasscodeState> {
  PasscodeNotifier() : super(const PasscodeState());

  void updatePasscode(String passcode) {
    state = state.copyWith(passcode: passcode);
  }

  void updateConfirmPasscode(String confirmPasscode) {
    state = state.copyWith(confirmPasscode: confirmPasscode);
  }

  bool isPasscodeValid() {
    return state.passcode.length == 6;
  }

  bool isConfirmPasscodeValid() {
    return state.confirmPasscode.length == 6;
  }

  bool doPasscodesMatch() {
    return state.passcode.isNotEmpty &&
        state.confirmPasscode.isNotEmpty &&
        state.passcode == state.confirmPasscode;
  }

  void clearAllPasscodes() {
    state = const PasscodeState();
  }

  void clearConfirmPasscode() {
    state = state.copyWith(confirmPasscode: '');
  }

  void clearPasscode() {
    state = state.copyWith(passcode: '');
  }

  void submitSetupPasscode(BuildContext context,
      {required VoidCallback onSuccess}) {
    if (isPasscodeValid()) {
      onSuccess();
    }
  }

  void submitConfirmPasscode(BuildContext context,
      {required VoidCallback onSuccess, required VoidCallback onError}) {
    if (isConfirmPasscodeValid()) {
      if (doPasscodesMatch()) {
        onSuccess();
      } else {
        onError();
      }
    }
  }

  // Validate passcode format (6 digits, numeric only)
  bool validatePasscodeFormat(String passcode) {
    if (passcode.length != 6) return false;
    return RegExp(r'^\d{6}$').hasMatch(passcode);
  }

  // Get passcode strength (optional, for UI feedback)
  PasscodeStrength getPasscodeStrength(String passcode) {
    if (passcode.length < 6) return PasscodeStrength.invalid;

    // Check for weak patterns
    if (passcode == '000000' ||
        passcode == '111111' ||
        passcode == '222222' ||
        passcode == '333333' ||
        passcode == '444444' ||
        passcode == '555555' ||
        passcode == '666666' ||
        passcode == '777777' ||
        passcode == '888888' ||
        passcode == '999999') {
      return PasscodeStrength.weak;
    }

    if (passcode == '123456' ||
        passcode == '654321' ||
        passcode == '012345' ||
        passcode == '543210') {
      return PasscodeStrength.weak;
    }

    // Check for consecutive numbers
    bool hasConsecutive = true;
    for (int i = 0; i < passcode.length - 1; i++) {
      int current = int.parse(passcode[i]);
      int next = int.parse(passcode[i + 1]);
      if ((next - current).abs() != 1) {
        hasConsecutive = false;
        break;
      }
    }
    if (hasConsecutive) return PasscodeStrength.weak;

    // Check for all same digits
    if (passcode.split('').toSet().length == 1) {
      return PasscodeStrength.weak;
    }

    // Check for medium strength (has some variation)
    if (passcode.split('').toSet().length >= 3) {
      return PasscodeStrength.medium;
    }

    return PasscodeStrength.strong;
  }

  // TODO: Add backend API integration methods here
  // Future<void> savePasscodeToBackend(String passcode) async {
  //   // Call backend API to save passcode
  // }
  //
  // Future<bool> verifyPasscodeWithBackend(String passcode) async {
  //   // Call backend API to verify passcode
  // }
  //
  // Future<void> updatePasscodeOnBackend(String oldPasscode, String newPasscode) async {
  //   // Call backend API to update passcode
  // }
  //
  // Future<void> deletePasscodeFromBackend() async {
  //   // Call backend API to delete passcode
  // }
}

// Passcode strength enum
enum PasscodeStrength {
  invalid,
  weak,
  medium,
  strong,
}

// Passcode Controller Provider
final passcodeControllerProvider =
    StateNotifierProvider<PasscodeNotifier, PasscodeState>((ref) {
  return PasscodeNotifier();
});

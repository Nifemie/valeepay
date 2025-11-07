import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valarpay/core/utils/logger.dart';

// State class for the PIN
@immutable
class PinState {
  const PinState({this.pin = '', this.confirmPin = ''});

  final String pin;
  final String confirmPin;

  PinState copyWith({String? pin, String? confirmPin}) {
    return PinState(
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
    );
  }
}

// State Notifier for the PIN
class PinNotifier extends StateNotifier<PinState> {
  PinNotifier() : super(const PinState());

  void updatePin(String pin) {
    state = state.copyWith(pin: pin);
  }

  void updateConfirmPin(String confirmPin) {
    state = state.copyWith(confirmPin: confirmPin);
  }

  bool isPinValid() {
    return state.pin.length == 4;
  }

  bool isConfirmPinValid() {
    return state.confirmPin.length == 4;
  }

  bool doPinsMatch() {
    return state.pin.isNotEmpty &&
        state.confirmPin.isNotEmpty &&
        state.pin == state.confirmPin;
  }

  void clearAllPins() {
    state = const PinState();
  }

  void clearConfirmPin() {
    state = state.copyWith(confirmPin: '');
  }

  void submitSetupPin(BuildContext context, {required VoidCallback onSuccess}) {
    if (isPinValid()) {
      onSuccess();
    }
  }

  void submitConfirmPin(
    BuildContext context, {
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) {
    if (isConfirmPinValid()) {
      if (doPinsMatch()) {
        onSuccess();
      } else {
        onError();
      }
    }
  }

  Future<void> savePinSecurely(String pin) async {
    // TODO: Use flutter_secure_storage for production
    // For now, using SharedPreferences (less secure but functional)
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('wallet_pin', pin);
      AppLogger.log('Saving PIN securely: $pin');
      AppLogger.log('✅ PIN saved to local storage');
    } catch (e) {
      AppLogger.log('❌ Error saving PIN: $e');
    }
  }

  Future<String?> getStoredPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('wallet_pin');
    } catch (e) {
      AppLogger.log('❌ Error reading PIN: $e');
      return null;
    }
  }

  Future<bool> validateStoredPin(String enteredPin) async {
    final storedPin = await getStoredPin();
    return storedPin == enteredPin;
  }

  Future<void> clearStoredPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('wallet_pin');
      AppLogger.log('✅ PIN cleared from local storage');
    } catch (e) {
      AppLogger.log('❌ Error clearing PIN: $e');
    }
  }
}

// PIN Controller Provider
final pinControllerProvider = StateNotifierProvider<PinNotifier, PinState>((
  ref,
) {
  return PinNotifier();
});

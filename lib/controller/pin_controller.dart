import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return state.pin.isNotEmpty && state.confirmPin.isNotEmpty && state.pin == state.confirmPin;
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

  void submitConfirmPin(BuildContext context, {required VoidCallback onSuccess, required VoidCallback onError}) {
    if (isConfirmPinValid()) {
      if (doPinsMatch()) {
        onSuccess();
      } else {
        onError();
      }
    }
  }

  Future<void> savePinSecurely(String pin) async {
    // TODO: Implement secure storage
    print('Saving PIN securely: $pin');
  }
}

// PIN Controller Provider
final pinControllerProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  return PinNotifier();
});
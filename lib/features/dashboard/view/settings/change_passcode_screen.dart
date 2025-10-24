import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/controller/passcode_controller.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/features/notifiers/change_passcode_notifier.dart';

class ChangePassCodeScreen extends ConsumerStatefulWidget {
  const ChangePassCodeScreen({super.key});

  @override
  ConsumerState<ChangePassCodeScreen> createState() =>
      _ChangePassCodeScreenState();
}

class _ChangePassCodeScreenState extends ConsumerState<ChangePassCodeScreen> {
  final int _passcodeLength = 6;
  int _stepIndex = 0; // 0=current,1=new,2=confirm new
  bool _isSaving = false;

  void _onNumberPressed(String number) {
    final controller = ref.read(passcodeControllerProvider.notifier);
    final state = ref.read(passcodeControllerProvider);

    if (_stepIndex == 0) {
      if (state.passcode.length < _passcodeLength) {
        controller.updatePasscode(state.passcode + number);
        if (state.passcode.length + 1 == _passcodeLength) {
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() => _stepIndex = 1);
            controller.clearConfirmPasscode();
            controller.clearConfirmNewPasscode();
          });
        }
      }
    } else if (_stepIndex == 1) {
      if (state.confirmPasscode.length < _passcodeLength) {
        controller.updateConfirmPasscode(state.confirmPasscode + number);
        if (state.confirmPasscode.length + 1 == _passcodeLength) {
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() => _stepIndex = 2);
          });
        }
      }
    } else {
      if (state.confirmNewPasscode.length < _passcodeLength) {
        controller.updateConfirmNewPasscode(state.confirmNewPasscode + number);
        if (state.confirmNewPasscode.length + 1 == _passcodeLength) {
          final oldPin = state.passcode;
          final newPin = state.confirmPasscode;
          final confirm = state.confirmNewPasscode + number;
          if (newPin == confirm) {
            _submitChange(oldPin, newPin);
          } else {
            AppMessenger.show(context,
                message: 'New passcodes do not match', type: MessageType.error);
            ref
                .read(passcodeControllerProvider.notifier)
                .clearConfirmNewPasscode();
            setState(() => _stepIndex = 1);
          }
        }
      }
    }
  }

  void _onDeletePressed() {
    final controller = ref.read(passcodeControllerProvider.notifier);
    final state = ref.read(passcodeControllerProvider);
    if (_stepIndex == 0) {
      if (state.passcode.isNotEmpty) {
        controller.updatePasscode(
            state.passcode.substring(0, state.passcode.length - 1));
      }
    } else if (_stepIndex == 1) {
      if (state.confirmPasscode.isNotEmpty) {
        controller.updateConfirmPasscode(state.confirmPasscode
            .substring(0, state.confirmPasscode.length - 1));
      }
    } else {
      if (state.confirmNewPasscode.isNotEmpty) {
        controller.updateConfirmNewPasscode(state.confirmNewPasscode
            .substring(0, state.confirmNewPasscode.length - 1));
      }
    }
  }

  Future<void> _submitChange(String oldPin, String newPin) async {
    if (oldPin.length != 6 || newPin.length != 6) return;

    setState(() => _isSaving = true);
    try {
      final notifier = ref.read(changePasscodeNotifierProvider.notifier);
      await notifier.changePasscode(oldPasscode: oldPin, newPasscode: newPin);

      final state = ref.read(changePasscodeNotifierProvider);
      if (state.isDataAvailable) {
        AppMessenger.show(context,
            message: state.message ?? 'Passcode updated',
            type: MessageType.success);
        ref.read(passcodeControllerProvider.notifier).clearAllPasscodes();
        context.pop();
      } else {
        AppMessenger.show(context,
            message: state.message ?? 'Failed to change passcode',
            type: MessageType.error);
        ref.read(passcodeControllerProvider.notifier).clearAllPasscodes();
        setState(() => _stepIndex = 0);
      }
    } catch (e) {
      AppMessenger.show(context,
          message: 'Failed: ${e.toString()}', type: MessageType.error);
      ref.read(passcodeControllerProvider.notifier).clearAllPasscodes();
      setState(() => _stepIndex = 0);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final passcodeState = ref.watch(passcodeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
                _stepIndex == 0
                    ? 'Enter Current Passcode'
                    : (_stepIndex == 1
                        ? 'Enter New Passcode'
                        : 'Confirm New Passcode'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                _stepIndex == 0
                    ? 'Enter your current 6-digit passcode'
                    : (_stepIndex == 1
                        ? 'Enter your new 6-digit passcode'
                        : 'Confirm the new 6-digit passcode'),
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),

            // dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_passcodeLength, (index) {
                final current = _stepIndex == 0
                    ? passcodeState.passcode
                    : (_stepIndex == 1
                        ? passcodeState.confirmPasscode
                        : passcodeState.confirmNewPasscode);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: index < current.length
                        ? appTheme.primaryColor
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            const Spacer(),

            if (_isSaving)
              const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator()),

            if (!_isSaving) SizedBox(height: 24),

            _buildNumberPad(),

            const SizedBox(height: 24),
            if (_stepIndex != 0)
              TextButton(
                  onPressed: () {
                    ref
                        .read(passcodeControllerProvider.notifier)
                        .clearAllPasscodes();
                    setState(() => _stepIndex = 0);
                  },
                  child: const Text('Start Over')),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    final numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'del'
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          final item = numbers[index];
          if (item.isEmpty) return const SizedBox.shrink();
          if (item == 'del') return _buildDeleteButton();
          return _buildNumberButton(item);
        },
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            shape: BoxShape.circle),
        child: Center(
            child: Text(number,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w600))),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.backspace_outlined, size: 24)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

import '../../../../core/widgets/pin_input_fields.dart';
import '../../../../controller/pin_controller.dart';
import '../../widgets/Kyc/Dialog/passcode_success.dart';
import '../KYC/KYCSetupPage.dart';

class ConfirmTransactionPinPage extends ConsumerWidget {
  const ConfirmTransactionPinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(pinControllerProvider);
    final isFormValid =
        ref.read(pinControllerProvider.notifier).isConfirmPinValid();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Title
              const Text(
                'Confirm Your Transaction Pin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                'Re-enter your 4-digit PIN to always authorize and secure every transaction',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              const SizedBox(height: 40),
              // PIN Input Boxes
              PinInputField(
                onChanged: (value) {
                  ref
                      .read(pinControllerProvider.notifier)
                      .updateConfirmPin(value);
                },
              ),
              const SizedBox(height: 40),
              // Continue Button
              FullWidthButton(
                text: 'Continue',
                isEnabled: isFormValid,
                onPressed: () {
                  ref.read(pinControllerProvider.notifier).submitConfirmPin(
                    context,
                    onSuccess: () async {
                      // Save PIN securely
                      await ref
                          .read(pinControllerProvider.notifier)
                          .savePinSecurely(pinState.pin);

                      // Show success dialog
                      _showSuccessDialog(context, ref);
                    },
                    onError: () {
                      _showPinMismatchDialog(context, ref);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PasscodeSuccessDialog(
          onDone: () {
            // Clear all PINs from state
            ref.read(pinControllerProvider.notifier).clearAllPins();

            // Navigate back to KYC Setup Page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const KYCSetupPage()),
              (route) => route.isFirst,
            );
          },
        );
      },
    );
  }

  void _showPinMismatchDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PINs do not match. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontFamily: 'SF Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontFamily: 'SF Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF76301),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Clear only the confirm PIN field
                            ref
                                .read(pinControllerProvider.notifier)
                                .clearConfirmPin();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Try Again',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SF Pro',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

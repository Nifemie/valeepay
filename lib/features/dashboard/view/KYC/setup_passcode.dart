import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

import '../../../../core/widgets/pin_input_fields.dart';
import '../../../../controller/pin_controller.dart';
import 'confirm_transaction_pin_page.dart';

class SetupTransactionPinPage extends ConsumerWidget {
  const SetupTransactionPinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFormValid = ref.read(pinControllerProvider.notifier).isPinValid();

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
                'Set Up Your Transaction Pin',
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
                'Create a secure 4-digit PIN to always authorize your transactions safely',
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
                  ref.read(pinControllerProvider.notifier).updatePin(value);
                },
              ),
              const SizedBox(height: 40),
              // Continue Button
              FullWidthButton(
                text: 'Continue',
                isEnabled: isFormValid,
                onPressed: () {
                  ref.read(pinControllerProvider.notifier).submitSetupPin(
                    context,
                    onSuccess: () {
                      // Navigate to confirm PIN page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ConfirmTransactionPinPage(),
                        ),
                      );
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
}

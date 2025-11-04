import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import '../../../../controller/pin_controller.dart';
import 'confirm_transaction_pin_page.dart';

class SetupTransactionPinPage extends ConsumerStatefulWidget {
  const SetupTransactionPinPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SetupTransactionPinPage> createState() =>
      _SetupTransactionPinPageState();
}

class _SetupTransactionPinPageState
    extends ConsumerState<SetupTransactionPinPage> {
  @override
  Widget build(BuildContext context) {
    final pinNotifier = ref.read(pinControllerProvider.notifier);
    final pinState = ref.watch(pinControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Set Up Your Transaction Pin',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a secure 4-digit PIN to authorize your transactions safely',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),

             PinFieldAutoFill(
              codeLength: 4,
              currentCode: pinState.pin,
              decoration: BoxLooseDecoration(
                gapSpace: 12,
                strokeColorBuilder: FixedColorBuilder(Colors.grey.shade400),
                bgColorBuilder: FixedColorBuilder(
                  Colors.grey.shade50.withOpacity(0.8),
                ),
                radius: const Radius.circular(8),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                strokeWidth: 1.4,
              ),
              onCodeChanged: (code) {
                if (code != null && code.length <= 4) {
                  Future.microtask(() {
                    pinNotifier.updatePin(code);
                  });
                }
              },
            ),

            const SizedBox(height: 40),

            /// Continue button
            FullWidthButton(
              text: 'Continue',
              isEnabled: pinNotifier.isPinValid(),
              onPressed:
                  pinNotifier.isPinValid()
                      ? () {
                        pinNotifier.submitSetupPin(
                          context,
                          onSuccess: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => const ConfirmTransactionPinPage(),
                              ),
                            );
                          },
                        );
                      }
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';

class PasscodeSuccessDialog extends StatelessWidget {
  final VoidCallback onDone;

  const PasscodeSuccessDialog({Key? key, required this.onDone})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Passcode Set Successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111827),
                fontFamily: 'SF Pro',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // Description
            const Text(
              'Your passcode has been created. You\'ll now use it to authorize actions securely',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Done Button
            FullWidthButton(
              text: 'Continue',
              onPressed: onDone,
            ),
          ],
        ),
      ),
    );
  }
}

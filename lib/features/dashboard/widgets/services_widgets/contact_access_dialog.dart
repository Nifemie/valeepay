import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/responsive_button.dart';
import 'package:valarpay/core/themes/color_utils.dart';

class ContactAccessDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onCancel;

  const ContactAccessDialog({
    super.key,
    required this.onAllow,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Allow ValarPay to access your contacts so you can easily pick phone numbers without typing them manually',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ResponsiveButton(
                    text: 'No, Cancel',
                    isOutlined: true,
                    textColor: Colors.grey,
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ResponsiveButton(
                    text: 'Yes, Continue',
                    backgroundColor: appTheme.primaryColor,
                    onPressed: onAllow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

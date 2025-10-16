import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';

enum MessageType { success, error, warning, info }

class AppMessenger {
  static void show(
    BuildContext context, {
    required String message,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color background;
    IconData icon;

    switch (type) {
      case MessageType.success:
        background = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case MessageType.error:
        background = Colors.redAccent;
        icon = Icons.error_outline;
        break;
      case MessageType.warning:
        background = Colors.orangeAccent;
        icon = Icons.warning_amber_outlined;
        break;
      case MessageType.info:
      background = appTheme.primaryColor;
        icon = Icons.info_outline;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: appTheme.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

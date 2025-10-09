import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class CustomToast {
  static FToast? _fToast;

  static void _ensureInitialized(BuildContext context) {
    if (_fToast == null) {
      _fToast = FToast();
      _fToast!.init(context);
    }
  }

  static void showToast({
    required BuildContext context,
    required String message,
    String? iconPath,
    Duration duration = const Duration(seconds: 3),
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
  }) {
    _ensureInitialized(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor ?? const Color(0xFF2D2D2D),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: iconPath.endsWith('.svg')
                    ? SvgPicture.asset(
                        iconPath,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      )
                    : Image.asset(
                        iconPath,
                        width: 16,
                        height: 16,
                      ),
              ),
            ),
            const SizedBox(width: 12.0),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    _fToast!.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: duration,
    );
  }

  static void showSuccessToast({
    required BuildContext context,
    required String message,
    String? iconPath,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      iconPath: iconPath ?? 'assets/images/VALAR PAY LOGOO.png',
      backgroundColor: const Color(0xFF4CAF50),
      duration: duration,
    );
  }

  static void showErrorToast({
    required BuildContext context,
    required String message,
    String? iconPath,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      iconPath: iconPath ?? 'assets/images/VALAR PAY LOGOO.png',
      backgroundColor: const Color(0xFFE53E3E),
      duration: duration,
    );
  }

  static void showInfoToast({
    required BuildContext context,
    required String message,
    String? iconPath,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      iconPath: iconPath ?? 'assets/images/VALAR PAY LOGOO.png',
      backgroundColor: const Color(0xFF2196F3),
      duration: duration,
    );
  }

  static void showWarningToast({
    required BuildContext context,
    required String message,
    String? iconPath,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      iconPath: iconPath ?? 'assets/images/VALAR PAY LOGOO.png',
      backgroundColor: appTheme.primaryColor,
      duration: duration,
    );
  }

  static void showAppToast({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      context: context,
      message: message,
      iconPath: 'assets/images/VALAR PAY LOGOO.png', // Your app logo
      backgroundColor: const Color(0xFF2D2D2D),
      duration: duration,
    );
  }

  static void cancel() {
    _fToast?.removeCustomToast();
  }
}

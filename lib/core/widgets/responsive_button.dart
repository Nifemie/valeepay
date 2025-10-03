import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/responsive_utils.dart';
import 'package:valarpayee/core/utils/color_utils.dart';

class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final IconData? icon;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            padding: ResponsiveUtils.paddingVertical16,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: ResponsiveUtils.borderRadius8,
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? appTheme.primaryColor,
            padding: ResponsiveUtils.paddingVertical16,
            shape: RoundedRectangleBorder(
              borderRadius: ResponsiveUtils.borderRadius8,
            ),
          );

    final buttonText = Text(
      text,
      style: ResponsiveUtils.buttonText.copyWith(
        color: textColor ?? (isOutlined ? Colors.black : Colors.white),
      ),
    );

    final buttonChild = isLoading
        ? SizedBox(
            width: ResponsiveUtils.iconSize20,
            height: ResponsiveUtils.iconSize20,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation<Color>(
                textColor ?? (isOutlined ? Colors.black : Colors.white),
              ),
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: ResponsiveUtils.iconSize18,
                    color:
                        textColor ?? (isOutlined ? Colors.black : Colors.white),
                  ),
                  SizedBox(width: ResponsiveUtils.width8),
                  buttonText,
                ],
              )
            : buttonText;

    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: buttonChild,
            ),
    );
  }
}

// Usage examples:
/*
ResponsiveButton(
  text: 'Continue',
  onPressed: () => context.push('/next-screen'),
)

ResponsiveButton(
  text: 'Login with Passcode',
  isOutlined: true,
  onPressed: () => context.push('/passcode-login'),
)

ResponsiveButton(
  text: 'Login with Biometrics',
  icon: Icons.fingerprint,
  onPressed: () => context.push('/biometric-login'),
)

ResponsiveButton(
  text: 'Loading...',
  isLoading: true,
  onPressed: null,
)
*/

import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:go_router/go_router.dart';
class TermsAndConditionsWidget extends StatelessWidget {
  const TermsAndConditionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'By clicking Continue, you agree to our ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.push('/terms-and-conditions');
            },
            child: Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 14,
                color: appTheme.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(
            ' and ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.push('/privacy-policy');
            },
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 14,
                color: appTheme.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

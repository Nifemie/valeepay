import 'package:flutter/material.dart';

class ReuseableAppbarTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const ReuseableAppbarTextButton({required this.onTap, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
            onPressed: onTap,
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFFF76301),
                fontSize: 14,
              ),
            ),
          );
  }
}
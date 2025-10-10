import 'package:flutter/material.dart';

class ReuseableTextFieldWithCountry extends StatelessWidget {
  String? flagImagePath;
  String? countryCode;
  TextEditingController controller;
  Widget? suffixWidget;
  bool isReadOnly;
  String hintText;
  bool showCountryLabel;
  TextInputType textInputType;
  ReuseableTextFieldWithCountry(
      {this.countryCode,
      this.flagImagePath,
      required this.controller,
      required this.hintText,
      required this.isReadOnly,
      required this.textInputType,
      this.suffixWidget,
      required this.showCountryLabel,
      super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        if (showCountryLabel)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (flagImagePath != null)
                  Container(
                    width: 24,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Image.asset(flagImagePath!, fit: BoxFit.cover),
                  ),
                const SizedBox(width: 8),
                if (countryCode != null)
                  Text(
                    countryCode!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
        if (showCountryLabel) const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: textInputType,
                    readOnly: isReadOnly,
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                if (suffixWidget != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: suffixWidget!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

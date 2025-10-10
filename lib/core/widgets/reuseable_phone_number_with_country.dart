import 'package:flutter/material.dart';

class ReuseablePhoneNumberWithCountry extends StatelessWidget {
  String flagImagePath;
  String countryCode;
  TextEditingController phoneController;
  Widget? suffixWidget;
  bool showCountryLabel;
   ReuseablePhoneNumberWithCountry({required this.countryCode, required this.flagImagePath, required this.phoneController, this.suffixWidget, required this.showCountryLabel, super.key});

  @override
  Widget build(BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

    return  Row(
              children: [
              if(showCountryLabel)  Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Image.asset(flagImagePath, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        countryCode,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if(showCountryLabel) const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: '123 456 789',
                      hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey[400]),
                      filled: true,
                      fillColor:
                          isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffix: suffixWidget
                    ),
                    
                  ),
                ),
              ],
            );

           
  }
}
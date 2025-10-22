import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReuseableAmountTextfield extends StatelessWidget {
  TextEditingController amountController;
  String prefixText;
  String hintText;
  ReuseableAmountTextfield(
      {required this.amountController,
      required this.prefixText,
      required this.hintText,
      super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            prefixText,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey[400]),
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

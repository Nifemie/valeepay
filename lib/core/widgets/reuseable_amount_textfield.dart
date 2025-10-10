import 'package:flutter/material.dart';

class ReuseableAmountTextfield extends StatelessWidget {
  TextEditingController amountController;
  String prefixText;
  String hintText;
   ReuseableAmountTextfield({required this.amountController, required this.prefixText, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(prefixText),
                  SizedBox(width: 5),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
  }
}
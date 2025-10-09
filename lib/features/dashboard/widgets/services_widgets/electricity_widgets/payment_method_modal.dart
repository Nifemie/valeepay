import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import '../../../view/services/electricity/transaction_success_screen.dart';

class PaymentMethodModal extends StatelessWidget {
  final Function(String) onPaymentMethodSelected;

  const PaymentMethodModal({
    super.key,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final paymentMethods = [
      {
        'name': 'Vconnect Bank',
        'icon': Icons.account_balance,
        'color': Colors.orange,
      },
      {
        'name': 'First Bank of Nigeria',
        'icon': Icons.account_balance,
        'color': Colors.blue,
      },
      {
        'name': 'Wema Bank',
        'icon': Icons.account_balance,
        'color': Colors.purple,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2725) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Pay Via',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Payment methods
          ...paymentMethods.map((method) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: method['color'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  method['icon'] as IconData,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                method['name'] as String,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.star,
                color: Color(0xFFF76301),
                size: 20,
              ),
              onTap: () {
                onPaymentMethodSelected(method['name'] as String);
              },
            );
          }).toList(),

          const SizedBox(height: 16),

          // Confirm Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final pin = await TransactionPinModal.show(context);
                  if (pin != null && pin.length == 4) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionSuccessScreen(
                          amount: '₦10,000',
                          transactionId: 'TXN123456789',
                          transactionDetails: {
                            'Meter Number': '0000000000',
                            'Disco': 'Benin Electricity',
                            'Meter Type': 'Prepaid',
                            'Amount': '₦10,000',
                            'Total Amount': '₦10,000',
                          },
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF76301),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

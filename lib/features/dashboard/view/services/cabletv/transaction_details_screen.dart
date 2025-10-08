import 'package:flutter/material.dart';
import '../../../widgets/services_widgets/cabletv_widgets/payment_method_modal.dart';

class CableTvTransactionDetailsScreen extends StatelessWidget {
  final Map<String, String> transactionData;

  const CableTvTransactionDetailsScreen({
    super.key,
    required this.transactionData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Transaction Details',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Transaction details container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Service Provider',
                      transactionData['provider'] ?? 'DStv', isDark),
                  _buildDetailRow(
                      'Smartcard Number',
                      transactionData['smartcardNumber'] ?? '0000000000',
                      isDark),
                  _buildDetailRow(
                      'Package', transactionData['plan'] ?? 'Compact+', isDark),
                  _buildDetailRow('Amount',
                      '₦${transactionData['amount'] ?? '6500'}', isDark),
                  const Divider(),
                  _buildDetailRow('Total Amount',
                      '₦${transactionData['amount'] ?? '6500'}', isDark,
                      isTotal: true),
                ],
              ),
            ),

            const Spacer(),

            // Pay Via section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay Via',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment methods
                  _buildPaymentMethod(
                    'Vconnect Bank',
                    Icons.account_balance,
                    Colors.orange,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethod(
                    'First Bank of Nigeria',
                    Icons.account_balance,
                    Colors.blue,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethod(
                    'Wema Bank',
                    Icons.account_balance,
                    Colors.purple,
                    isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentMethodModal(context);
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(
    String name,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        const Icon(
          Icons.star,
          color: Color(0xFFF76301),
          size: 20,
        ),
      ],
    );
  }

  void _showPaymentMethodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CableTvPaymentMethodModal(
        transactionData: transactionData,
        onPaymentMethodSelected: (method) {
          // Handle payment method selection
        },
      ),
    );
  }
}

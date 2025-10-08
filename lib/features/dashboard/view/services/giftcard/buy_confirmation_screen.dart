import 'package:flutter/material.dart';
import '/core/themes/color_utils.dart';
import '/features/dashboard/view/services/giftcard/pin_entry_screen.dart';

class BuyConfirmationScreen extends StatefulWidget {
  const BuyConfirmationScreen({super.key});

  @override
  State<BuyConfirmationScreen> createState() => _BuyConfirmationScreenState();
}

class _BuyConfirmationScreenState extends State<BuyConfirmationScreen> {
  String selectedPaymentMethod = 'Gateway Bank';

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
          'Confirm Purchase',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purchase Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Card Type', 'Apple iTunes', isDark),
                  _buildDetailRow('Country', 'United Kingdom', isDark),
                  _buildDetailRow('Card Amount', '£10', isDark),
                  _buildDetailRow('Quantity', '1', isDark),
                  _buildDetailRow('Total Amount', '₦50,000', isDark),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pay Via Section
            Text(
              'Pay Via',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Payment Methods
            _buildPaymentMethodTile(
              'Gateway Bank',
              '0000000000',
              Icons.account_balance,
              Colors.orange,
              isDark,
            ),

            const SizedBox(height: 8),

            _buildPaymentMethodTile(
              'First Bank of Nigeria',
              '0123456789',
              Icons.account_balance,
              Colors.blue,
              isDark,
            ),

            const SizedBox(height: 8),

            _buildPaymentMethodTile(
              'Wema Bank',
              '0000000000',
              Icons.account_balance,
              Colors.purple,
              isDark,
            ),

            const SizedBox(height: 24),

            // Save Beneficiary Toggle
            Row(
              children: [
                Text(
                  'Save Beneficiary',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppColors.primaryColor,
                ),
              ],
            ),

            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PinEntryScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
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

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    String bankName,
    String accountNumber,
    IconData icon,
    Color iconColor,
    bool isDark,
  ) {
    final isSelected = bankName == selectedPaymentMethod;

    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = bankName),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bankName,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    accountNumber,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.radio_button_checked,
                color: AppColors.primaryColor,
                size: 20,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

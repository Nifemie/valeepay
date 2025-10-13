import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/dashboard/widgets/services_widgets/betting_widgets/payment_method_modal.dart';

Widget buildDetailRow(String label, String value, bool isDark,
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

class ReuseableTransactionDetailsScreen extends StatefulWidget {
  final List<Widget> topTransactionsDetailsList;
  final String topTitleText;
  bool hasBottom;
   String? bottomTitleText;
   final List<Widget>? bottomTransactionsDetailsList;
  final Function() onButtonPressed;

   ReuseableTransactionDetailsScreen(
      {super.key,
      required this.topTransactionsDetailsList,
      this.bottomTransactionsDetailsList,
      required this.topTitleText,
      this.bottomTitleText,
      required this.hasBottom,
      required this.onButtonPressed});

  @override
  State<ReuseableTransactionDetailsScreen> createState() =>
      _ReuseableTransactionDetailsScreenState();
}

class _ReuseableTransactionDetailsScreenState
    extends State<ReuseableTransactionDetailsScreen> {
  String selectedPaymentMethod = 'Vconnect Bank'; // Default selection
  bool saveBeneficiary = false; // Save beneficiary toggle state

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
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction details container
              Text(
                '${widget.topTitleText} Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: widget.topTransactionsDetailsList,
                ),
              ),
             if(widget.hasBottom) SizedBox(height: 24),
             if(widget.hasBottom) Text(
                widget.bottomTitleText ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
             if(widget.hasBottom) SizedBox(height: 16),

             if(widget.hasBottom) Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: widget.bottomTransactionsDetailsList ?? [],
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              // Pay Via section
              Text(
                'Pay Via',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment methods
                    _buildPaymentMethod('Vconnect Bank', '0000000000',
                        'assets/images/valar.png', isDark),
                    const SizedBox(height: 12),
                    _buildPaymentMethod('First Bank of Nigeria', '0000000000',
                        'assets/images/firstbank.png', isDark),

                    const SizedBox(height: 12),
                    _buildPaymentMethod('Wema Bank', '0000000000',
                        'assets/images/wema.png', isDark),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Save Beneficiary Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Save Beneficiary',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: saveBeneficiary,
                    onChanged: (value) {
                      setState(() {
                        saveBeneficiary = value;
                      });
                    },
                    activeColor: const Color(0xFFF76301),
                    activeTrackColor: const Color(0xFFF76301).withOpacity(0.3),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Confirm Button
              FullWidthButton(
                  text: 'Confirm', onPressed: widget.onButtonPressed)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    String name,
    String account,
    String imagePath,
    bool isDark,
  ) {
    final isSelected = selectedPaymentMethod == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFFF76301), width: 2)
              : Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath,
                  height: 40, width: 40, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    account,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFF76301) : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/current_rate_widget.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/upload_images_screen.dart';
import '/core/themes/color_utils.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_brand_modal.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_country_modal.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_amount_modal.dart';
import '/features/dashboard/view/services/giftcard/saved_beneficiary_screen.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  bool isBuySelected = true;
  String selectedBrand = 'Apple';
  String selectedCountry = 'United Kingdom';
  String selectedAmount = '£ 10';
  int quantity = 1;
  String codeOptional = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Giftcards',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedBeneficiaryScreen(),
                ),
              );
            },
            child: const Text(
              'Saved Beneficiary',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buy/Sell Toggle
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2B2725) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isBuySelected = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isBuySelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Buy Giftcard',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isBuySelected ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isBuySelected = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isBuySelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Sell Giftcard',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  !isBuySelected ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Select Giftcard Brand
              _buildSectionTitle('Select Giftcard Brand'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: selectedBrand,
                imagePath: 'assets/images/POUNDS.png',
                onTap: () => _showGiftCardBrandModal(),
              ),

              const SizedBox(height: 20),

              // Select Country
              _buildSectionTitle('Select Country'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: selectedCountry,
                imagePath: 'assets/images/POUNDS.png',
                onTap: () => _showCountryModal(),
              ),

              const SizedBox(height: 20),

              // Amount
              _buildSectionTitle('Amount'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: selectedAmount,
                imagePath: 'assets/images/EURO.png',
                onTap: () => _showAmountModal(),
              ),

              const SizedBox(height: 20),

              // Enter Code (Optional)
              _buildSectionTitle('Enter Code (Optional)'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => codeOptional = value),
                  decoration: InputDecoration(
                    hintText: '1234',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Price in Naira
              CurrentRateWidget(price: '₦50,000', text: 'Price in Naira'),

              const SizedBox(height: 45),

              // Continue Button
              FullWidthButton(
                  text: 'Continue',
                  onPressed: () => isBuySelected
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReuseableTransactionDetailsScreen(
                                    transactionsDetailsList: [
                                      buildDetailRow(
                                          'Card Type', selectedBrand, isDark),
                                      buildDetailRow(
                                          'Country', selectedCountry, isDark),
                                      buildDetailRow('Card Amount',
                                          selectedAmount, isDark),
                                      buildDetailRow(
                                        'Rate',
                                        '₦1,500/£',
                                        isDark,
                                      ),
                                      buildDetailRow('Expected Amount in Naira',
                                          '₦150,000', isDark),
                                    ],
                                    onButtonPressed: () async {
                                      final pin =
                                          await TransactionPinModal.show(
                                              context);
                                      if (pin != null &&
                                          pin.length == 4 &&
                                          mounted) {
                                        if (mounted) Navigator.pop(context);
                                        if (mounted) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TransactionReceiptWidget(
                                                        amount: '₦150,000',
                                                        topDetails: [
                                                          TransactionDetail(
                                                              label:
                                                                  'Card Type',
                                                              value:
                                                                  selectedBrand),
                                                          TransactionDetail(
                                                              label: 'Country',
                                                              value:
                                                                  selectedCountry,
                                                              showCopyIcon:
                                                                  true),
                                                          TransactionDetail(
                                                              label:
                                                                  'Card Amount',
                                                              value:
                                                                  selectedAmount),
                                                          TransactionDetail(
                                                              label: 'Rate',
                                                              value:
                                                                  '₦150,000'),
                                                          TransactionDetail(
                                                              label:
                                                                  'Amount Received',
                                                              value:
                                                                  'ValarPay Account'),
                                                        ],
                                                        bottomDetails: [
                                                          TransactionDetail(
                                                              label:
                                                                  'Transaction ID',
                                                              value:
                                                                  'TXN${DateTime.now().millisecondsSinceEpoch}',
                                                              showCopyIcon:
                                                                  true),
                                                          TransactionDetail(
                                                              label:
                                                                  'Payment Source',
                                                              value:
                                                                  'ValarPay Account'),
                                                          TransactionDetail(
                                                              label:
                                                                  'Date & Time',
                                                              value:
                                                                  '29 Sep 2025 | 8:15 pm')
                                                        ],
                                                        onShareReceipt: () {},
                                                      )));
                                        }
                                      }
                                    },
                                  )),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UploadImagesScreen())))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, height: 14),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _showGiftCardBrandModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GiftCardBrandModal(
        selectedBrand: selectedBrand,
        onBrandSelected: (brand) {
          setState(() => selectedBrand = brand);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCountryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GiftCardCountryModal(
        selectedCountry: selectedCountry,
        onCountrySelected: (country) {
          setState(() => selectedCountry = country);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAmountModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GiftCardAmountModal(
        selectedAmount: selectedAmount,
        onAmountSelected: (amount) {
          setState(() => selectedAmount = amount);
          Navigator.pop(context);
        },
      ),
    );
  }
}

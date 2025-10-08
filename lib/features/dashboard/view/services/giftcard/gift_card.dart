import 'package:flutter/material.dart';
import '/core/themes/app_theme.dart';
import '/core/themes/color_utils.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_brand_modal.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_country_modal.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_amount_modal.dart';
import '/features/dashboard/view/services/giftcard/saved_beneficiary_screen.dart';
import '/features/dashboard/view/services/giftcard/upload_images_screen.dart';

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
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buy/Sell Toggle
            Container(
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
                          color:
                              isBuySelected ? Colors.white : Colors.transparent,
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
                            color: !isBuySelected ? Colors.black : Colors.grey,
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
              icon: Icons.apple,
              onTap: () => _showGiftCardBrandModal(),
            ),

            const SizedBox(height: 20),

            // Select Country
            _buildSectionTitle('Select Country'),
            const SizedBox(height: 8),
            _buildDropdownField(
              value: selectedCountry,
              icon: null,
              flagCode: 'GB',
              onTap: () => _showCountryModal(),
            ),

            const SizedBox(height: 20),

            // Amount
            _buildSectionTitle('Amount'),
            const SizedBox(height: 8),
            _buildDropdownField(
              value: selectedAmount,
              onTap: () => _showAmountModal(),
            ),

            const SizedBox(height: 20),

            // Enter Code (Optional)
            _buildSectionTitle('Enter Code(Optional)'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) => setState(() => codeOptional = value),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: '10000',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Price in Naira
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price in Naira',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '₦50,000',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UploadImagesScreen(),
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
                  'Continue',
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

  Widget _buildSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    IconData? icon,
    String? flagCode,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
            ],
            if (flagCode != null) ...[
              Container(
                width: 24,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.red,
                ),
                child: const Center(
                  child: Text('🇬🇧', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
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

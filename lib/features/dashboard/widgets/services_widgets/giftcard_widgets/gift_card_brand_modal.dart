import 'package:flutter/material.dart';
import 'package:valarpay/features/models/giftcard.dart';
import '/core/themes/color_utils.dart';

class GiftCardBrandModal extends StatelessWidget {
  final String selectedBrand;
  final List<GiftCardProduct> products;
  final Function(GiftCardProduct) onBrandSelected;

  const GiftCardBrandModal({
    super.key,
    required this.selectedBrand,
    required this.products,
    required this.onBrandSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Group products by brand to avoid duplicates
    final Map<String, GiftCardProduct> uniqueBrands = {};
    for (final product in products) {
      if (!uniqueBrands.containsKey(product.brand.brandName)) {
        uniqueBrands[product.brand.brandName] = product;
      }
    }
    final brandList = uniqueBrands.values.toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Giftcard',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Brand List
          Expanded(
            child: brandList.isEmpty
                ? Center(
                    child: Text(
                      'No gift cards available',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: brandList.length,
                    itemBuilder: (context, index) {
                      final product = brandList[index];
                      final isSelected =
                          product.brand.brandName == selectedBrand;

                      return GestureDetector(
                        onTap: () => onBrandSelected(product),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2B2725)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.primaryColor, width: 2)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: product.logoUrls.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.logoUrls.first,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            Icons.card_giftcard,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        Icons.card_giftcard,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.brand.brandName,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      product.category.name,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

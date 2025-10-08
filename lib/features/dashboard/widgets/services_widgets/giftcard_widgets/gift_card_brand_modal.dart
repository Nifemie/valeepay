import 'package:flutter/material.dart';
import '/core/themes/color_utils.dart';

class GiftCardBrandModal extends StatelessWidget {
  final String selectedBrand;
  final Function(String) onBrandSelected;

  const GiftCardBrandModal({
    super.key,
    required this.selectedBrand,
    required this.onBrandSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final brands = [
      {'name': 'Amazon', 'icon': Icons.shopping_bag},
      {'name': 'American Express', 'icon': Icons.credit_card},
      {'name': 'Apple', 'icon': Icons.apple},
      {'name': 'eBay', 'icon': Icons.shopping_cart},
      {'name': 'Facebook', 'icon': Icons.facebook},
      {'name': 'GameStop', 'icon': Icons.games},
      {'name': 'Google Play', 'icon': Icons.play_arrow},
      {'name': 'iTunes', 'icon': Icons.music_note},
      {'name': 'Nike', 'icon': Icons.sports},
      {'name': 'PlayStation', 'icon': Icons.videogame_asset},
      {'name': 'Razer Gold', 'icon': Icons.computer},
      {'name': 'Sephora', 'icon': Icons.face},
      {'name': 'Steam', 'icon': Icons.games},
      {'name': 'Vanilla', 'icon': Icons.card_giftcard},
    ];

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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                final isSelected = brand['name'] == selectedBrand;

                return GestureDetector(
                  onTap: () => onBrandSelected(brand['name'] as String),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDark ? const Color(0xFF2B2725) : Colors.grey[100],
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
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            brand['icon'] as IconData,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            brand['name'] as String,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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

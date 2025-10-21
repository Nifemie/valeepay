import 'package:flutter/material.dart';
import 'package:valarpay/features/models/giftcard.dart';
import '/core/themes/color_utils.dart';

class GiftCardAmountModal extends StatelessWidget {
  final String selectedAmount;
  final GiftCardProduct product;
  final Function(String, double) onAmountSelected;

  const GiftCardAmountModal({
    super.key,
    required this.selectedAmount,
    required this.product,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get available amounts from the product
    final List<Map<String, dynamic>> amounts = [];

    if (product.denominationType == 'FIXED') {
      for (int i = 0; i < product.fixedRecipientDenominations.length; i++) {
        final value = product.fixedRecipientDenominations[i];
        final displayText = product.metadata?[value.toString()] ??
            '${product.recipientCurrencyCode} ${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)}';
        amounts.add({
          'display': displayText,
          'value': value,
        });
      }
    } else if (product.denominationType == 'RANGE') {
      // For range type, show some common amounts within the range
      final min = product.minRecipientDenomination ?? 1;
      final max = product.maxRecipientDenomination ?? 100;
      final commonAmounts = [min, min * 2, min * 5, min * 10, max / 2, max];

      for (final value in commonAmounts) {
        if (value >= min && value <= max) {
          amounts.add({
            'display':
                '${product.recipientCurrencyCode} ${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)}',
            'value': value,
          });
        }
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                  'Select Amount',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Amount List
          Expanded(
            child: amounts.isEmpty
                ? Center(
                    child: Text(
                      'No amounts available',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: amounts.length,
                    itemBuilder: (context, index) {
                      final amount = amounts[index];
                      final displayText = amount['display'] as String;
                      final value = amount['value'] as double;
                      final isSelected = displayText == selectedAmount;

                      return GestureDetector(
                        onTap: () => onAmountSelected(displayText, value),
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
                              Expanded(
                                child: Text(
                                  displayText,
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

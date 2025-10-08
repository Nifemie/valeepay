import 'package:flutter/material.dart';
import '/core/themes/color_utils.dart';

class GiftCardAmountModal extends StatelessWidget {
  final String selectedAmount;
  final Function(String) onAmountSelected;

  const GiftCardAmountModal({
    super.key,
    required this.selectedAmount,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final amounts = [
      '£5',
      '£10',
      '£15',
      '£25',
      '£50',
      '£100',
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: amounts.length,
              itemBuilder: (context, index) {
                final amount = amounts[index];
                final isSelected = amount == selectedAmount;

                return GestureDetector(
                  onTap: () => onAmountSelected(amount),
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
                        Expanded(
                          child: Text(
                            amount,
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

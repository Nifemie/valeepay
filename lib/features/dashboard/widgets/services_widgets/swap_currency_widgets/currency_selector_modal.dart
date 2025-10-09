import 'package:flutter/material.dart';

class CurrencySelectorModal extends StatelessWidget {
  final String selectedCurrency;
  final Function(String) onCurrencySelected;

  const CurrencySelectorModal({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currencies = [
      {'code': 'NGN', 'name': 'Nigerian Naira', 'flag': Colors.green},
      {'code': 'USD', 'name': 'US Dollar', 'flag': Colors.blue},
      {'code': 'EUR', 'name': 'Euro', 'flag': Colors.blue},
      {'code': 'GBP', 'name': 'British Pound', 'flag': Colors.red},
      {'code': 'CAD', 'name': 'Canadian Dollar', 'flag': Colors.red},
      {'code': 'AUD', 'name': 'Australian Dollar', 'flag': Colors.blue},
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
                  'Select Currency',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Currency list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = currency['code'] == selectedCurrency;

                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 16,
                        decoration: BoxDecoration(
                          color: currency['flag'] as Color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFF76301)
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.circle,
                                color: Color(0xFFF76301),
                                size: 12,
                              )
                            : null,
                      ),
                    ],
                  ),
                  title: Text(
                    '${currency['code']} - ${currency['name']}',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    onCurrencySelected(currency['code'] as String);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

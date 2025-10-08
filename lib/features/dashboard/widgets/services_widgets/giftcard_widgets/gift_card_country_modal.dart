import 'package:flutter/material.dart';
import '/core/themes/color_utils.dart';

class GiftCardCountryModal extends StatelessWidget {
  final String selectedCountry;
  final Function(String) onCountrySelected;

  const GiftCardCountryModal({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final countries = [
      {'name': 'United Kingdom', 'flag': '🇬🇧'},
      {'name': 'United States', 'flag': '🇺🇸'},
      {'name': 'Canada', 'flag': '🇨🇦'},
      {'name': 'Australia', 'flag': '🇦🇺'},
      {'name': 'Germany', 'flag': '🇩🇪'},
      {'name': 'France', 'flag': '🇫🇷'},
      {'name': 'Italy', 'flag': '🇮🇹'},
      {'name': 'Spain', 'flag': '🇪🇸'},
      {'name': 'Netherlands', 'flag': '🇳🇱'},
      {'name': 'Japan', 'flag': '🇯🇵'},
    ];

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
                  'Select Country',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Country List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                final isSelected = country['name'] == selectedCountry;

                return GestureDetector(
                  onTap: () => onCountrySelected(country['name'] as String),
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
                          width: 32,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              country['flag'] as String,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            country['name'] as String,
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

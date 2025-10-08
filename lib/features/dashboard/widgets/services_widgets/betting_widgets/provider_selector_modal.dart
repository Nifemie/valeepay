import 'package:flutter/material.dart';

class BettingProviderSelectorModal extends StatelessWidget {
  final String selectedProvider;
  final Function(String) onProviderSelected;

  const BettingProviderSelectorModal({
    super.key,
    required this.selectedProvider,
    required this.onProviderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final providers = [
      {'name': '1x Bet', 'color': Colors.green},
      {'name': 'Bangbet', 'color': Colors.blue},
      {'name': 'Bet9ja', 'color': Colors.green},
      {'name': 'Betking', 'color': Colors.red},
      {'name': 'Betway', 'color': Colors.orange},
      {'name': 'CloudBet', 'color': Colors.teal},
      {'name': 'Livescore Bet', 'color': Colors.orange},
      {'name': 'Merry Bet', 'color': Colors.yellow},
      {'name': 'Nairabet', 'color': Colors.grey},
      {'name': 'Noja Bet', 'color': Colors.blue},
      {'name': 'Sporty Bet', 'color': Colors.red},
      {'name': 'Sure Bet', 'color': Colors.red},
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
                  'Select Option',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Providers list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];
                final isSelected = provider['name'] == selectedProvider;

                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      const SizedBox(width: 12),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: provider['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    provider['name'] as String,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.star,
                          color: Color(0xFFF76301),
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    onProviderSelected(provider['name'] as String);
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

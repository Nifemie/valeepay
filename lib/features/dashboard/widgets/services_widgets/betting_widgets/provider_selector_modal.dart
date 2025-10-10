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
      {'name': '1x Bet', 'imagePath': 'assets/images/1xbetlogo.jpeg'},
      {'name': 'Bangbet', 'imagePath': 'assets/images/bangbetlogo.png'},
      {'name': 'Bet9ja', 'imagePath': 'assets/images/bet9jalogo.png'},
      {'name': 'Betking', 'imagePath': 'assets/images/betkinglogo.webp'},
      {'name': 'Betway', 'imagePath': 'assets/images/betwaylogo.png'},
      {'name': 'CloudBet', 'imagePath': 'assets/images/cloudbetlogo.png'},
      {
        'name': 'Livescore Bet',
        'imagePath': 'assets/images/livescorebetlogo.png'
      },
      {'name': 'Merry Bet', 'imagePath': 'assets/images/merrybetlogo.png'},
      {'name': 'Nairabet', 'imagePath': 'assets/images/nairabetlogo.png'},
      {'name': 'Sporty Bet', 'imagePath': 'assets/images/sportybetlogo.png'},
      {'name': 'Sure Bet', 'imagePath': 'assets/images/surebetlogo.jpeg'},
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
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(provider['imagePath']!),
                                fit: BoxFit.cover)),
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
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected ? const Color(0xFFF76301) : Colors.grey,
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

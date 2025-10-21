import 'package:flutter/material.dart';

class CableTvProviderSelectorModal extends StatelessWidget {
  final String selectedProvider;
  final Function(String) onProviderSelected;
  final List<String>? providers;

  const CableTvProviderSelectorModal({
    super.key,
    required this.selectedProvider,
    required this.onProviderSelected,
    this.providers,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cableTvProviders = providers ??
        [
          'DStv',
          'GOtv',
          'Startimes',
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
            child: Text(
              'Select Provider',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Provider list
          ...cableTvProviders.map((provider) {
            final isSelected = selectedProvider == provider;
            return ListTile(
              title: Text(
                provider,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                onProviderSelected(provider);
                Navigator.pop(context);
              },
            );
          }).toList(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

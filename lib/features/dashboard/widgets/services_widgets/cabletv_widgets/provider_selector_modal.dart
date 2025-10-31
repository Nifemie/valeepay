import 'package:flutter/material.dart';

class CableTvProviderSelectorModal extends StatelessWidget {
  final String selectedProvider;
  final Function(String) onProviderSelected;
  final List<String>? providers;

  const CableTvProviderSelectorModal({
    super.key,
    this.providers,
    required this.selectedProvider,
    required this.onProviderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final providers = this.providers ?? ['DStv', 'GOtv', 'Startimes'];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2725) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
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
                    'Select Provider',
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
            ...providers.map((provider) {
              final isSelected = provider == selectedProvider;
        
              return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFF76301) : Colors.grey,
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
                title: Text(
                  provider,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  onProviderSelected(provider);
                  Navigator.pop(context);
                },
              );
            }).toList(),
        
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

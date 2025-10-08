import 'package:flutter/material.dart';

class MeterTypeModal extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const MeterTypeModal({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final meterTypes = ['Prepaid', 'Postpaid'];

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
                  'Meter Type',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Meter type list
          ...meterTypes.map((type) {
            final isSelected = type == selectedType;

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
                type,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                onTypeSelected(type);
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

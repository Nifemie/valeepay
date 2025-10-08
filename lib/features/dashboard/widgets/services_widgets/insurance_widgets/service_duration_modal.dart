import 'package:flutter/material.dart';

class ServiceDurationModal extends StatelessWidget {
  final String selectedDuration;
  final Function(String) onDurationSelected;

  const ServiceDurationModal({
    super.key,
    required this.selectedDuration,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final durations = [
      '1 year',
      '2 months',
      '3 months',
      '6 months',
      '2 years',
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
                  'Service Duration',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Duration list
          ...durations.map((duration) {
            final isSelected = duration == selectedDuration;

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
                duration,
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
                onDurationSelected(duration);
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

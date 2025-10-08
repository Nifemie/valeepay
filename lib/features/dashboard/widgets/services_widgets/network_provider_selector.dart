import 'package:flutter/material.dart';

class NetworkProviderSelector extends StatelessWidget {
  final String selectedNetwork;
  final Function(String) onNetworkSelected;

  const NetworkProviderSelector({
    super.key,
    required this.selectedNetwork,
    required this.onNetworkSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _NetworkProviderItem(
          name: 'Airtel',
          color: Colors.red,
          isSelected: selectedNetwork == 'Airtel',
          onTap: () => onNetworkSelected('Airtel'),
        ),
        _NetworkProviderItem(
          name: 'MTN',
          color: Colors.yellow,
          isSelected: selectedNetwork == 'MTN',
          onTap: () => onNetworkSelected('MTN'),
        ),
        _NetworkProviderItem(
          name: '9mobile',
          color: Colors.green,
          isSelected: selectedNetwork == '9mobile',
          onTap: () => onNetworkSelected('9mobile'),
        ),
        _NetworkProviderItem(
          name: 'Glo',
          color: Colors.green,
          isSelected: selectedNetwork == 'Glo',
          onTap: () => onNetworkSelected('Glo'),
        ),
      ],
    );
  }
}

class _NetworkProviderItem extends StatelessWidget {
  final String name;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _NetworkProviderItem({
    required this.name,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade700,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

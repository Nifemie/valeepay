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
          image: Image.asset('assets/images/airtel.png'),
          isSelected: selectedNetwork == 'Airtel',
          onTap: () => onNetworkSelected('Airtel'),
        ),
        _NetworkProviderItem(
          name: 'MTN',
          image: Image.asset('assets/images/mtn.png'),
          isSelected: selectedNetwork == 'MTN',
          onTap: () => onNetworkSelected('MTN'),
        ),
        _NetworkProviderItem(
          name: '9mobile',
          image: Image.asset('assets/images/9mobile.png'),
          isSelected: selectedNetwork == '9mobile',
          onTap: () => onNetworkSelected('9mobile'),
        ),
        _NetworkProviderItem(
          name: 'Glo',
          image: Image.asset('assets/images/glo.png'),
          isSelected: selectedNetwork == 'Glo',
          onTap: () => onNetworkSelected('Glo'),
        ),
      ],
    );
  }
}

class _NetworkProviderItem extends StatelessWidget {
  final String name;
  final Widget image;
  final bool isSelected;
  final VoidCallback onTap;

  const _NetworkProviderItem({
    required this.name,
    required this.image,
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
          color: isSelected ? Colors.grey.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade700,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: image,
            ),
          ),
        ),
      ),
    );
  }
}

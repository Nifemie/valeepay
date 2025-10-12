import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';

class DataPlan {
  final String size;
  final String price;
  final String validity;

  const DataPlan({
    required this.size,
    required this.price,
    required this.validity,
  });
}

class DataPlansSection extends StatelessWidget {
  final String networkName;
  final String selectedPlan;
  final Function(String) onPlanSelected;

  const DataPlansSection({
    super.key,
    required this.networkName,
    required this.selectedPlan,
    required this.onPlanSelected,
  });

  List<DataPlan> _getPlansForNetwork(String network) {
    switch (network) {
      case 'MTN':
        return const [
          DataPlan(size: '1GB', price: '₦300', validity: '30 days'),
          DataPlan(size: '2GB', price: '₦500', validity: '30 days'),
          DataPlan(size: '5GB', price: '₦1,200', validity: '30 days'),
          DataPlan(size: '10GB', price: '₦2,000', validity: '30 days'),
        ];
      case 'Airtel':
        return const [
          DataPlan(size: '1GB', price: '₦350', validity: '30 days'),
          DataPlan(size: '2GB', price: '₦550', validity: '30 days'),
          DataPlan(size: '5GB', price: '₦1,300', validity: '30 days'),
          DataPlan(size: '10GB', price: '₦2,100', validity: '30 days'),
        ];
      case 'Glo':
        return const [
          DataPlan(size: '1GB', price: '₦320', validity: '30 days'),
          DataPlan(size: '2GB', price: '₦520', validity: '30 days'),
          DataPlan(size: '5GB', price: '₦1,250', validity: '30 days'),
          DataPlan(size: '10GB', price: '₦2,050', validity: '30 days'),
        ];
      case '9mobile':
        return const [
          DataPlan(size: '1GB', price: '₦330', validity: '30 days'),
          DataPlan(size: '2GB', price: '₦530', validity: '30 days'),
          DataPlan(size: '5GB', price: '₦1,280', validity: '30 days'),
          DataPlan(size: '10GB', price: '₦2,080', validity: '30 days'),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = _getPlansForNetwork(networkName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$networkName Data Plans',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...plans.map((plan) => _DataPlanTile(
              plan: plan,
              isSelected: selectedPlan == '${plan.size} - ${plan.price}',
              onTap: () => onPlanSelected('${plan.size} - ${plan.price}'),
            )),
      ],
    );
  }
}

class _DataPlanTile extends StatelessWidget {
  final DataPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _DataPlanTile({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? appTheme.primaryColor.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.size,
                    style: TextStyle(
                      color: isSelected ? appTheme.primaryColor : null,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Valid for ${plan.validity}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              plan.price,
              style: TextStyle(
                color: isSelected ? appTheme.primaryColor : null,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                color: appTheme.primaryColor,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

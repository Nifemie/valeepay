import 'package:flutter/material.dart';

class CableTvPlanSelectorModal extends StatelessWidget {
  final String selectedPlan;
  final Function(String) onPlanSelected;
  final List<String>? plans;

  const CableTvPlanSelectorModal({
    super.key,
    required this.selectedPlan,
    required this.onPlanSelected,
    this.plans,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cableTvPlans = plans ??
        [
          'Plan A', // fallback
          'Plan B',
          'Plan C',
        ];

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
              child: Text(
                'Select Plan',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Plan list
            ...cableTvPlans.map((plan) {
              final isSelected = selectedPlan == plan;
              return ListTile(
                title: Text(
                  plan,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  onPlanSelected(plan);
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

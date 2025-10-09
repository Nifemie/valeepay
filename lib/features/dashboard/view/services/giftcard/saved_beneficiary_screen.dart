import 'package:flutter/material.dart';
import '/core/themes/color_utils.dart';

class SavedBeneficiaryScreen extends StatelessWidget {
  const SavedBeneficiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final beneficiaries = [
      {
        'name': 'Apple iTunes',
        'country': 'United Kingdom',
        'icon': Icons.apple,
      },
      {
        'name': 'Apple iTunes',
        'country': 'United Kingdom',
        'icon': Icons.apple,
      },
      {
        'name': 'Apple iTunes',
        'country': 'United Kingdom',
        'icon': Icons.apple,
      },
      {
        'name': 'Apple iTunes',
        'country': 'United Kingdom',
        'icon': Icons.apple,
      },
      {
        'name': 'Apple iTunes',
        'country': 'United Kingdom',
        'icon': Icons.apple,
      },
      {
        'name': 'Apple iTunes',
        'country': 'United Kingdom',
        'icon': Icons.apple,
      },
      {
        'name': 'Apple iTunes',
        'country': 'United Kingdom',
        'icon': Icons.apple,
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Saved Beneficiary',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: beneficiaries.isEmpty
          ? _buildEmptyState(isDark)
          : _buildBeneficiaryList(beneficiaries, isDark),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add_disabled,
              size: 60,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No beneficiaries added yet',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add beneficiaries to make transactions faster',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryList(
      List<Map<String, dynamic>> beneficiaries, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: beneficiaries.length,
      itemBuilder: (context, index) {
        final beneficiary = beneficiaries[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  beneficiary['icon'] as IconData,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      beneficiary['name'] as String,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      beneficiary['country'] as String,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Show options menu
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

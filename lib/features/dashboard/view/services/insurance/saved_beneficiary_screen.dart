import 'package:flutter/material.dart';

class InsuranceSavedBeneficiaryScreen extends StatelessWidget {
  const InsuranceSavedBeneficiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sample beneficiaries data
    final beneficiaries = [
      {
        'policyNumber': '0000000000',
        'provider': 'Axa Mansard Insurance',
        'plan': 'Universal',
      },
      {
        'policyNumber': '0000000000',
        'provider': 'Axa Mansard Insurance',
        'plan': 'Universal',
      },
      {
        'policyNumber': '0000000000',
        'provider': 'Axa Mansard Insurance',
        'plan': 'Universal',
      },
      {
        'policyNumber': '0000000000',
        'provider': 'Axa Mansard Insurance',
        'plan': 'Universal',
      },
      {
        'policyNumber': '0000000000',
        'provider': 'Axa Mansard Insurance',
        'plan': 'Universal',
      },
      {
        'policyNumber': '0000000000',
        'provider': 'Axa Mansard Insurance',
        'plan': 'Universal',
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
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: beneficiaries.length,
              itemBuilder: (context, index) {
                final beneficiary = beneficiaries[index];
                return _buildBeneficiaryTile(
                  context,
                  beneficiary,
                  isDark,
                );
              },
            ),
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
              color: const Color(0xFFF76301).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.security,
              size: 60,
              color: Color(0xFFF76301),
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
            'Add beneficiaries to make insurance payments faster',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryTile(
    BuildContext context,
    Map<String, String> beneficiary,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2725) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF76301).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.security,
              color: Color(0xFFF76301),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  beneficiary['policyNumber']!,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  beneficiary['provider']!,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // More options
          IconButton(
            onPressed: () {
              _showOptionsBottomSheet(context, beneficiary, isDark);
            },
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(
    BuildContext context,
    Map<String, String> beneficiary,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFFF76301)),
              title: Text(
                'Edit Beneficiary',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle edit
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete Beneficiary',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle delete
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

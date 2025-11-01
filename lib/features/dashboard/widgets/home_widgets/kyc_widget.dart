import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/dashboard/view/KYC/BVN.dart';
import 'package:valarpay/features/dashboard/view/KYC/residential_address.dart';

class KYCWidget extends StatelessWidget {
  const KYCWidget({Key? key, this.onSetup}) : super(key: key);

  final VoidCallback? onSetup;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // make it adaptive
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor, // adaptive card bg
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF76301), // primary orange
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/payment_wid/kyc.png',
                width: 20,
                height: 20,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your KYC',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Verify your identity to unlock access',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Button
          ElevatedButton(
            onPressed:
                onSetup ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BVNPage()),
                  );
                },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: appTheme.primaryColor, // secondary blue
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Setup'),
          ),
        ],
      ),
    );
  }
}

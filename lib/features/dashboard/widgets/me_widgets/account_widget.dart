import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountMenuWidget extends StatelessWidget {
  const AccountMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(
            svgPath: 'assets/images/me_icons/doc.svg',
            title: 'Transaction History',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            svgPath: 'assets/images/me_icons/account.svg',
            title: 'Account Settings',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            svgPath: 'assets/images/me_icons/port.svg',
            title: 'My Portfolio',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            svgPath: 'assets/images/me_icons/rating.svg',
            title: 'Theme',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String svgPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Left icon
            SvgPicture.asset(
              svgPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            // Title text
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'SF Pro',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            // Right arrow icon
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}

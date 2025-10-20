import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userId;
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    required this.userId,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2725) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF76301).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFFF76301),
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userId,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'My Profile',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          if (onEditTap != null)
            IconButton(
              onPressed: onEditTap,
              icon: Icon(
                Icons.edit,
                color: isDark ? Colors.white70 : Colors.grey[600],
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

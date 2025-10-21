import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  final VoidCallback? onEditTap;

  const ProfileHeader({
    super.key,
    this.onEditTap,
  });

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);

    // Fallbacks for safety
    final profileImageUrl = user?.profileImageUrl?.isNotEmpty == true
        ? user!.profileImageUrl!
        : 'https://i.pravatar.cc/150?img=3';
    final wallet =
        user?.wallets.isNotEmpty == true ? user!.wallets.first : null;

    // Extract wallet data
    final accountNumber = wallet?.accountNumber ?? '00000000';

    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profileImageUrl),
          ),

          const SizedBox(height: 12),

          // User Info
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                accountNumber,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: accountNumber),
                  );
                },
                child: Icon(
                  Icons.copy,
                  size: 14,
                ),
              )
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tier 1',
                  style: TextStyle(
                    color: appTheme.primaryColor,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: appTheme.primaryColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

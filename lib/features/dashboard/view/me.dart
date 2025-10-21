import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../widgets/me_widgets/account_widget.dart';
import '../widgets/me_widgets/user_profile.dart';
import '../widgets/me_widgets/security_widget.dart';
// import 'package:valarpay/features/dashboard/view/me/rewards.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({Key? key}) : super(key: key);

  /// Pull-to-refresh handler
  Future<void> _refreshData(WidgetRef ref, BuildContext context) async {
    try {
      print('🔄 [Me Screen] Refreshing user profile...');

      // Refresh user profile from backend
      final updatedUser =
          await ref.read(userNotifierProvider.notifier).refreshUserProfile();

      // Update user provider with fresh data
      if (updatedUser != null) {
        ref.read(userProvider.notifier).setUser(updatedUser);
        print('✅ [Me Screen] Profile refreshed successfully');
        print(
            '💰 [Me Screen] Updated balance: ${updatedUser.wallets.isNotEmpty ? updatedUser.wallets.first.formattedBalance : "No wallet"}');
      }
    } catch (e) {
      print('❌ [Me Screen] Refresh failed: $e');
      // Handle errors silently or show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to refresh data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 0, // keep it hidden
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(ref, context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // Profile Header Card
                ProfileHeaderCard(
                  onSecurityTipsTap: () {
                    debugPrint('Security Tips tapped');
                  },
                  onRewardsTap: () {
                    context.push('/my-rewards');
                  },
                ),
                const SizedBox(height: 16),

                // Account Menu Widget
                const AccountMenuWidget(),
                const SizedBox(height: 16),

                // Security Menu Widget
                const SecurityMenuWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';
import '../widgets/me_widgets/account_widget.dart';
import '../widgets/me_widgets/user_profile.dart';
import '../widgets/me_widgets/security_widget.dart';
// import 'package:valarpay/features/dashboard/view/me/rewards.dart';

class MeScreen extends ConsumerStatefulWidget {
  const MeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends ConsumerState<MeScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh user profile when Me screen loads to ensure latest data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).refreshUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0, // keep it hidden
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              theme.brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header Card - Pinned at top
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: ProfileHeaderCard(
                onSecurityTipsTap: () {
                  context.push('/security-tips');
                },
                onRewardsTap: () {
                  context.push('/my-rewards');
                },
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Account Menu Widget
                    const AccountMenuWidget(),
                    const SizedBox(height: 16),

                    // Security Menu Widget
                    const SecurityMenuWidget(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

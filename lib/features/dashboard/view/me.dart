import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/me_widgets/account_widget.dart';
import '../widgets/me_widgets/user_profile.dart';
import '../widgets/me_widgets/security_widget.dart';
import '../widgets/navbar.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const CustomBottomNavBar(),
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Profile Header Card
              ProfileHeaderCard(
                onSecurityTipsTap: () {
                  debugPrint('Security Tips tapped');
                },
                onRewardsTap: () {
                  debugPrint('Rewards tapped');
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
    );
  }
}

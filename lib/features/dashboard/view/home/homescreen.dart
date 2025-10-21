import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/themes/app_theme.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../../widgets/home_widgets/payment_widget_icons.dart';
import '../../widgets/home_widgets/kyc_widget.dart';
import '../../widgets/home_widgets/ourservice.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  bool _isBalanceVisible = false;
  int _currentImageIndex = 0;
  Timer? _timer;

  final List<String> _bannerImages = const [
    'assets/images/valarbanner.png',
    'assets/images/valarbanner2.png',
    'assets/images/valarbanner3.png',
    'assets/images/valarbanner4.png',
  ];

  @override
  void initState() {
    super.initState();
    _startBannerRotation();
  }

  void _startBannerRotation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _bannerImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// Pull-to-refresh handler
  Future<void> _refreshData() async {
    try {
      // Refresh user profile from backend
      final updatedUser =
          await ref.read(userNotifierProvider.notifier).refreshUserProfile();

      // Update user provider with fresh data
      if (updatedUser != null) {
        ref.read(userProvider.notifier).setUser(updatedUser);
      }

      // You can add more refresh logic here:
      // - Refresh wallet balance
      // - Refresh recent transactions
      // - etc.
    } catch (e) {
      // Handle errors silently or show a snackbar
      if (mounted) {
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
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // Fallbacks for safety
    final firstName = (user?.fullname ?? 'Guest').split(' ').first;
    final profileImageUrl = user?.profileImageUrl?.isNotEmpty == true
        ? user!.profileImageUrl!
        : 'https://i.pravatar.cc/150?img=3';

    // Get wallet data
    final wallet =
        user?.wallets.isNotEmpty == true ? user!.wallets.first : null;
    final balance = wallet?.formattedBalance ?? '₦0.00';
    final accountNumber = wallet?.accountNumber ?? '';

    final greeting = _getGreeting();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _HomeAppBar(
                  profileImageUrl: profileImageUrl,
                  firstName: firstName,
                  greeting: greeting,
                ),
                const SizedBox(height: 16),
                _BalanceCard(
                  balance: balance,
                  accountNumber: accountNumber,
                  isBalanceVisible: _isBalanceVisible,
                  onToggleVisibility: () =>
                      setState(() => _isBalanceVisible = !_isBalanceVisible),
                ),
                const SizedBox(height: 16),
                const PaymentWidget(),
                const SizedBox(height: 16),
                // Conditionally show KYC widget only if not complete
                // NOTE: Backend returns both isPasscodeSet (device unlock) and isWalletPinSet (transaction PIN)
                // We check isWalletPinSet for transaction PIN status
                // For testing: Only checking PIN (skip button bypasses BVN)
                // TODO: Change to AND logic when testing complete:
                //       user?.isBvnVerified == true && user?.isWalletPinSet == true
                Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(userProvider);
                    // Temporarily only check wallet PIN for testing (skip button bypasses BVN)
                    final isKycComplete = user?.isWalletPinSet == true;

                    // Hide KYC widget if user has completed KYC
                    if (isKycComplete) {
                      return const SizedBox.shrink();
                    }

                    return const KYCWidget();
                  },
                ),
                const KYCWidget(),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    _bannerImages[_currentImageIndex],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const OurServicesWidget(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------- App Bar ----------
class _HomeAppBar extends StatelessWidget {
  final String profileImageUrl;
  final String firstName;
  final String greeting;

  const _HomeAppBar({
    Key? key,
    required this.profileImageUrl,
    required this.firstName,
    required this.greeting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Hello $firstName',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                greeting,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: appTheme.primaryColor,
                    ),
              ),
            ),
          ),
          Row(
            children: [
              _IconButton(
                svgPath: 'assets/images/payment_wid/Grouping (1).svg',
                onTap: () => context.push('/customer-service'),
              ),
              const SizedBox(width: 16),
              _IconButton(svgPath: 'assets/images/payment_wid/scanning.svg'),
              const SizedBox(width: 16),
              _IconButton(
                svgPath: 'assets/images/payment_wid/bell.svg',
                hasNotification: true,
                onTap: () => context.push('/notifications'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final String svgPath;
  final bool hasNotification;
  final VoidCallback? onTap;

  const _IconButton({
    Key? key,
    required this.svgPath,
    this.hasNotification = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            // ignore: deprecated_member_use
            color: Theme.of(context).iconTheme.color,
          ),
          if (hasNotification)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ---------- Balance Card ----------
class _BalanceCard extends StatelessWidget {
  final String balance;
  final String accountNumber;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;

  const _BalanceCard({
    Key? key,
    required this.balance,
    required this.accountNumber,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/payment_wid/security-safe.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFD1D5DB),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Main Balance',
                style: textTheme.bodySmall?.copyWith(color: onPrimary),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  size: 16,
                  color: onPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/transaction-history'),
                child: Row(
                  children: [
                    Text(
                      'Transaction History',
                      style: textTheme.bodySmall?.copyWith(color: onPrimary),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/icons/arrow_right_icon.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(onPrimary, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Balance Row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBalanceVisible ? balance : '₦ ••••••••••',
                    style: textTheme.headlineSmall?.copyWith(
                      color: onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (accountNumber.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      accountNumber,
                      style: textTheme.bodySmall?.copyWith(
                        color: onPrimary.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              const _AddMoneyButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/add-money'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              'Add Money',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: appTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

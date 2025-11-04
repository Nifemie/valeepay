import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/features/dashboard/view/profile/profile.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';
import '../../../widgets/home_widgets/support_widgets.dart';
import 'customer_service_form_screen.dart';
import '../../profile/change_phone_number.dart';
import '../../me/theme.dart';
import '../../settings/transaction_pin_settings_screen.dart';
// Local imports removed: unused in this file

class CustomerServiceScreen extends ConsumerStatefulWidget {
  const CustomerServiceScreen({super.key});

  @override
  ConsumerState<CustomerServiceScreen> createState() =>
      _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends ConsumerState<CustomerServiceScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final username = (user?.username ?? 'Hello').split(' ').first;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Customer Service'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting section
              Container(
                padding: ResponsiveUtils.paddingAll16,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: ResponsiveUtils.borderRadius12,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ProfileScreen())),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF3F4F6),
                        child: ClipOval(
                          child: user?.profileImageUrl != null &&
                                  user!.profileImageUrl!.isNotEmpty
                              ? Image.network(
                                  user.profileImageUrl!,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  size: 36,
                                  color: isDark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.spacing12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $username',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveUtils.fontSize16,
                              ),
                        ),
                        Text(
                          'How can we help you?',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontSize: ResponsiveUtils.fontSize12,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // Support options grid - Fixed height to prevent overflow
              LayoutBuilder(
                builder: (context, constraints) {
                  double cardWidth = (constraints.maxWidth - 16.w) / 2;
                  double cardHeight = cardWidth * 0.65;

                  return SizedBox(
                    height: cardHeight * 3 + 32.h, // 3 rows + spacing
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: cardWidth / cardHeight,
                      children: [
                        SupportOptionCard(
                          icon: Icons.report_problem_outlined,
                          title: 'Report Scam',
                          iconColor: appTheme.primaryColor,
                          onTap: () {
                            context.push('/report-scam');
                          },
                        ),
                        SupportOptionCard(
                          icon: Icons.swap_horiz,
                          title: 'Transfer Dispute',
                          iconColor: appTheme.primaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerServiceFormScreen(
                                  title: 'Transfer Dispute',
                                ),
                              ),
                            );
                          },
                        ),
                        SupportOptionCard(
                          icon: Icons.credit_card_outlined,
                          title: 'Card Issue',
                          iconColor: appTheme.primaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerServiceFormScreen(
                                  title: 'Card Issue',
                                ),
                              ),
                            );
                          },
                        ),
                        SupportOptionCard(
                          icon: Icons.phone_outlined,
                          title: 'Phone Number Change',
                          iconColor: appTheme.primaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangeMobileNumberScreen(),
                              ),
                            );
                          },
                        ),
                        SupportOptionCard(
                          icon: Icons.palette_outlined,
                          title: 'Theme',
                          iconColor: appTheme.primaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ThemesPage(),
                              ),
                            );
                          },
                        ),
                        SupportOptionCard(
                          icon: Icons.settings_outlined,
                          title: 'PIN Settings',
                          iconColor: appTheme.primaryColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionPinSettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // FAQ and Office visit options
              SupportListTile(
                icon: Icons.help_outline,
                title: 'Frequently Asked Questions (FAQs)',
                subtitle:
                    'Simple answers to your common concerns, FAQs, and more',
                iconColor: appTheme.primaryColor,
                onTap: () {
                  context.push('/faq');
                },
              ),

              SizedBox(height: ResponsiveUtils.spacing12),

              SupportListTile(
                icon: Icons.location_on_outlined,
                title: 'Visit Our Office Branch',
                subtitle:
                    'Get in-person help for your account and financial services when you visit',
                iconColor: appTheme.primaryColor,
                onTap: () {
                  context.push('/visit-office');
                },
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // Live Support button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Start live support
                    AppMessenger.show(
                      context,
                      type: MessageType.warning,
                      message: 'Live Support coming soon!',
                    );
                    // _showLiveSupportDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: ResponsiveUtils.paddingVertical16,
                    shape: RoundedRectangleBorder(
                      borderRadius: ResponsiveUtils.borderRadius12,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 20.sp),
                      SizedBox(width: ResponsiveUtils.width8),
                      Text(
                        'Live Support',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing8),

              Center(
                child: Text(
                  'AVG. Response time: 1hour',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLiveSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Live Support'),
          content: const Text('Connecting you to our support team...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Start live chat
              },
              child: const Text('Start Chat'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SecurityTipsScreen extends StatelessWidget {
  const SecurityTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Security Tips'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: ResponsiveUtils.paddingAll16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appTheme.primaryColor.withOpacity(0.8),
                      appTheme.primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: ResponsiveUtils.borderRadius16,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.security,
                        size: 32.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stay Safe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveUtils.fontSize20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Protect your account and finances',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: ResponsiveUtils.fontSize14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // Tips Section
              Text(
                'Essential Security Tips',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: ResponsiveUtils.fontSize18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing16),

              // Security Tips List
              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.lock_outline,
                title: 'Keep Your PIN Secret',
                description:
                    'Never share your transaction PIN, password, or OTP with anyone, including ValarPay staff. We will never ask for this information.',
                color: Colors.orange,
              ),

              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.phone_android,
                title: 'Secure Your Device',
                description:
                    'Use a strong screen lock (PIN, pattern, or biometric). Keep your device\'s operating system and ValarPay app updated.',
                color: Colors.blue,
              ),

              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.wifi_protected_setup,
                title: 'Use Secure Networks',
                description:
                    'Avoid using public Wi-Fi for banking transactions. Use your mobile data or a trusted private network.',
                color: Colors.green,
              ),

              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.warning_amber_outlined,
                title: 'Beware of Phishing',
                description:
                    'Be cautious of suspicious emails, SMS, or calls asking for your personal information. Verify the source before clicking any links.',
                color: Colors.red,
              ),

              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.visibility_off_outlined,
                title: 'Monitor Your Account',
                description:
                    'Regularly check your transaction history. Report any suspicious or unauthorized transactions immediately.',
                color: Colors.purple,
              ),

              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.app_blocking,
                title: 'Download from Official Sources',
                description:
                    'Only download ValarPay from official app stores (Google Play Store or Apple App Store). Avoid third-party sources.',
                color: Colors.teal,
              ),

              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.logout,
                title: 'Logout After Use',
                description:
                    'Always logout from the app when using shared or public devices. Enable biometric authentication for quick secure access.',
                color: Colors.indigo,
              ),

              _buildSecurityTip(
                context,
                isDark,
                icon: Icons.phone_callback,
                title: 'Report Suspicious Activity',
                description:
                    'If you notice any unusual activity or suspect your account has been compromised, contact us immediately at +234 823 414 6906.',
                color: Colors.deepOrange,
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // Emergency Contact Card
              InkWell(
                borderRadius: ResponsiveUtils.borderRadius12,
                onTap: () async {
                  final Uri phoneUri = Uri.parse('tel:+2348234146906');
                  try {
                    await launchUrl(
                      phoneUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      AppMessenger.show(context,
            message: 'Could not make phone call', type: MessageType.warning);
                     
                    }
                  }
                },
                child: Container(
                  padding: ResponsiveUtils.paddingAll16,
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.red.shade900.withOpacity(0.3)
                            : Colors.red.shade50,
                    borderRadius: ResponsiveUtils.borderRadius12,
                    border: Border.all(
                      color: isDark ? Colors.red.shade800 : Colors.red.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone_in_talk, color: Colors.red, size: 24.sp),
                      SizedBox(width: ResponsiveUtils.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need Help?',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.fontSize16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Contact our 24/7 support',
                              style: TextStyle(
                                fontSize: ResponsiveUtils.fontSize14,
                                color:
                                    isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: ResponsiveUtils.borderRadius8,
                        ),
                        child: Text(
                          'Call Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveUtils.fontSize12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityTip(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: ResponsiveUtils.paddingAll16,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: ResponsiveUtils.borderRadius12,
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow:
            isDark
                ? []
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: ResponsiveUtils.borderRadius8,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: ResponsiveUtils.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize14,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

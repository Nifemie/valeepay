import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valarpay/core/utils/color_utils.dart';

class NeedHelpModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          'Need Help?',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28.h),

                    // Options
                    _buildHelpOption(
                      title: 'Live Support',
                      icon: Icons.support_agent_outlined,
                      iconColor: appTheme.primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        _showComingSoon(context, 'Live Support');
                      },
                    ),
                    Divider(),

                    _buildHelpOption(
                      title: 'Email Us',
                      icon: Icons.email_outlined,
                      iconColor: Colors.blueGrey,
                      onTap: () {
                        Navigator.pop(context);
                        _launchEmail();
                      },
                    ),
                    Divider(),

                    _buildHelpOption(
                      title: 'WhatsApp',
                      icon: Icons.chat_outlined,
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        _launchWhatsApp();
                      },
                    ),
                    Divider(),

                    _buildHelpOption(
                      title: 'Phone Call',
                      icon: Icons.phone_outlined,
                      iconColor: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        _launchPhoneCall();
                      },
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildHelpOption({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              radius: 18,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  static void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@valarpay.com',
      query: 'subject=Need Help with valarpay',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  static void _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/2348000000000');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  static void _launchPhoneCall() async {
    final Uri phoneUri = Uri.parse('tel:+2348000000000');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  static void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: appTheme.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

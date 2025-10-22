import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
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
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back, size: 24),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Need Help?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28),

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
                        _launchEmail(context);
                      },
                    ),
                    Divider(),

                    _buildHelpOption(
                      title: 'WhatsApp',
                      icon: Icons.chat_outlined,
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        _launchWhatsApp(context);
                      },
                    ),
                    Divider(),

                    _buildHelpOption(
                      title: 'Phone Call',
                      icon: Icons.phone_outlined,
                      iconColor: appTheme.primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        _launchPhoneCall(context);
                      },
                    ),

                    SizedBox(height: 32),
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
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  static void _launchEmail(BuildContext context) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'support@valarpay.com',
        query: 'subject=Need Help with ValarPay',
      );

      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: 'Could not open email app',
        );
      }
    } catch (e) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'No email app found on your device',
      );
    }
  }

  static void _launchWhatsApp(BuildContext context) async {
    try {
      // Try direct WhatsApp URL first
      final Uri whatsappUri = Uri.parse('whatsapp://send?phone=447441428182');

      final bool launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // Fallback to web WhatsApp
        final Uri webWhatsApp = Uri.parse('https://wa.me/447441428182');
        await launchUrl(webWhatsApp, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Try web WhatsApp as last resort
      try {
        final Uri webWhatsApp = Uri.parse('https://wa.me/447441428182');
        await launchUrl(webWhatsApp, mode: LaunchMode.externalApplication);
      } catch (e2) {
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: 'Could not open WhatsApp',
        );
      }
    }
  }

  static void _launchPhoneCall(BuildContext context) async {
    try {
      final Uri phoneUri = Uri.parse('tel:+2348234146906');

      final bool launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        AppMessenger.show(
          context,
          type: MessageType.error,
          message: 'Could not make phone call',
        );
      }
    } catch (e) {
      AppMessenger.show(
        context,
        type: MessageType.error,
        message: 'Phone dialer not available',
      );
    }
  }

  static void _showComingSoon(BuildContext context, String feature) {
    AppMessenger.show(
      context,
      type: MessageType.error,
      message: '$feature coming soon!',
    );
  }
}

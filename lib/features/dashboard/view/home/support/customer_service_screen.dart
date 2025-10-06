import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import '../../../widgets/home_widgets/support_widgets.dart';
import 'faq_screen.dart';
import 'visit_office_screen.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User greeting section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello Timothy',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'How can we help you?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support options grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  SupportOptionCard(
                    icon: Icons.report_problem_outlined,
                    title: 'Report Scam',
                    iconColor: appTheme.primaryColor,
                    onTap: () {
                      // Navigate to report scam
                    },
                  ),
                  SupportOptionCard(
                    icon: Icons.swap_horiz,
                    title: 'Transfer Dispute',
                    iconColor: appTheme.primaryColor,
                    onTap: () {
                      // Navigate to transfer dispute
                    },
                  ),
                  SupportOptionCard(
                    icon: Icons.credit_card_outlined,
                    title: 'Card Issue',
                    iconColor: appTheme.primaryColor,
                    onTap: () {
                      // Navigate to card issue
                    },
                  ),
                  SupportOptionCard(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number Change',
                    iconColor: appTheme.primaryColor,
                    onTap: () {
                      // Navigate to phone number change
                    },
                  ),
                  SupportOptionCard(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    iconColor: appTheme.primaryColor,
                    onTap: () {
                      // Navigate to theme settings
                    },
                  ),
                  SupportOptionCard(
                    icon: Icons.settings_outlined,
                    title: 'PIN Settings',
                    iconColor: appTheme.primaryColor,
                    onTap: () {
                      // Navigate to PIN settings
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // FAQ and Office visit options
            SupportListTile(
              icon: Icons.help_outline,
              title: 'Frequently Asked Questions (FAQs)',
              subtitle:
                  'Simple answers to your common concerns, FAQs, and more',
              iconColor: appTheme.primaryColor,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FAQScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            SupportListTile(
              icon: Icons.location_on_outlined,
              title: 'Visit Our Office Branch',
              subtitle:
                  'Get in-person help for your account and financial services when you visit',
              iconColor: appTheme.primaryColor,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VisitOfficeScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Live Support button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Start live support
                  _showLiveSupportDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Live Support',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                'AVG. Response time: 1hour',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),

            const SizedBox(height: 16),
          ],
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

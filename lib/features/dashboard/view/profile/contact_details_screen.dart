import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/dashboard/view/profile/update_details_screen.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../../widgets/services_widgets/profile_widgets/profile_row_item.dart';
import 'change_phone_number.dart';

class ContactDetailsScreen extends ConsumerStatefulWidget {
  const ContactDetailsScreen({super.key});

  @override
  ConsumerState<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends ConsumerState<ContactDetailsScreen> {
    TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);

    // Fallbacks for safety
    final emailAddress = (user?.email ?? 'email@valar.com');
    final phoneNumber = (user?.phoneNumber ?? '1234567890');

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          ProfileRowItem(
            label: 'Mobile Number',
            value: phoneNumber,
            isClickable: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeMobileNumberScreen(),
                ),
              );
            },
          ),
          ProfileRowItem(
            label: 'Email Address',
            value: emailAddress,
            isClickable: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateUserDetailsScreen(
                    title: 'Update Email Address',
                    currentValue: emailAddress,
                    fieldLabel: 'Email Address',
                    controller: emailController,
                    description: 'Enter a new email address where you will receive account update and notifications',
                    onContinuePressed: () {
                      
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

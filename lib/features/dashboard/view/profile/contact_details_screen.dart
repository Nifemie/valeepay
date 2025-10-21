import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../../widgets/services_widgets/profile_widgets/profile_row_item.dart';
import 'update_username_screen.dart';
import 'change_phone_number.dart';

class ContactDetailsScreen extends ConsumerWidget {
  const ContactDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);

    // Fallbacks for safety
    final emailAddress = (user?.email ?? 'email@valar.com');
    final phoneNumber = (user?.phoneNumber ?? '1234567890');

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
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
                  builder: (context) => UpdateUsernameScreen(
                    title: 'Update Email Address',
                    currentValue: emailAddress,
                    fieldLabel: 'Email Address',
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

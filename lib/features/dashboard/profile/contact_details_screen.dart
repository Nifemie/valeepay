import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/services_widgets/profile_widgets/profile_info_tile.dart';
import 'update_username_screen.dart';
import 'change_phone_number.dart';

class ContactDetailsScreen extends ConsumerWidget {
  const ContactDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInfoTile(
              label: 'Mobile Number',
              value: '+234********00',
              isEditable: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangeMobileNumberScreen(),
                  ),
                );
              },
            ),
            ProfileInfoTile(
              label: 'Email Address',
              value: 'johnsmith@gmail.com',
              isEditable: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateUsernameScreen(
                      title: 'Update Email Address',
                      currentValue: 'johnsmith@gmail.com',
                      fieldLabel: 'Email Address',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

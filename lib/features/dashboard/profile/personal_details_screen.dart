import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/dashboard/profile/update_username_screen.dart';
import '../widgets/services_widgets/profile_widgets/profile_info_tile.dart';

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

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
          'Personal Details',
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
              label: 'Full Name',
              value: 'JOHN SMITH JACOB',
            ),
            ProfileInfoTile(
              label: 'Nickame',
              value: 'Smith',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateUsernameScreen(
                    title: 'Update Username',
                    currentValue: 'Smith',
                    fieldLabel: 'Username',
                  ),
                ),
              ),
            ),
            ProfileInfoTile(
              label: 'Date of Birth',
              value: '31 - 10 - 1992',
            ),
            ProfileInfoTile(
              label: 'Gender',
              value: 'Male',
            ),
          ],
        ),
      ),
    );
  }
}

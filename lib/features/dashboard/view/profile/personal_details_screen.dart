import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/dashboard/view/profile/update_details_screen.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../../widgets/services_widgets/profile_widgets/profile_row_item.dart';

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
     final user = ref.watch(userProvider);

    // Fallbacks for safety
    final fullName = (user?.fullname ?? 'Guest');
    final userName = (user?.username ?? 'ValarUser');
    final dateOfBirth = (user?.dateOfBirth ?? '01-Jan-2000');
    final gender = (user?.gender ?? 'Male');

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
      body: Column(
        children: [
          ProfileRowItem(
            label: 'Full Name',
            value: fullName,
          ),
          ProfileRowItem(
            label: 'Nickname',
            value: userName,
            isClickable: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateUserDetailsScreen(
                  title: 'Update Username',
                  currentValue: userName,
                  fieldLabel: 'Username',
                  description: 'Enter a new username that will appear on your profile',
                  onContinuePressed: () {
                    
                  },
                ),
              ),
            ),
          ),
          ProfileRowItem(
            label: 'Date of Birth',
            value: dateOfBirth,
          ),
          ProfileRowItem(
            label: 'Gender',
            value: gender,
          ),
        ],
      ),
    );
  }
}

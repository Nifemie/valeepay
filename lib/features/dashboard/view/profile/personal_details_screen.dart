import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/features/dashboard/view/profile/update_details_screen.dart';
import 'package:valarpay/features/notifiers/update_details_notifier.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../../widgets/services_widgets/profile_widgets/profile_row_item.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final fullName = (user?.fullname ?? 'Guest');
    final userName = (user?.username ?? 'ValarUser');
    final dateOfBirth = (user?.dateOfBirth ?? '01-Jan-2000');
    final gender = (user?.gender ?? 'Male');

    Future<void> _updateUsername() async {
      try {
        await ref
            .read(updateDetailsNotifierProvider.notifier)
            .updateUserName(usernameController.text.trim(), fullName);
        AppMessenger.show(
          context,
          message: 'Username updated successfully',
          type: MessageType.success,
        );
      } catch (e) {
        AppMessenger.show(
          context,
          message: e.toString(),
          type: MessageType.error,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personal Details',
          style: TextStyle(
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
                  description:
                      'Enter a new username that will appear on your profile',
                  controller: TextEditingController(text: userName),
                  onContinuePressed: _updateUsername,
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

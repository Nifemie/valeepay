import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/providers/user_provider.dart';
import '../../widgets/services_widgets/profile_widgets/profile_info_tile.dart';

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Address',
          style: TextStyle(
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
              label: 'LGA',
              value: user?.city ?? 'Ikeja East',
            ),
            ProfileInfoTile(
              label: 'State',
              value: user?.state ?? 'Lagos',
            ),
            ProfileInfoTile(
              label: 'Address',
              value: user?.address ?? 'No 1, Adeniyi Jones Avenue, Ikeja',
            ),
            ProfileInfoTile(
              label: 'Landmark',
              value: user?.country ?? 'Opposite Chicken Republic',
            ),
          ],
        ),
      ),
    );
  }
}

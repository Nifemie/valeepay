import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/services_widgets/profile_widgets/profile_info_tile.dart';

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

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
          'Address',
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
              label: 'LGA',
              value: 'Ikeja East',
            ),
            ProfileInfoTile(
              label: 'State',
              value: 'Lagos',
            ),
            ProfileInfoTile(
              label: 'Address',
              value: 'No 1, Adeniyi Jones Avenue, Ikeja',
            ),
            ProfileInfoTile(
              label: 'Landmark',
              value: 'Opposite Chicken Republic',
            ),
          ],
        ),
      ),
    );
  }
}

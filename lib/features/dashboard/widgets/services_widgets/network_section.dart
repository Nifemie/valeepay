import 'package:flutter/material.dart';
import 'ussd_service_tile.dart';

class NetworkSection extends StatelessWidget {
  final String networkName;
  final String imagePath;
  final List<USSDService> services;

  const NetworkSection(
      {super.key,
      required this.networkName,
      required this.imagePath,
      required this.services});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Network Header
        Row(
          children: [
            // Network Icon
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Network Name
            Text(
              networkName,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Services List
        ...services.map((service) => USSDServiceTile(service: service)),
      ],
    );
  }
}

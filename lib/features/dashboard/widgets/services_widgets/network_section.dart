import 'package:flutter/material.dart';
import 'ussd_service_tile.dart';

class NetworkSection extends StatelessWidget {
  final String networkName;
  final Color networkColor;
  final String networkIcon;
  final List<USSDService> services;

  const NetworkSection({
    super.key,
    required this.networkName,
    required this.networkColor,
    required this.networkIcon,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Network Icon
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: networkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              networkIcon,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Services List
        ...services.map((service) => USSDServiceTile(service: service)),
      ],
    );
  }
}

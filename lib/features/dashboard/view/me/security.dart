import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valarpay/core/utils/logger.dart';

// Security option model
class SecurityOption {
  final String title;
  final String iconPath;

  SecurityOption({required this.title, required this.iconPath});
}

final securityOptionsProvider = StateProvider<List<SecurityOption>>(
  (ref) => [
    SecurityOption(
      title: 'Report Scam',
      iconPath: 'assets/images/me_icons/scam.svg',
    ),
    SecurityOption(
      title: 'Transfer Dispute',
      iconPath: 'assets/images/me_icons/Transfer.svg',
    ),
    SecurityOption(
      title: 'Card Issue',
      iconPath: 'assets/images/me_icons/card_issue.svg',
    ),
    SecurityOption(
      title: 'Phone/Card Stolen',
      iconPath: 'assets/images/me_icons/phone_stolen.svg',
    ),
  ],
);

class SecurityCentrePage extends ConsumerWidget {
  const SecurityCentrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityOptions = ref.watch(securityOptionsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Security Centre',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // First Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSecurityCard(context, securityOptions[0]),
                  _buildSecurityCard(context, securityOptions[1]),
                ],
              ),
              const SizedBox(height: 15),
              // Second Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSecurityCard(context, securityOptions[2]),
                  _buildSecurityCard(context, securityOptions[3]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityCard(BuildContext context, SecurityOption option) {
    return GestureDetector(
      onTap: () {
        // Handle tap action
        AppLogger.log('Tapped on ${option.title}');
      },
      child: Container(
        width: 160,
        height: 80,
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            SvgPicture.asset(
              option.iconPath,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFFF76301),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              option.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

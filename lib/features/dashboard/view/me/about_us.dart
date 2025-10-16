import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutUsPage extends ConsumerWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Color(0xFF111827),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Valarpay Logo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF76301),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.wallet,
                          color: Colors.white,
                          size: 28,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Menu Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      title: 'Terms & Conditions',
                      onTap: () {
                        // Navigate to Terms & Conditions
                        print('Navigate to Terms & Conditions');
                      },
                      showDivider: true,
                    ),
                    _buildMenuItem(
                      context,
                      title: 'Privacy Policy',
                      onTap: () {
                        // Navigate to Privacy Policy
                        print('Navigate to Privacy Policy');
                      },
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required String title,
        required VoidCallback onTap,
        required bool showDivider,
      }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                      letterSpacing: 0.035,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 2,
              color: const Color(0xFFF1F4FB),
            ),
          ),
      ],
    );
  }
}
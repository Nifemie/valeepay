import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme options enum
enum ThemeMode {
  dark,
  light,
  system,
}

// State provider for selected theme
final selectedThemeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class ThemesPage extends ConsumerWidget {
  const ThemesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(selectedThemeProvider);

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
          'Themes',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose the look that suits you best',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  letterSpacing: 0.035,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildThemeOption(
                      context,
                      ref,
                      title: 'Dark Mode',
                      themeMode: ThemeMode.dark,
                      isSelected: selectedTheme == ThemeMode.dark,
                      showDivider: true,
                    ),
                    _buildThemeOption(
                      context,
                      ref,
                      title: 'Light Mode',
                      themeMode: ThemeMode.light,
                      isSelected: selectedTheme == ThemeMode.light,
                      showDivider: true,
                    ),
                    _buildThemeOption(
                      context,
                      ref,
                      title: 'System Default',
                      subtitle: 'This will use your device settings',
                      themeMode: ThemeMode.system,
                      isSelected: selectedTheme == ThemeMode.system,
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

  Widget _buildThemeOption(
      BuildContext context,
      WidgetRef ref, {
        required String title,
        String? subtitle,
        required ThemeMode themeMode,
        required bool isSelected,
        required bool showDivider,
      }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            ref.read(selectedThemeProvider.notifier).state = themeMode;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                          letterSpacing: 0.035,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontFamily: 'SF Pro',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 0.06,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFF76301)
                          : const Color(0xFF6B7280),
                      width: 0.5,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF76301),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                      : null,
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
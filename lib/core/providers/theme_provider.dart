import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  // Load theme from storage
  Future<void> _loadTheme() async {
    final themeMode = await ThemeService.getThemeMode();
    state = themeMode;
  }

  // Update theme and save to storage
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await ThemeService.setThemeMode(themeMode);
  }

  // Get theme display name
  String getThemeDisplayName() {
    switch (state) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}

// Provider for the theme notifier
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// Legacy provider for backward compatibility - returns the current theme mode
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeProvider);
});

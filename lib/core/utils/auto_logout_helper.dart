import 'package:valarpay/core/services/local_storage_service.dart';

class AutoLogoutHelper {
  /// Get the current auto-logout setting
  static Future<String> getCurrentSetting() async {
    final setting = await LocalStorageService.get('auto_logout_setting');
    return setting ?? '60 Minutes Password Free Log in';
  }

  /// Get a user-friendly description of the setting
  static String getSettingDescription(String setting) {
    switch (setting) {
      case 'Password Free Log in':
        return 'You will stay logged in until you manually log out';
      case '60 Minutes Password Free Log in':
        return 'You will be logged out after 60 minutes of inactivity';
      case 'Always Require Password to Log in':
        return 'You will be logged out immediately when you leave the app';
      default:
        return 'Default setting applied';
    }
  }

  /// Check if biometric re-login is available
  static Future<bool> canUseBiometricRelogin() async {
    final hasFp = await LocalStorageService.getBool('pref_biometric_fingerprint') ?? false;
    final hasFace = await LocalStorageService.getBool('pref_biometric_faceid') ?? false;
    return hasFp || hasFace;
  }
}

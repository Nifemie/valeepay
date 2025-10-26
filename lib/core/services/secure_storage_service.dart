import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive data like passcode
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Keys
  static const String _keyPasscode = 'secure_user_passcode';
  static const String _keyUsername = 'secure_username';

  /// Save passcode securely (encrypted)
  static Future<void> savePasscode(String passcode) async {
    await _storage.write(key: _keyPasscode, value: passcode);
  }

  /// Get stored passcode
  static Future<String?> getPasscode() async {
    return await _storage.read(key: _keyPasscode);
  }

  /// Delete stored passcode
  static Future<void> deletePasscode() async {
    await _storage.delete(key: _keyPasscode);
  }

  /// Save username for biometric login
  static Future<void> saveUsername(String username) async {
    await _storage.write(key: _keyUsername, value: username);
  }

  /// Get stored username
  static Future<String?> getUsername() async {
    return await _storage.read(key: _keyUsername);
  }

  /// Delete username
  static Future<void> deleteUsername() async {
    await _storage.delete(key: _keyUsername);
  }

  /// Clear all secure data (on logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if passcode is stored
  static Future<bool> hasPasscode() async {
    final passcode = await getPasscode();
    return passcode != null && passcode.isNotEmpty;
  }
}

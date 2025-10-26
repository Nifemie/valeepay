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
  static const String _keyDeviceId = 'secure_device_id';
  static const String _keyWalletPin = 'secure_wallet_pin';
  static const String _keyTransactionDeviceId = 'secure_transaction_device_id';

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

  /// Save device ID (to verify biometric is enabled on this specific device)
  static Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }

  /// Get stored device ID
  static Future<String?> getDeviceId() async {
    return await _storage.read(key: _keyDeviceId);
  }

  /// Delete device ID
  static Future<void> deleteDeviceId() async {
    await _storage.delete(key: _keyDeviceId);
  }

  /// Check if biometric is enabled for current device
  static Future<bool> isBiometricEnabledForDevice(String currentDeviceId) async {
    final storedDeviceId = await getDeviceId();
    return storedDeviceId != null && storedDeviceId == currentDeviceId;
  }

  /// Save wallet PIN for transaction biometric
  static Future<void> saveWalletPin(String pin) async {
    await _storage.write(key: _keyWalletPin, value: pin);
  }

  /// Get stored wallet PIN
  static Future<String?> getWalletPin() async {
    return await _storage.read(key: _keyWalletPin);
  }

  /// Delete wallet PIN
  static Future<void> deleteWalletPin() async {
    await _storage.delete(key: _keyWalletPin);
  }

  /// Save transaction device ID
  static Future<void> saveTransactionDeviceId(String deviceId) async {
    await _storage.write(key: _keyTransactionDeviceId, value: deviceId);
  }

  /// Get transaction device ID
  static Future<String?> getTransactionDeviceId() async {
    return await _storage.read(key: _keyTransactionDeviceId);
  }

  /// Check if transaction biometric is enabled for current device
  static Future<bool> isTransactionBiometricEnabledForDevice(String currentDeviceId) async {
    final storedDeviceId = await getTransactionDeviceId();
    return storedDeviceId != null && storedDeviceId == currentDeviceId;
  }

  /// Check if wallet PIN is stored
  static Future<bool> hasWalletPin() async {
    final pin = await getWalletPin();
    return pin != null && pin.isNotEmpty;
  }
}

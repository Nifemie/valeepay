import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      final isAvailable = await hasBiometrics();
      if (!isAvailable) return false;

      return await _auth.authenticate(
        localizedReason: 'Scan your fingerprint or face to login securely',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}

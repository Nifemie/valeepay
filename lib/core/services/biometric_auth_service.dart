import 'package:local_auth/local_auth.dart';
import 'package:valarpay/core/constants/enums/enums.dart';

class BiometricAuthService {
  static final _auth = LocalAuthentication();

  static Future<BiometricAuthResult> authenticateWithFallback({
    String promptMessage = 'Authenticate to continue',
  }) async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      print(
        '🔐 Biometric Check - canCheck: $canCheck, isDeviceSupported: $isDeviceSupported',
      );

      if (!canCheck || !isDeviceSupported) {
        print('🔐 Biometric not available - returning fallback');
        return BiometricAuthResult.fallback;
      }

      final available = await _auth.getAvailableBiometrics();
      print('🔐 Available biometrics: $available');

      if (available.isEmpty) {
        print('🔐 No biometrics enrolled - returning fallback');
        return BiometricAuthResult.fallback;
      }

      bool supportsFace = false;
      bool supportsFingerprint = false;

      for (final b in available) {
        if (b == BiometricType.face) supportsFace = true;
        if (b == BiometricType.fingerprint || b == BiometricType.strong) {
          supportsFingerprint = true;
        }
      }

      print(
        '🔐 Attempting authentication - Face: $supportsFace, Fingerprint: $supportsFingerprint',
      );

      final success = await _auth.authenticate(
        localizedReason:
            supportsFace
                ? 'Use Face ID to authenticate'
                : supportsFingerprint
                ? 'Use fingerprint to authenticate'
                : promptMessage,
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow device credentials as fallback
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      print('🔐 Authentication result: $success');

      return success ? BiometricAuthResult.success : BiometricAuthResult.failed;
    } catch (e) {
      print('🔐 Authentication error: $e');

      return BiometricAuthResult.failed;
    }
  }
}

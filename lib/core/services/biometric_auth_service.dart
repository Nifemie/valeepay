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
      if (!canCheck || !isDeviceSupported) {
        return BiometricAuthResult.fallback;
      }

      final available = await _auth.getAvailableBiometrics();
      bool supportsFace = false;
      bool supportsFingerprint = false;

      for (final b in available) {
        if (b == BiometricType.face) supportsFace = true;
        if (b == BiometricType.fingerprint || b == BiometricType.strong) {
          supportsFingerprint = true;
        }
      }

      final success = await _auth.authenticate(
        localizedReason: supportsFace
            ? 'Use Face ID to authenticate'
            : supportsFingerprint
                ? 'Use fingerprint to authenticate'
                : promptMessage,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return success
          ? BiometricAuthResult.success
          : BiometricAuthResult.failed;
    } catch (e) {
      return BiometricAuthResult.failed;
    }
  }
}

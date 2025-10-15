import 'package:local_auth/local_auth.dart';
import 'package:valarpay/core/constants/enums/enums.dart';

class BiometricAuthService {
  static final _auth = LocalAuthentication();

  static Future<BiometricAuthResult> authenticateWithFallback({
    String promptMessage = 'Authenticate to continue',
  }) async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isAvailable = await _auth.isDeviceSupported();
      if (!canCheck || !isAvailable) {
        // Fallback to passcode if biometrics unavailable
        return BiometricAuthResult.fallback;
      }

      final availableBiometrics = await _auth.getAvailableBiometrics();
      final supportsFaceID = availableBiometrics.contains(BiometricType.face);
      availableBiometrics.contains(BiometricType.fingerprint);

      final success = await _auth.authenticate(
        localizedReason: supportsFaceID
            ? 'Use Face ID to login'
            : 'Use Fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return success ? BiometricAuthResult.success : BiometricAuthResult.failed;
    } catch (_) {
      return BiometricAuthResult.failed;
    }
  }
}

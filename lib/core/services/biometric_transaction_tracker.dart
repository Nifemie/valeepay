/// Service to track when biometric authentication is being used for transactions
/// This prevents auto-logout from triggering during biometric payment flows
class BiometricTransactionTracker {
  static bool _isTransactionBiometricInProgress = false;
  static DateTime? _lastBiometricStartTime;
  
  /// Set when starting biometric authentication for a transaction
  static void startTransactionBiometric() {
    _isTransactionBiometricInProgress = true;
    _lastBiometricStartTime = DateTime.now();
    print('🔐 [BiometricTracker] Transaction biometric started');
  }
  
  /// Clear when biometric authentication completes (success or failure)
  static void endTransactionBiometric() {
    _isTransactionBiometricInProgress = false;
    print('🔐 [BiometricTracker] Transaction biometric ended');
  }
  
  /// Check if transaction biometric is currently in progress
  static bool isInProgress() {
    // Auto-clear if it's been more than 30 seconds (safety timeout)
    if (_isTransactionBiometricInProgress && _lastBiometricStartTime != null) {
      final elapsed = DateTime.now().difference(_lastBiometricStartTime!);
      if (elapsed.inSeconds > 30) {
        print('⚠️ [BiometricTracker] Auto-clearing stale biometric flag (${elapsed.inSeconds}s)');
        _isTransactionBiometricInProgress = false;
      }
    }
    
    return _isTransactionBiometricInProgress;
  }
  
  /// Reset all state (useful for testing or error recovery)
  static void reset() {
    _isTransactionBiometricInProgress = false;
    _lastBiometricStartTime = null;
    print('🔐 [BiometricTracker] Reset');
  }
}

# Biometric Settings vs Airtime Screen - Comparison

## Overview
The Transaction PIN Settings screen (where user enables biometrics) and the Airtime screen handle PIN confirmation differently. Here's the breakdown:

---

## 1. Dialog Type & Implementation

### Transaction PIN Settings Screen
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => const Center(
    child: CircularProgressIndicator(),
  ),
);
```
- Uses **custom simple `showDialog`** with just a `CircularProgressIndicator`
- **barrierDismissible: false** → User cannot dismiss by tapping outside
- Very basic loading dialog
- **Manual `Navigator.pop(context)`** to close it

### Airtime Screen
```dart
void _showLoading() {
  if (_loadingShown) return;
  _loadingShown = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

void _hideLoading() {
  if (_loadingShown && mounted && Navigator.canPop(context)) {
    Navigator.pop(context);
    _loadingShown = false;
  }
}
```
- Uses **extracted helper methods** `_showLoading()` and `_hideLoading()`
- Includes `WillPopScope` to prevent back button dismissal
- Has **`_loadingShown` flag** to prevent duplicate dialogs
- Includes **mounted and canPop checks** for safety

---

## 2. PIN Confirmation Flow

### Transaction PIN Settings Screen (Biometric Enable)

```dart
Future<void> _handleFingerprintToggle(bool value) async {
  if (value) {
    // Step 1: Show PIN modal
    final pin = await TransactionPinModal.show(context);
    if (pin == null || pin.length != 4) {
      AppMessenger.show(context, message: 'PIN entry cancelled', ...);
      return;
    }
    
    // Step 2: Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Step 3: Verify PIN via backend
    final isPinCorrect = await ref.read(userNotifierProvider.notifier)
        .verifyWalletPin(pin);
    Navigator.pop(context); // Close loading
    
    // Step 4: If correct, show biometric prompt
    if (isPinCorrect) {
      BiometricTransactionTracker.startTransactionBiometric();
      final result = await BiometricAuthService.authenticateWithFallback(
        promptMessage: 'Verify fingerprint to enable for transactions',
      );
      BiometricTransactionTracker.endTransactionBiometric();
      
      // Step 5: If biometric succeeds, save everything
      if (result == BiometricAuthResult.success) {
        await SecureStorageService.saveWalletPin(pin);
        await LocalStorageService.saveBool(_keyTransactionFingerprint, true);
        // Success message
      }
    } else {
      AppMessenger.show(context, message: 'Incorrect pin entered', ...);
    }
  }
}
```

**Flow:**
1. ✅ Show PIN modal
2. ✅ Show loading (simple showDialog)
3. ✅ Verify PIN with backend
4. ✅ Close loading
5. ✅ If PIN correct → Show biometric prompt
6. ✅ If biometric succeeds → Save PIN to secure storage + enable toggle

### Airtime Screen (Transaction Processing)

```dart
Future<void> _handlePin({bool biometric = false}) async {
  final pin = biometric
      ? await BiometricTransactionPinModal.show(context)
      : await TransactionPinModal.show(context);

  if (pin == null || pin.length != 4 || !mounted) return;
  
  // Show loading
  _showLoading();

  try {
    final request = AirtimePurchaseRequest(
      walletPin: pin,
      amount: Helpers.parsedAmount(_amountController.text),
      // ... other fields
    );

    // Process transaction
    await ref.read(airtimePurchaseNotifierProvider.notifier).purchase(request);

    _hideLoading();

    if (!mounted) return;

    final state = ref.read(airtimePurchaseNotifierProvider);

    if (state.isDataAvailable) {
      _navigateToReceipt();
    } else {
      // Error handling
      AppMessenger.show(context, message: errorMessage, type: MessageType.error);
    }
  } catch (e) {
    _hideLoading();
    // Error handling
  }
}
```

**Flow:**
1. ✅ Show PIN modal (or biometric modal if enabled)
2. ✅ Show loading (using _showLoading helper)
3. ✅ Send PIN + transaction to backend
4. ✅ Close loading (using _hideLoading helper)
5. ✅ Check response state
6. ✅ Navigate to receipt or show error

---

## 3. Key Differences

| Aspect | Biometric Settings | Airtime Screen |
|--------|-------------------|-----------------|
| **Dialog Pattern** | Simple `showDialog` inline | `_showLoading()` / `_hideLoading()` helpers |
| **WillPopScope** | ❌ No | ✅ Yes (prevents back button) |
| **Safety Checks** | None | ✅ mounted, canPop, _loadingShown flag |
| **PIN Usage** | Backend verification only (`verifyWalletPin`) | Backend transaction processing (`purchase`) |
| **Biometric** | Only shown AFTER PIN verified | Can be used FROM START if already enabled |
| **Storage** | Saves PIN to secure storage | Uses PIN directly, doesn't save |
| **Success Behavior** | Toggles switch + shows success message | Navigates to receipt screen |
| **Error Timing** | Errors after all checks complete | Errors shown AFTER loader closes |

---

## 4. Why They're Different

### Biometric Settings Screen
- **Purpose**: Save PIN to device for future use
- **Goal**: Enable biometric authentication for transactions
- **PIN Storage**: Must be saved to `SecureStorageService`
- **Device Tracking**: Saves device ID to ensure biometric works only on registered device

### Airtime Screen
- **Purpose**: Process a transaction immediately
- **Goal**: Complete the purchase with PIN verification
- **PIN Storage**: Used once, not saved (security best practice)
- **Immediate Action**: Navigate to receipt after success

---

## 5. Current Behavior

### Settings Flow (When Enabling Biometrics)
```
Switch Toggled (ON)
  ↓
TransactionPinModal.show(context)  ← User enters PIN
  ↓
verifyWalletPin(pin)  ← Backend checks if PIN is correct
  ↓
BiometricAuthService.authenticateWithFallback()  ← System biometric prompt
  ↓
saveWalletPin(pin)  ← Save to secure storage
  ↓
Show success + enable toggle
```

### Airtime Flow (When Making Purchase)
```
Button Pressed
  ↓
TransactionPinModal.show(context) or BiometricTransactionPinModal.show(context)
  ↓
airtimePurchaseNotifierProvider.purchase(request)  ← Backend processes with PIN
  ↓
Check state.isDataAvailable
  ↓
Navigate to Receipt or Show Error
```

---

## 6. Is the Dialog the Same?

**Short Answer**: ❌ No, but they should be similar.

**Why**:
- Settings uses basic `showDialog` with just `CircularProgressIndicator`
- Airtime uses `_showLoading()` helper which adds `WillPopScope` protection
- Airtime approach is **safer** because it prevents accidental dismissal via back button

**Recommendation**: The Settings screen could benefit from using the same `_showLoading()` / `_hideLoading()` pattern that Airtime uses, or at least add `WillPopScope` to prevent back button dismissal.

---

## 7. Related Classes

### PIN Modal Classes Used
- **`TransactionPinModal`**: Standard 4-digit PIN entry dialog
- **`BiometricTransactionPinModal`**: PIN entry that verifies with device biometric

### Notifiers Used
- **Biometric Settings**: `userNotifierProvider.verifyWalletPin(pin)`
- **Airtime**: `airtimePurchaseNotifierProvider.purchase(request)`

### Storage Services Used
- **`SecureStorageService`**: Stores sensitive data (PIN, device ID)
- **`LocalStorageService`**: Stores preferences (toggles)
- **`BiometricTransactionTracker`**: Manages biometric transaction state

---

## 8. Summary

| Component | Biometric Settings | Airtime |
|-----------|-------------------|---------|
| Dialog | `showDialog` + CircularProgressIndicator | `_showLoading()` helper with WillPopScope |
| Safety | Manual close | _loadingShown flag, canPop check |
| Back Button | Not prevented | Prevented by WillPopScope |
| PIN Purpose | Save to device | Use for transaction |
| Next Step | Show biometric prompt | Process transaction |
| Success | Toggle switch | Navigate to receipt |

The **Airtime approach is more robust** and should be the standard for all transaction dialogs.

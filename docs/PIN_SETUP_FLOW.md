# Transaction PIN Setup Flow

## 📋 Complete Flow from BVN to PIN Setup

### Full KYC Level 1 Journey:
```
1. BVN Entry
   └─> POST /api/v1/wallet/initiate-bvn-verification
       └─> Receive verificationId

2. BVN OTP Verification
   └─> POST /api/v1/wallet/validate-bvn-verification
       └─> BVN Verified ✅

3. Setup Transaction PIN (setup_pin.dart)
   └─> User enters 4-digit PIN
       └─> Continue

4. Confirm Transaction PIN (confirm_transaction_pin_page.dart)
   └─> User re-enters 4-digit PIN
       └─> If match: Save PIN + Show Success Dialog
       └─> If mismatch: Show Error Dialog + Retry

5. Success Dialog (passcode_success.dart)
   └─> "Done" button
       └─> Navigate to Home Screen
           └─> Clear PIN from state
           └─> KYC Level 1 Complete! 🎉
```

---

## 🔄 PIN Setup Flow (Detailed)

### Screen 1: Setup PIN (`setup_pin.dart`)
**File**: `lib/features/dashboard/view/KYC/setup_pin.dart`

**Purpose**: User creates their 4-digit transaction PIN

**UI Elements**:
- Title: "Set Up Your Transaction Pin"
- Subtitle: "Create a secure 4-digit PIN to always authorize your transactions safely"
- 4 PIN input boxes (obscured with ●)
- Continue button (enabled when 4 digits entered)

**State Management**:
```dart
pinControllerProvider
  ├─> updatePin(value) - stores entered PIN
  ├─> isPinValid() - checks if 4 digits entered
  └─> submitSetupPin() - validates and proceeds
```

**Navigation**:
```dart
onSuccess: () {
  Navigator.push(context, 
    MaterialPageRoute(
      builder: (context) => const ConfirmTransactionPinPage()
    )
  );
}
```

---

### Screen 2: Confirm PIN (`confirm_transaction_pin_page.dart`)
**File**: `lib/features/dashboard/view/KYC/confirm_transaction_pin_page.dart`

**Purpose**: User confirms their PIN by re-entering it

**UI Elements**:
- Title: "Confirm Your Transaction Pin"
- Subtitle: "Re-enter your 4-digit PIN to always authorize and secure every transaction"
- 4 PIN input boxes (obscured with ●)
- Continue button (enabled when 4 digits entered)

**State Management**:
```dart
pinControllerProvider
  ├─> updateConfirmPin(value) - stores confirmation PIN
  ├─> isConfirmPinValid() - checks if 4 digits entered
  └─> submitConfirmPin() - validates match
```

**Validation Logic**:
```dart
submitConfirmPin(context,
  onSuccess: () async {
    // PINs match ✅
    await savePinSecurely(pinState.pin);
    _showSuccessDialog(context, ref);
  },
  onError: () {
    // PINs don't match ❌
    _showPinMismatchDialog(context, ref);
  }
);
```

---

### Dialog 1: PIN Mismatch (if PINs don't match)
**Shown when**: Confirmation PIN ≠ Setup PIN

**UI Elements**:
- Message: "PINs do not match. Please try again."
- Two buttons:
  1. **"Try Again"** → Go back to Setup PIN screen (pop twice)
  2. **"Re-enter"** → Stay on Confirm PIN screen (pop once)

**Actions**:
```dart
"Try Again" → Navigator.pop() + Navigator.pop() // Back to setup
"Re-enter" → Navigator.pop() // Stay on confirm, clear input
```

---

### Dialog 2: Success (`passcode_success.dart`)
**File**: `lib/features/dashboard/widgets/Kyc/Dialog/passcode_success.dart`

**Shown when**: PINs match successfully

**Actions**:
```dart
onDone: () {
  // 1. Clear PIN from memory
  ref.read(pinControllerProvider.notifier).clearAllPins();
  
  // 2. Navigate to home screen using GoRouter
  context.go('/');
}
```

---

## 📊 State Management

### PIN Controller Provider
**File**: `lib/controller/pin_controller.dart`

**State Structure**:
```dart
class PinState {
  String pin;           // Setup PIN
  String confirmPin;    // Confirmation PIN
}
```

**Methods**:
```dart
- updatePin(String value)           // Store setup PIN
- updateConfirmPin(String value)    // Store confirm PIN
- isPinValid()                      // Check if setup PIN = 4 digits
- isConfirmPinValid()               // Check if confirm PIN = 4 digits
- submitSetupPin()                  // Validate setup PIN
- submitConfirmPin()                // Validate confirm PIN matches setup PIN
- savePinSecurely(String pin)       // Save PIN to secure storage
- clearAllPins()                    // Clear both PINs from state
```

---

## 🔐 Security Features

1. **Obscured Input**: PIN displayed as ● bullets
2. **4-Digit Only**: Numeric keyboard, max 1 digit per box
3. **Confirmation Required**: Must re-enter PIN to prevent typos
4. **Secure Storage**: PIN saved using secure storage (not plain text)
5. **State Cleanup**: PIN cleared from memory after saving

---

## 🎯 Navigation Summary

### Success Path:
```
BVN OTP ✅
  → Setup PIN (enter 4 digits)
    → Confirm PIN (re-enter 4 digits)
      → Match ✅
        → Save PIN
          → Show Success Dialog
            → Done
              → Navigate to KYCSetupPage
                → KYC Complete! 🎉
```

### Error Path (Mismatch):
```
Confirm PIN (re-enter 4 digits)
  → Mismatch ❌
    → Show Error Dialog
      → Option 1: "Try Again" → Back to Setup PIN
      → Option 2: "Re-enter" → Stay on Confirm PIN
```

---

## 📁 Files Involved

### Screen Files:
1. `lib/features/dashboard/view/KYC/setup_pin.dart` - Setup PIN screen
2. `lib/features/dashboard/view/KYC/confirm_transaction_pin_page.dart` - Confirm PIN screen
3. `lib/features/dashboard/view/KYC/KYCSetupPage.dart` - Final destination

### Dialog Files:
1. `lib/features/dashboard/widgets/Kyc/Dialog/passcode_success.dart` - Success dialog

### Widget Files:
1. `lib/core/widgets/pin_input_fields.dart` - Reusable 4-digit PIN input

### Controller Files:
1. `lib/controller/pin_controller.dart` - PIN state management

---

## 🔄 Import Chain (from BVN OTP)

```dart
// bvn_otp_verification.dart
import 'setup_pin.dart'; // ✅ Updated from setup_passcode

// setup_pin.dart
import 'confirm_transaction_pin_page.dart';

// confirm_transaction_pin_page.dart
import 'KYCSetupPage.dart';
import '../../widgets/Kyc/Dialog/passcode_success.dart';
```

---

## ✅ Renamed File

**Old Name**: `setup_passcode.dart`
**New Name**: `setup_pin.dart` ✅

**Already Updated In**:
- ✅ `bvn_otp_verification.dart` - Import path updated to `setup_pin.dart`

**Class Name**: `SetupTransactionPinPage` (unchanged)

---

## 🎉 Flow Complete!

After successful PIN setup:
- User has completed KYC Level 1
- BVN verified ✅
- Transaction PIN created ✅
- Ready to use the app! 🚀

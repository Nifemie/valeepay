# KYC Completion & PIN Storage - Theory & Implementation Guide

## 📋 Current State Analysis

### **What Happens After BVN Verification & PIN Setup**

---

## 🔐 **1. WHERE IS THE PIN STORED?**

### **Backend Storage** (Primary)
After successful PIN setup, the PIN is sent to:
```
POST /api/v1/user/set-wallet-pin
Body: { "pin": "2222" }

Backend Response:
{
  "message": "Your 4-digit wallet PIN has been set successfully",
  "statusCode": 200
}
```

**Backend stores:**
- ✅ Encrypted PIN in database (hashed/encrypted - never plain text)
- ✅ Associated with user's account ID
- ✅ Used to validate all future transactions
- ✅ Updates user field: `isWalletPinSet: true`

### **Local Storage** (Secondary/Backup)
Currently there's a placeholder:
```dart
// lib/controller/pin_controller.dart
Future<void> savePinSecurely(String pin) async {
  // TODO: Implement secure storage
  AppLogger.log('Saving PIN securely: $pin');
}
```

**Should implement:**
- Use `flutter_secure_storage` package
- Encrypt PIN before storing locally
- Used for offline validation or quick checks
- NOT the source of truth (backend is)

---

## 📊 **2. WHERE IS BVN VERIFICATION STATUS STORED?**

### **In User Model**
```dart
// lib/features/models/user.dart
class UserModel {
  final bool isBvnVerified;      // ✅ Set to true after BVN validation
  final bool isWalletPinSet;     // ✅ Set to true after PIN setup
  final bool isNinVerified;      // For KYC Level 2
  final bool isAddressVerified;  // For complete KYC
  final String? tierLevel;       // "KYC1", "KYC2", "KYC3"
  // ... other fields
}
```

### **How It Gets Updated**

After successful BVN validation:
```
Backend validates BVN
   ↓
Updates user record:
   - isBvnVerified: true
   - tierLevel: "KYC1" (or higher)
   ↓
Returns updated LoginResponse (if re-fetching user)
   ↓
Frontend saves to SessionService
   ↓
UserModel in app state is updated
```

After successful PIN setup:
```
Backend saves PIN
   ↓
Updates user record:
   - isWalletPinSet: true
   ↓
Response confirms success
   ↓
Frontend should re-fetch user data OR update local state
```

---

## 🏠 **3. KYC WIDGET VISIBILITY ON HOME SCREEN**

### **Current Implementation (WRONG)**
```dart
// lib/features/dashboard/view/home/homescreen.dart - Line 92
const KYCWidget(),  // ❌ Always shows, never checks completion
```

The KYC widget is **always displayed**, regardless of whether the user has completed KYC or not.

### **What Should Happen**

The widget should **conditionally render** based on KYC completion:

```dart
// Should be:
if (!isKycComplete) 
  const KYCWidget(),  // Only show if KYC is incomplete
```

### **How to Determine if KYC is Complete**

**Option 1: Check User Fields (Recommended)**
```dart
bool isKycComplete(UserModel user) {
  return user.isBvnVerified && user.isWalletPinSet;
}
```

**Option 2: Check Tier Level**
```dart
bool isKycComplete(UserModel user) {
  return user.tierLevel != null && user.tierLevel != 'KYC0';
}
```

**Option 3: Combined Check (Most Robust)**
```dart
bool isKycLevel1Complete(UserModel user) {
  return user.isBvnVerified && user.isWalletPinSet;
}

bool isKycLevel2Complete(UserModel user) {
  return isKycLevel1Complete(user) && 
         user.isNinVerified && 
         user.selfieBase64Image != null;
}
```

---

## 🔄 **4. THE COMPLETE FLOW**

### **Step 1: User Completes BVN Verification**
```
User enters BVN → OTP sent
   ↓
User enters OTP → Backend validates
   ↓
Backend updates:
   - user.isBvnVerified = true
   - user.tierLevel = "KYC1" (if applicable)
   ↓
Frontend receives success response
   ↓
Navigate to PIN setup
```

### **Step 2: User Sets Up Wallet PIN**
```
User enters 4-digit PIN → Confirm PIN
   ↓
PIN sent to backend: POST /set-wallet-pin
   ↓
Backend updates:
   - user.isWalletPinSet = true
   - Stores encrypted PIN
   ↓
Frontend receives success
   ↓
Save PIN locally (optional backup)
   ↓
Show success dialog
   ↓
Navigate to home screen
```

### **Step 3: Home Screen Checks KYC Status**
```
Home screen loads
   ↓
Fetch current user from SessionService
   ↓
Check: user.isBvnVerified && user.isWalletPinSet
   ↓
If TRUE:  Hide KYC widget ✅
If FALSE: Show KYC widget ⚠️
```

---

## 🎯 **5. WHAT NEEDS TO BE IMPLEMENTED**

### **Priority 1: Hide KYC Widget When Complete** ⚠️ CRITICAL

**File:** `lib/features/dashboard/view/home/homescreen.dart`

**Change:**
```dart
// Current (Line 92):
const KYCWidget(),

// Should be:
Consumer(
  builder: (context, ref, child) {
    final user = ref.watch(userProvider);
    final isKycComplete = user?.isBvnVerified == true && 
                          user?.isWalletPinSet == true;
    
    if (isKycComplete) {
      return const SizedBox.shrink(); // Hide widget
    }
    
    return const KYCWidget();
  },
)
```

### **Priority 2: Update User State After PIN Setup** ⚠️ IMPORTANT

**File:** `lib/features/dashboard/view/KYC/confirm_transaction_pin_page.dart`

**After successful PIN setup:**
```dart
void _showSuccessDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PasscodeSuccessDialog(
        onDone: () async {
          // Clear PINs
          ref.read(pinControllerProvider.notifier).clearAllPins();
          
          // ✅ TODO: Re-fetch user data to update isWalletPinSet
          // Option 1: Call getUserProfile API
          // Option 2: Update local user state manually
          
          // Close dialog
          Navigator.of(context).pop();
          
          // Navigate home
          context.go('/');
        },
      );
    },
  );
}
```

### **Priority 3: Implement Secure PIN Storage** 📝 OPTIONAL

**File:** `lib/controller/pin_controller.dart`

**Add package:** `flutter_secure_storage`

**Implementation:**
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinNotifier extends StateNotifier<PinState> {
  final _secureStorage = const FlutterSecureStorage();
  
  Future<void> savePinSecurely(String pin) async {
    try {
      // Save encrypted PIN
      await _secureStorage.write(key: 'wallet_pin', value: pin);
      AppLogger.log('PIN saved securely');
    } catch (e) {
      AppLogger.log('Error saving PIN: $e');
    }
  }
  
  Future<String?> getStoredPin() async {
    try {
      return await _secureStorage.read(key: 'wallet_pin');
    } catch (e) {
      AppLogger.log('Error reading PIN: $e');
      return null;
    }
  }
  
  Future<bool> validatePin(String enteredPin) async {
    final storedPin = await getStoredPin();
    return storedPin == enteredPin;
  }
}
```

### **Priority 4: Refresh User Data After KYC** 📝 NICE TO HAVE

**Create method to re-fetch user:**
```dart
// In user_repository.dart or auth_repository.dart
Future<UserModel> getCurrentUser() async {
  try {
    final response = await apiClient.get('/api/v1/user/profile');
    return UserModel.fromJson(response.data);
  } catch (e) {
    throw Exception('Failed to fetch user profile');
  }
}
```

**Call after PIN setup:**
```dart
// After successful PIN setup
final updatedUser = await ref.read(userRepositoryProvider).getCurrentUser();
ref.read(userProvider.notifier).setUser(updatedUser);
await SessionService.saveSession(LoginResponse(
  user: updatedUser,
  accessToken: await SessionService.getAccessToken(),
  message: 'Success',
));
```

---

## 📝 **6. BACKEND EXPECTATIONS**

The backend should:

1. ✅ Update `isBvnVerified` to `true` after BVN validation
2. ✅ Update `isWalletPinSet` to `true` after PIN setup
3. ✅ Return updated user object in responses
4. ✅ Provide endpoint to fetch current user: `GET /api/v1/user/profile`

---

## 🧪 **7. TESTING CHECKLIST**

After implementing:

- [ ] Complete BVN verification
- [ ] Complete PIN setup
- [ ] Navigate to home screen
- [ ] KYC widget should be HIDDEN
- [ ] Try making a transaction
- [ ] PIN should be required
- [ ] Entered PIN should validate against backend
- [ ] After app restart, KYC widget should still be hidden
- [ ] After logout/login, KYC status should persist

---

## 🚨 **8. CURRENT ISSUES**

1. ❌ KYC widget always shows (even after completion)
2. ❌ User state not updated after PIN setup
3. ❌ No user profile refresh after KYC completion
4. ⚠️ Local PIN storage not implemented (optional)
5. ⚠️ No endpoint to re-fetch user profile (might exist, need to check)

---

## ✅ **9. SUMMARY**

### **Where Data is Stored:**

| Data | Backend | Local | Source of Truth |
|------|---------|-------|-----------------|
| PIN | ✅ Encrypted | 📝 TODO | Backend |
| isBvnVerified | ✅ Boolean | ✅ In SessionService | Backend |
| isWalletPinSet | ✅ Boolean | ✅ In SessionService | Backend |
| tierLevel | ✅ String | ✅ In SessionService | Backend |

### **What Needs Fixing:**

1. **Hide KYC widget** when `isBvnVerified && isWalletPinSet`
2. **Update user state** after PIN setup (re-fetch from backend)
3. **Implement secure PIN storage** (optional, for offline use)

### **How PIN is Used:**

- Every transaction requires PIN entry
- User enters PIN → Sent to backend → Backend validates
- Backend compares with stored encrypted PIN
- If match: Transaction proceeds
- If mismatch: Transaction denied

---

**Date:** October 17, 2025

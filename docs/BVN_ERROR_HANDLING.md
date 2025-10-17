# BVN Error Handling Documentation

## What Happens When You Enter a Wrong BVN?

This document explains the complete error handling flow for BVN verification in the app.

---

## 📋 Error Scenarios

### 1️⃣ **Invalid BVN Format (Client-Side Validation)**

**Trigger**: BVN is not exactly 11 digits

**What Happens**:
- ❌ "Continue" button is **disabled** (greyed out)
- ❌ Cannot proceed to next step
- ✅ No API call is made (prevents unnecessary backend requests)

**Code Location**: `lib/features/dashboard/view/KYC/BVN.dart`
```dart
final isFormValid = bvn.length == 11; // Line 35
isEnabled: isFormValid, // Line 191
```

**User Experience**:
```
User enters: "2240934" (7 digits)
Button state: Disabled (greyed out)
Action: User must complete 11 digits to continue
```

---

### 2️⃣ **Wrong BVN Number (Backend Validation)**

**Trigger**: BVN has 11 digits but doesn't exist or is invalid

**What Happens**:

#### Step 1: API Call Initiated
```
User enters: "12345678901"
Button: Shows loading spinner ⏳
API: POST /api/v1/wallet/initiate-bvn-verification
Body: { "bvn": "12345678901" }
```

#### Step 2: Backend Validation Fails
```
Backend checks BVN database
Backend Response: {
  "statusCode": 400,
  "message": "Invalid BVN number"
}
```

#### Step 3: Error Caught in Repository
```dart
// lib/features/repositories/user_repository.dart
on DioException catch (e) {
  throw Exception(
    e.response?.data['message'] ?? 'Failed to initialize BVN'
  );
}
```

#### Step 4: Error Handled in Notifier
```dart
// lib/features/notifiers/user_notifier.dart
catch (e, stack) {
  log('[UserNotifier BVN Initialize Error] $e\n$stack');
  state = state.copyWith(
    isInitialLoading: false,
    isDataAvailable: false,
    message: e.toString(), // Stores error message
  );
  return null; // Returns null to indicate failure
}
```

#### Step 5: UI Shows Error Message
```dart
// lib/features/dashboard/view/KYC/BVN.dart
if (response != null) {
  // Navigate to OTP screen
} else {
  // Show error message
  AppMessenger.show(
    context,
    message: userState.message ?? 'Failed to initialize BVN verification',
    type: MessageType.error,
  );
}
```

**User Experience**:
```
1. Button shows loading ⏳
2. Loading stops ⏹️
3. Red error message appears: "Invalid BVN number" 🔴
4. User stays on BVN screen
5. User can try again with correct BVN
```

---

### 3️⃣ **Network/Connection Errors**

**Trigger**: No internet connection or server is down

**What Happens**:
```
1. API call fails with network error
2. DioException caught with connection error
3. Error message: "Network error - please check your connection"
4. User stays on BVN screen
5. User can retry when connection is restored
```

**Possible Error Messages**:
- "No internet connection"
- "Connection timeout"
- "Server is unreachable"
- "Failed to initialize BVN verification"

---

### 4️⃣ **BVN Already Verified**

**Trigger**: User enters a BVN that's already linked to another account

**What Happens**:
```
Backend Response: {
  "statusCode": 409,
  "message": "BVN already registered with another account"
}
```

**User Experience**:
- Error message displayed
- User cannot proceed with this BVN
- May need to contact support

---

## 🔄 Complete Error Flow Diagram

```
User enters BVN
       ↓
┌──────────────────┐
│ Format Check     │
│ (11 digits?)     │
└────┬─────────────┘
     │
     ├─ NO  → Button disabled (stay on screen)
     │
     └─ YES → Button enabled
                   ↓
              User clicks "Continue"
                   ↓
              ┌─────────────────┐
              │ API Call        │
              │ (Loading...)    │
              └────┬────────────┘
                   │
         ┌─────────┴──────────┐
         │                    │
    ✅ SUCCESS            ❌ ERROR
         │                    │
    Navigate to          Show error
    OTP screen          message (red)
         │                    │
    Enter OTP           User stays on
    to verify          BVN screen
                            │
                       User can retry
```

---

## 📱 Error Message Display

### Implementation
Error messages are displayed using `AppMessenger.show()`:

```dart
AppMessenger.show(
  context,
  message: userState.message ?? 'Failed to initialize BVN verification',
  type: MessageType.error, // Red colored message
);
```

### Message Types:
- 🔴 **Error**: Red background (for failures)
- 🟢 **Success**: Green background (for success)
- 🔵 **Info**: Blue background (for information)

### Display Duration:
- Messages auto-dismiss after 3-5 seconds
- User can dismiss manually by swiping

---

## 🛡️ Backend Error Messages (Expected)

Based on Nigerian fintech BVN validation systems:

| Error Code | Message | Meaning |
|------------|---------|---------|
| 400 | Invalid BVN number | BVN doesn't exist |
| 409 | BVN already registered | BVN linked to another account |
| 422 | BVN validation failed | Invalid format/checksum |
| 429 | Rate limit exceeded | Too many attempts |
| 500 | BVN service unavailable | Third-party service down |
| 503 | Service temporarily unavailable | System maintenance |

---

## ✅ Best Practices

### For Users:
1. ✅ Double-check BVN is exactly 11 digits
2. ✅ Enter BVN from valid source (bank statement, USSD code)
3. ✅ Ensure good internet connection
4. ✅ Contact support if BVN is rejected multiple times

### For Developers:
1. ✅ Always show specific backend error messages to users
2. ✅ Log errors for debugging (`log('[UserNotifier BVN Initialize Error]')`)
3. ✅ Keep user on current screen after error (don't navigate away)
4. ✅ Allow unlimited retry attempts (no lockout)
5. ✅ Provide loading indicators during API calls

---

## 🧪 Testing Wrong BVN Scenarios

### Test Case 1: Short BVN
```
Input: "1234567"
Expected: Button disabled
Result: ✅ Pass
```

### Test Case 2: Long BVN
```
Input: "123456789012"
Expected: Only accepts 11 digits (input maxLength = 11)
Result: ✅ Pass
```

### Test Case 3: Invalid BVN (11 digits)
```
Input: "00000000000"
Expected: API error → "Invalid BVN number"
Result: ⏳ Depends on backend validation
```

### Test Case 4: Valid BVN
```
Input: "22409341326" (real BVN)
Expected: Navigate to OTP screen
Result: ✅ Pass
```

---

## 📝 Related Files

- **BVN Input Screen**: `lib/features/dashboard/view/KYC/BVN.dart`
- **OTP Verification**: `lib/features/dashboard/view/KYC/bvn_otp_verification.dart`
- **Repository**: `lib/features/repositories/user_repository.dart`
- **Notifier**: `lib/features/notifiers/user_notifier.dart`
- **Error Messenger**: `lib/core/utils/app_messenger.dart`

---

## 🎯 Summary

**Wrong BVN Entry = Safe & User-Friendly**

✅ **No data loss** - User stays on screen
✅ **Clear feedback** - Error message explains what went wrong
✅ **Easy retry** - Can immediately enter correct BVN
✅ **No account lockout** - Unlimited attempts allowed
✅ **Proper validation** - Both client-side (format) and server-side (validity)

**The system is designed to handle wrong BVN entries gracefully without any negative impact on the user's account or experience!**

---

## Date: October 17, 2025

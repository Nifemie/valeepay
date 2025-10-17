# Debugging isPasscodeSet Issue

## 🔍 **Problem**
After setting PIN, logs show `isPasscodeSet` is still `false` in the user profile.

## 📝 **Expected Flow**

1. User enters PIN → `/api/v1/user/set-wallet-pin` (should succeed)
2. App calls `refreshUserProfile()` → `/api/v1/user/me`
3. Backend should return `isPasscodeSet: true`
4. KYC widget should hide

## 🛠️ **Added Debug Logging**

### **Files Modified:**

1. **`lib/features/repositories/user_repository.dart`**
   - Added `import 'dart:developer';`
   - Added logs in `getUserProfile()`:
     - Request URL
     - Response status
     - Response data (full JSON)
     - Parsed `isPasscodeSet` value

2. **`lib/features/notifiers/user_notifier.dart`**
   - Added logs in `refreshUserProfile()`:
     - Fetch start
     - Fetch success
     - `isPasscodeSet` value
     - `isBvnVerified` value
     - Full user JSON

## 📊 **What to Check in Logs**

### **After entering PIN, look for:**

```
[UserRepository] Calling GET /api/v1/user/me
[UserRepository] Response status: 200
[UserRepository] Response data: {actual backend response}
[UserRepository] Parsed user - isPasscodeSet: {true or false?}

[UserNotifier] Fetching user profile...
[UserNotifier] User profile fetched successfully
[UserNotifier] isPasscodeSet: {true or false?}
[UserNotifier] isBvnVerified: {true or false?}
[UserNotifier] Full user data: {full JSON}
```

## 🎯 **Possible Issues**

### **Issue 1: Backend Not Updating**
**Symptoms:**
- `/api/v1/user/set-wallet-pin` returns 201 success
- But `/api/v1/user/me` still shows `isPasscodeSet: false`

**Solution:**
- Backend team needs to update the user record after PIN is set
- Verify backend updates `isPasscodeSet` field to `true`

### **Issue 2: Wrong Field Name**
**Symptoms:**
- Backend might use different field name
- Could be `isWalletPinSet` instead of `isPasscodeSet`

**Solution:**
- Check actual backend response JSON
- Update `UserModel.fromJson()` to map correct field

### **Issue 3: API Not Being Called**
**Symptoms:**
- No logs showing `/api/v1/user/me` request
- Profile refresh silently failing

**Solution:**
- Check if `refreshUserProfile()` is actually called
- Check for network errors
- Check if token is valid

### **Issue 4: Timing Issue**
**Symptoms:**
- Backend hasn't finished updating when we fetch profile
- Race condition

**Solution:**
- Add delay before fetching (not ideal)
- Backend should be synchronous for this operation

## 🧪 **Testing Steps**

1. **Clear app data and restart**
2. **Login with 2FA**
3. **Skip BVN** (orange button)
4. **Enter PIN: 2222**
5. **Confirm PIN: 2222**
6. **Watch console logs carefully**

### **What to Look For:**

```bash
# Step 1: PIN Setup API Call
POST /api/v1/user/set-wallet-pin
Response: 201 Created
{
  "message": "Wallet PIN set successfully",
  "statusCode": 201
}

# Step 2: Profile Refresh API Call (Should happen immediately after)
[UserRepository] Calling GET /api/v1/user/me
[UserRepository] Response status: 200
[UserRepository] Response data: {
  "id": "...",
  "email": "...",
  "isPasscodeSet": ???  ← CHECK THIS VALUE!
}
```

## 📋 **Next Steps Based on Logs**

### **If `isPasscodeSet: false` in backend response:**
→ **Backend Issue** - Backend not updating the field after PIN is set
→ Contact backend team to fix `/api/v1/user/set-wallet-pin` endpoint

### **If `isPasscodeSet: true` in backend response:**
→ **App Issue** - Parsing or state management problem
→ Check if `UserModel.fromJson()` correctly maps the field
→ Check if `userProvider` is being updated

### **If no profile refresh logs appear:**
→ **Flow Issue** - `refreshUserProfile()` not being called
→ Check `confirm_transaction_pin_page.dart` success dialog

### **If network error in logs:**
→ **API Issue** - Check token, check endpoint URL
→ Verify `/api/v1/user/me` is correct endpoint

## 💡 **Quick Workaround**

If backend can't fix immediately, you can manually set it after PIN setup:

```dart
// In confirm_transaction_pin_page.dart after PIN setup succeeds
final currentUser = ref.read(userProvider);
if (currentUser != null) {
  // Manually update the field
  final updatedUser = currentUser.copyWith(isPasscodeSet: true);
  ref.read(userProvider.notifier).setUser(updatedUser);
}
```

**Note:** This is TEMPORARY - backend should return correct value!

---

**Date:** October 17, 2025
**Status:** Investigating with enhanced logging

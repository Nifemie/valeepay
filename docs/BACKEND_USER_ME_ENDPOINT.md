# Backend User Endpoint Implementation - `/api/v1/user/me`

## ✅ Confirmed Endpoint Details

### **Endpoint**
```
GET /api/v1/user/me
```

### **Authentication**
Required - Bearer token in Authorization header

---

## 📥 **ACTUAL BACKEND RESPONSE**

### **Response Structure:**
```json
{
  "id": "277f8212-7824-4873-bebe-570df993b5fc",
  "email": "abrahamosazee2@gmail.com",
  "username": "Abrahamosaz2",
  "fullname": "Abraham Omorisiagbon",
  "createdAt": "2024-12-21T14:57:43.476Z",
  "updatedAt": "2024-12-26T09:44:24.589Z",
  "currency": "NGN",
  "businessName": null,
  "isBusiness": false,
  "phoneNumber": null,
  "isPasscodeSet": true,
  "isPhoneVerified": false,
  "isEmailVerified": true,
  "isBvnVerified": false,
  "accountType": "PERSONAL",
  "profileImageFilename": "nattypay/profile_pictures/Abraham Omorisiagbon_1735206258442_stm32",
  "profileImageUrl": "https://res.cloudinary.com/dyklkieao/image/upload/v1735206262/nattypay/profile_pictures/Abraham%20Omorisiagbon_1735206258442_stm32.png"
}
```

---

## 🔍 **FIELD MAPPING**

### **Fields Backend Provides:**

| Backend Field | Type | Example | Status |
|--------------|------|---------|--------|
| `id` | String | "277f8212..." | ✅ Matches |
| `email` | String | "abrahamosazee2@gmail.com" | ✅ Matches |
| `username` | String | "Abrahamosaz2" | ✅ Matches |
| `fullname` | String | "Abraham Omorisiagbon" | ✅ Matches |
| `createdAt` | DateTime | "2024-12-21T14:57:43.476Z" | ✅ Matches |
| `updatedAt` | DateTime | "2024-12-26T09:44:24.589Z" | ✅ Matches |
| `currency` | String | "NGN" | ✅ Matches |
| `businessName` | String? | null | ✅ Matches |
| `isBusiness` | Boolean | false | ✅ Matches |
| `phoneNumber` | String? | null | ✅ Matches |
| `isPasscodeSet` | Boolean | true | ✅ Matches |
| `isPhoneVerified` | Boolean | false | ✅ Matches |
| `isEmailVerified` | Boolean | true | ✅ Matches |
| `isBvnVerified` | Boolean | false | ✅ Matches |
| `accountType` | String | "PERSONAL" | ✅ Matches |
| `profileImageFilename` | String | "nattypay/..." | ✅ Matches |
| `profileImageUrl` | String | "https://res.cloudinary..." | ✅ Matches |

### **Fields Backend DOESN'T Provide (Using Defaults):**

| App Field | Default Value | Reason |
|-----------|--------------|--------|
| `role` | "USER" | Not in backend response |
| `status` | "ACTIVE" | Not in backend response |
| `gender` | null | Not in backend response |
| `country` | null | Not in backend response |
| `companyRegistrationNumber` | null | Not in backend response |
| `nin` | null | Not in backend response |
| `address` | null | Not in backend response |
| `state` | null | Not in backend response |
| `city` | null | Not in backend response |
| `selfieBase64Image` | null | Not in backend response |
| `referralCode` | null | Not in backend response |
| `dateOfBirth` | null | Not in backend response |
| `tierLevel` | null | Not in backend response |
| `isNinVerified` | false | Not in backend response |
| `isAddressVerified` | false | Not in backend response |
| `isWalletPinSet` | false | ⚠️ **MISSING** - See below |
| `isBusinessRegistered` | false | Not in backend response |
| `enabledTwoFa` | false | Not in backend response |
| `tokenVersion` | 0 | Not in backend response |
| `dailyCummulativeTransactionLimit` | 0 | Not in backend response |
| `cummulativeBalanceLimit` | 0 | Not in backend response |

---

## ⚠️ **CRITICAL MISSING FIELD**

### **`isWalletPinSet` - NOT IN BACKEND RESPONSE!**

**Problem:**
- Your backend doesn't return `isWalletPinSet` field
- This field is **crucial** for hiding the KYC widget
- Without it, the KYC widget won't hide even after PIN setup

**Current Backend Response:**
```json
{
  "isPasscodeSet": true,  ← Only this is returned
  "isBvnVerified": false,
  // isWalletPinSet: MISSING ❌
}
```

**What App Expects:**
```json
{
  "isPasscodeSet": true,
  "isBvnVerified": false,
  "isWalletPinSet": true  ← NEEDED!
}
```

---

## 🛠️ **FIXES IMPLEMENTED**

### **1. Updated API Endpoint**
```dart
// lib/core/constants/api_endpoints.dart
static const String getUserProfile = '/api/v1/user/me';  // ✅ Updated
```

### **2. Fixed User Model Parsing**
```dart
// lib/features/models/user.dart
factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
  role: json['role'] ?? 'USER',      // ✅ Added default
  status: json['status'] ?? 'ACTIVE', // ✅ Added default
  // ... other fields
);
```

---

## 📋 **WHAT NEEDS TO HAPPEN**

### **Option 1: Backend Adds `isWalletPinSet` (RECOMMENDED)**

**Ask backend team to add this field:**
```json
{
  "id": "277f8212-7824-4873-bebe-570df993b5fc",
  "email": "abrahamosazee2@gmail.com",
  // ... other fields
  "isWalletPinSet": true  ← ADD THIS
}
```

**When to set it:**
- After user successfully calls `POST /api/v1/user/set-wallet-pin`
- Backend updates user record: `isWalletPinSet = true`
- Returns `true` when user fetches their profile

### **Option 2: Use `isPasscodeSet` as Substitute (TEMPORARY)**

If backend can't add `isWalletPinSet` quickly, we can use `isPasscodeSet`:

```dart
// In homescreen.dart
final isKycComplete = user?.isBvnVerified == true && 
                      user?.isPasscodeSet == true;  // Use isPasscodeSet instead
```

**Pros:**
✅ Works immediately
✅ No backend changes needed

**Cons:**
❌ `isPasscodeSet` might be for different purpose
❌ Not semantically correct
❌ Could cause issues later

---

## ✅ **WHAT'S ALREADY WORKING**

### **Response Parsing:**
```dart
// This will work fine with current backend response
final user = await repository.getUserProfile();

// These fields will be populated correctly:
user.id                  // ✅ "277f8212..."
user.email              // ✅ "abrahamosazee2@gmail.com"
user.username           // ✅ "Abrahamosaz2"
user.fullname           // ✅ "Abraham Omorisiagbon"
user.isBvnVerified      // ✅ false
user.isPasscodeSet      // ✅ true
user.profileImageUrl    // ✅ "https://res.cloudinary..."

// These will use default values:
user.role               // "USER"
user.status             // "ACTIVE"
user.isWalletPinSet     // false (DEFAULT - needs backend to set)
```

### **KYC Widget Logic:**
```dart
// Currently checks:
final isKycComplete = user?.isBvnVerified == true && 
                      user?.isWalletPinSet == true;

// After backend adds isWalletPinSet:
// - Before PIN: isBvnVerified=false, isWalletPinSet=false → Shows widget
// - After BVN:  isBvnVerified=true,  isWalletPinSet=false → Shows widget
// - After PIN:  isBvnVerified=true,  isWalletPinSet=true  → Hides widget ✅
```

---

## 🎯 **TESTING SCENARIOS**

### **Test 1: Fetch User Profile**
```dart
final user = await ref.read(userNotifierProvider.notifier).refreshUserProfile();

// Should work fine
expect(user?.email, 'abrahamosazee2@gmail.com');
expect(user?.username, 'Abrahamosaz2');
expect(user?.isBvnVerified, false);
```

### **Test 2: After PIN Setup (Current Issue)**
```dart
// Set PIN
await setWalletPin(request);

// Refresh profile
final updatedUser = await refreshUserProfile();

// PROBLEM: isWalletPinSet will still be false!
expect(updatedUser?.isWalletPinSet, false); // ❌ Backend doesn't update this
```

### **Test 3: After Backend Fix**
```dart
// Set PIN
await setWalletPin(request);

// Refresh profile
final updatedUser = await refreshUserProfile();

// SUCCESS: Backend now returns isWalletPinSet = true
expect(updatedUser?.isWalletPinSet, true); // ✅ Works!

// KYC widget hides
final isComplete = updatedUser?.isBvnVerified == true && 
                   updatedUser?.isWalletPinSet == true;
expect(isComplete, true); // ✅ Widget hides!
```

---

## 📝 **BACKEND REQUEST**

### **Message to Backend Team:**

```
Hi Backend Team,

The `/api/v1/user/me` endpoint is working great! 

However, we need one additional field for the KYC completion logic:

Please add: `isWalletPinSet` (boolean)

This field should:
1. Be `false` by default for new users
2. Be set to `true` after successful call to `/api/v1/user/set-wallet-pin`
3. Be returned in the `/api/v1/user/me` response

Example updated response:
{
  "id": "277f8212-7824-4873-bebe-570df993b5fc",
  "email": "abrahamosazee2@gmail.com",
  // ... other fields
  "isPasscodeSet": true,
  "isWalletPinSet": true  ← NEW FIELD NEEDED
}

This will allow us to:
- Hide the "Complete Your KYC" widget after user sets their PIN
- Track KYC completion status accurately
- Enable transaction features that require PIN

Thanks!
```

---

## 🔄 **WORKAROUND (TEMPORARY)**

Until backend adds `isWalletPinSet`, you can use this:

```dart
// lib/features/dashboard/view/home/homescreen.dart

// Replace this:
final isKycComplete = user?.isBvnVerified == true && 
                      user?.isWalletPinSet == true;

// With this (temporary):
final isKycComplete = user?.isBvnVerified == true && 
                      user?.isPasscodeSet == true;
```

**Note:** This assumes `isPasscodeSet` means the same as `isWalletPinSet`. Ask backend team to confirm!

---

## ✅ **SUMMARY**

### **What's Updated:**
- ✅ Endpoint changed to `/api/v1/user/me`
- ✅ User model handles missing fields with defaults
- ✅ Will parse backend response correctly

### **What's Working:**
- ✅ User profile fetch
- ✅ Data parsing
- ✅ Auto-refresh after PIN setup

### **What's Missing:**
- ⚠️ Backend doesn't return `isWalletPinSet`
- ⚠️ KYC widget won't hide until this field is added

### **Next Steps:**
1. ✅ **Code is ready** - No more changes needed on app side
2. ⚠️ **Request backend** to add `isWalletPinSet` field
3. ✅ **Test** after backend adds the field
4. 🎉 **Done** - Everything will work automatically!

---

**Date:** October 17, 2025

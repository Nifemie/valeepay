# Get User Profile API - Documentation

## 📋 Overview

The `getUserProfile` endpoint is used to fetch the current user's complete profile information from the backend. This is typically called after authentication-related actions (like setting wallet PIN, completing KYC) to refresh the user's data in the app.

---

## 🔌 API Endpoint Details

### **Endpoint**
```
GET /api/v1/user/profile
```

### **Method**
`GET`

### **Authentication**
✅ **Required** - Uses Bearer token from login/2FA

### **Request Headers**
```http
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
x-api-key: 5821039487621507
```

---

## 📤 REQUEST

### **Request Body**
```
NONE - This is a GET request
```

The endpoint doesn't require any request body. The user is identified by the **access token** in the Authorization header.

### **Query Parameters**
```
NONE
```

---

## 📥 RESPONSE

### **Success Response (200 OK)**

The backend returns the complete user object with all current data.

#### **Response Structure:**
```json
{
  "id": "user_123abc",
  "email": "john.doe@example.com",
  "username": "johndoe",
  "fullname": "John Doe",
  "role": "USER",
  "status": "ACTIVE",
  "phoneNumber": "+2348012345678",
  "gender": "MALE",
  "country": "Nigeria",
  "businessName": null,
  "companyRegistrationNumber": null,
  "nin": null,
  "address": "123 Main Street",
  "state": "Lagos",
  "city": "Ikeja",
  "selfieBase64Image": null,
  "accountType": "PERSONAL",
  "profileImageFilename": null,
  "profileImageUrl": "https://example.com/profile.jpg",
  "referralCode": "JOHN123",
  "dateOfBirth": "1990-01-15",
  "currency": "NGN",
  "tierLevel": "KYC1",
  "createdAt": "2025-10-01T10:30:00Z",
  "updatedAt": "2025-10-17T14:25:00Z",
  "isEmailVerified": true,
  "isPhoneVerified": true,
  "isBvnVerified": true,
  "isNinVerified": false,
  "isAddressVerified": true,
  "isWalletPinSet": true,
  "isBusiness": false,
  "isBusinessRegistered": false,
  "enabledTwoFa": true,
  "isPasscodeSet": true,
  "tokenVersion": 1,
  "dailyCummulativeTransactionLimit": 500000,
  "cummulativeBalanceLimit": 5000000
}
```

### **Field Descriptions**

| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Unique user identifier |
| `email` | String | User's email address |
| `username` | String | Unique username |
| `fullname` | String | User's full name |
| `role` | String | User role (USER, ADMIN, etc.) |
| `status` | String | Account status (ACTIVE, SUSPENDED, etc.) |
| `phoneNumber` | String? | User's phone number |
| `gender` | String? | User's gender |
| `country` | String? | User's country |
| `businessName` | String? | Business name (if business account) |
| `companyRegistrationNumber` | String? | Company registration number |
| `nin` | String? | National Identification Number |
| `address` | String? | User's address |
| `state` | String? | User's state |
| `city` | String? | User's city |
| `selfieBase64Image` | String? | Base64 encoded selfie for KYC |
| `accountType` | String? | PERSONAL or BUSINESS |
| `profileImageFilename` | String? | Profile image filename |
| `profileImageUrl` | String? | Full URL to profile image |
| `referralCode` | String? | User's referral code |
| `dateOfBirth` | String? | Date of birth (ISO format) |
| `currency` | String? | User's preferred currency |
| `tierLevel` | String? | KYC tier level (KYC0, KYC1, KYC2, KYC3) |
| `createdAt` | DateTime? | Account creation timestamp |
| `updatedAt` | DateTime? | Last update timestamp |
| `isEmailVerified` | Boolean | Email verification status |
| `isPhoneVerified` | Boolean | Phone verification status |
| `isBvnVerified` | Boolean | ✅ **BVN verification status** |
| `isNinVerified` | Boolean | NIN verification status |
| `isAddressVerified` | Boolean | Address verification status |
| `isWalletPinSet` | Boolean | ✅ **Wallet PIN setup status** |
| `isBusiness` | Boolean | Is business account |
| `isBusinessRegistered` | Boolean | Business registration status |
| `enabledTwoFa` | Boolean | 2FA enabled status |
| `isPasscodeSet` | Boolean | Passcode setup status |
| `tokenVersion` | Integer | Token version for security |
| `dailyCummulativeTransactionLimit` | Number | Daily transaction limit |
| `cummulativeBalanceLimit` | Number | Balance limit |

---

## ❌ ERROR RESPONSES

### **401 Unauthorized**
```json
{
  "message": "Unauthorized - Invalid or expired token",
  "statusCode": 401
}
```
**Cause**: Missing or invalid access token

### **404 Not Found**
```json
{
  "message": "User not found",
  "statusCode": 404
}
```
**Cause**: User ID from token doesn't exist

### **500 Internal Server Error**
```json
{
  "message": "Failed to fetch user profile",
  "statusCode": 500
}
```
**Cause**: Server error

---

## 💻 IMPLEMENTATION

### **Current Implementation**

#### **File:** `lib/features/repositories/user_repository.dart`

```dart
Future<UserModel> getUserProfile() async {
  try {
    final response = await apiClient.get(ApiEndpoints.getUserProfile);
    return UserModel.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch user profile');
  }
}
```

#### **File:** `lib/core/constants/api_endpoints.dart`

```dart
static const String getUserProfile = '/api/v1/user/profile';
```

#### **File:** `lib/features/notifiers/user_notifier.dart`

```dart
Future<UserModel?> refreshUserProfile() async {
  try {
    final user = await _repository.getUserProfile();
    // Update state with fresh user data
    state = state.copyWith(
      data: [user],
      isDataAvailable: true,
    );
    return user;
  } catch (e, stack) {
    log('[UserNotifier Refresh Profile Error] $e\n$stack');
    return null;
  }
}
```

---

## 🔄 WHEN TO CALL THIS ENDPOINT

### **After Authentication Events**
- ✅ After completing BVN verification
- ✅ After setting wallet PIN
- ✅ After completing KYC steps
- ✅ After updating profile information
- ✅ After enabling/disabling 2FA

### **On App Lifecycle**
- ✅ When app starts (to check for backend updates)
- ✅ After user comes back from background
- ✅ Periodically to ensure data sync

### **Example Use Case: After PIN Setup**
```dart
// After successful PIN setup
final response = await setWalletPin(request);

if (response != null) {
  // Refresh user profile to get updated isWalletPinSet status
  final updatedUser = await refreshUserProfile();
  
  if (updatedUser != null) {
    // Update local state
    ref.read(userProvider.notifier).setUser(updatedUser);
    
    // Update session storage
    await SessionService.saveSession(LoginResponse(
      user: updatedUser,
      accessToken: currentToken,
      message: 'Success',
      statusCode: 200,
    ));
  }
}
```

---

## 🎯 WHAT GETS UPDATED

After calling this endpoint, the following user fields should reflect backend changes:

### **After BVN Verification:**
```json
{
  "isBvnVerified": true,   // ✅ Updated from false to true
  "tierLevel": "KYC1",     // ✅ May be updated
  "updatedAt": "..."       // ✅ Updated timestamp
}
```

### **After Wallet PIN Setup:**
```json
{
  "isWalletPinSet": true,  // ✅ Updated from false to true
  "updatedAt": "..."       // ✅ Updated timestamp
}
```

### **After NIN Verification (KYC Level 2):**
```json
{
  "isNinVerified": true,   // ✅ Updated
  "tierLevel": "KYC2",     // ✅ Updated
  "selfieBase64Image": "...", // ✅ May be populated
  "updatedAt": "..."       // ✅ Updated
}
```

---

## 🧪 TESTING

### **Test Scenarios**

#### **1. Successful Profile Fetch**
```dart
// Call endpoint
final user = await repository.getUserProfile();

// Verify response
expect(user.id, isNotEmpty);
expect(user.email, isNotEmpty);
expect(user.username, isNotEmpty);
```

#### **2. After PIN Setup - Verify Update**
```dart
// Before PIN setup
final userBefore = await repository.getUserProfile();
expect(userBefore.isWalletPinSet, false);

// Set PIN
await repository.setWalletPin(request);

// After PIN setup
final userAfter = await repository.getUserProfile();
expect(userAfter.isWalletPinSet, true);
```

#### **3. Authentication Required**
```dart
// Remove token
await SessionService.logout();

// Try to fetch profile
try {
  await repository.getUserProfile();
  fail('Should throw exception');
} catch (e) {
  expect(e.toString(), contains('Unauthorized'));
}
```

---

## 📝 BACKEND EXPECTATIONS

The backend should:

1. ✅ Verify the access token from Authorization header
2. ✅ Extract user ID from the token
3. ✅ Fetch complete user data from database
4. ✅ Return all user fields (including verification statuses)
5. ✅ Return 401 if token is invalid/expired
6. ✅ Return 404 if user doesn't exist

---

## 🔐 SECURITY

### **Token Validation**
- Backend validates the Bearer token
- Token must be valid and not expired
- User must exist in the database

### **Data Privacy**
- Only returns data for the authenticated user
- Cannot fetch other users' profiles
- Sensitive data (PIN, passwords) are never returned

---

## ⚡ PERFORMANCE

### **Caching Strategy**
```dart
// Cache user data locally
await SessionService.saveSession(loginResponse);

// Read from cache
final cachedUser = await SessionService.getUser();

// Refresh from backend when needed
final freshUser = await refreshUserProfile();
```

### **When to Cache vs Refresh**

**Use Cache:**
- ✅ Displaying user name, email (rarely changes)
- ✅ Profile image URL
- ✅ Basic account info

**Refresh from Backend:**
- ✅ After KYC actions (BVN, NIN, PIN)
- ✅ After profile updates
- ✅ On app start (to ensure sync)
- ✅ When verification status matters

---

## 🎉 SUMMARY

### **No Request Body Required**
The `getUserProfile` endpoint is a simple **GET request** with:
- ✅ No request body
- ✅ No query parameters
- ✅ Only requires Authorization header with Bearer token

### **Response Contains**
- ✅ Complete user object
- ✅ All verification statuses (`isBvnVerified`, `isWalletPinSet`, etc.)
- ✅ KYC tier level
- ✅ Transaction limits
- ✅ All profile information

### **Use Cases**
- ✅ Refresh user data after PIN setup ← **Your current use case**
- ✅ Check KYC completion status
- ✅ Update UI based on verification status
- ✅ Sync local state with backend

---

**Date:** October 17, 2025

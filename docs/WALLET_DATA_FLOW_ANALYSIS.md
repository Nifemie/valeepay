# Wallet Data Flow Analysis

## 📊 **Current State vs Expected Flow**

### **❌ What's MISSING:**

The flow you described is **NOT currently implemented**. Here's the comparison:

---

## 🔴 **Expected Flow (From Your Description):**

```
1. App calls getAllUserData() on dashboard initialization
2. Data fetched from backend /api/v1/user/me
3. Response parsed into User model
4. Saved to SharedPreferences as 'userData'
5. UI reads from dashboardController.user.wallets[0] for account number and balance
6. Balance updates after successful transactions (calls getAllUserData() again)
```

### **❌ What's Actually Happening:**

```dart
// homescreen.dart - Line 99
final balance = '₦0.00';  // ❌ HARDCODED! Not from backend
```

---

## ✅ **What IS Currently Implemented:**

### **1. User Profile Fetching** ✅
```dart
// user_notifier.dart
Future<UserModel?> refreshUserProfile() async {
  final user = await _repository.getUserProfile();
  // Calls GET /api/v1/user/me
  return user;
}
```

### **2. User Model** ❌ **NO WALLET DATA**
```dart
// user.dart
class UserModel {
  final String id;
  final String email;
  final String username;
  // ... other fields
  
  // ❌ NO wallet field!
  // ❌ NO balance field!
  // ❌ NO account number field!
}
```

### **3. Backend Response** ✅ **HAS WALLET ARRAY**

From your actual API logs:
```json
{
  "id": "e5a84c20-f261-47f2-af21-04458d72860c",
  "email": "tosinolowu280@gmail.com",
  "username": "Angell",
  "wallet": []  // ✅ Backend DOES return wallet array!
}
```

### **4. Current Dashboard** ❌ **HARDCODED BALANCE**
```dart
// homescreen.dart
final balance = '₦0.00';  // ❌ Static, not from user data
final profileImageUrl = 'https://i.pravatar.cc/150?img=3';  // ❌ Hardcoded avatar
```

---

## 🔧 **What Needs to Be Built:**

### **Step 1: Add Wallet Model**

```dart
// lib/features/models/wallet.dart
class WalletModel {
  final String id;
  final String accountNumber;
  final String accountName;
  final double balance;
  final String currency;
  final String? bankName;
  final String? bankCode;
  final bool isActive;
  
  WalletModel({
    required this.id,
    required this.accountNumber,
    required this.accountName,
    required this.balance,
    required this.currency,
    this.bankName,
    this.bankCode,
    this.isActive = true,
  });
  
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'NGN',
      bankName: json['bankName'],
      bankCode: json['bankCode'],
      isActive: json['isActive'] ?? true,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'accountNumber': accountNumber,
    'accountName': accountName,
    'balance': balance,
    'currency': currency,
    'bankName': bankName,
    'bankCode': bankCode,
    'isActive': isActive,
  };
}
```

### **Step 2: Update User Model**

```dart
// user.dart - Add wallet field
import 'package:valarpay/features/models/wallet.dart';

class UserModel {
  // ... existing fields
  final List<WalletModel> wallets;  // ✅ ADD THIS
  
  UserModel({
    // ... existing params
    this.wallets = const [],  // ✅ ADD THIS
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // ... existing fields
      wallets: (json['wallet'] as List?)  // ✅ ADD THIS
          ?.map((w) => WalletModel.fromJson(w))
          .toList() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      // ... existing fields
      'wallet': wallets.map((w) => w.toJson()).toList(),  // ✅ ADD THIS
    };
  }
}
```

### **Step 3: Update Dashboard to Use Real Data**

```dart
// homescreen.dart
@override
Widget build(BuildContext context) {
  final user = ref.watch(userProvider);
  
  // ✅ Get real data from user
  final firstName = (user?.fullname ?? 'Guest').split(' ').first;
  final profileImageUrl = user?.profileImageUrl ?? 'https://i.pravatar.cc/150?img=3';
  
  // ✅ Get balance from wallet
  final wallet = user?.wallets.isNotEmpty == true ? user!.wallets[0] : null;
  final balance = wallet != null 
      ? '₦${wallet.balance.toStringAsFixed(2)}'
      : '₦0.00';
  
  final accountNumber = wallet?.accountNumber ?? 'N/A';
  
  final greeting = _getGreeting();
  
  return Scaffold(
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,  // ✅ Already implemented
        child: SingleChildScrollView(
          // ... rest of UI
```

### **Step 4: Create Dashboard Controller (Optional)**

If you want the `dashboardController.user.wallets[0]` pattern:

```dart
// lib/controller/dashboard_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/models/user.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class DashboardController extends StateNotifier<UserModel?> {
  final UserNotifier _userNotifier;
  
  DashboardController(this._userNotifier) : super(null);
  
  // Get user data
  UserModel? get user => state;
  
  // Initialize - called on dashboard load
  Future<void> getAllUserData() async {
    final userData = await _userNotifier.refreshUserProfile();
    if (userData != null) {
      state = userData;
    }
  }
  
  // Get primary wallet
  WalletModel? get primaryWallet => 
      state?.wallets.isNotEmpty == true ? state!.wallets[0] : null;
  
  // Get balance
  double get balance => primaryWallet?.balance ?? 0.0;
  
  // Get account number  
  String get accountNumber => primaryWallet?.accountNumber ?? '';
}

// Provider
final dashboardControllerProvider = 
    StateNotifierProvider<DashboardController, UserModel?>((ref) {
  return DashboardController(ref.read(userNotifierProvider.notifier));
});
```

Usage:
```dart
// In homescreen.dart
@override
void initState() {
  super.initState();
  _startBannerRotation();
  
  // ✅ Initialize dashboard data
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(dashboardControllerProvider.notifier).getAllUserData();
  });
}

@override
Widget build(BuildContext context) {
  final dashboardController = ref.watch(dashboardControllerProvider.notifier);
  
  // ✅ Access data via controller
  final balance = '₦${dashboardController.balance.toStringAsFixed(2)}';
  final accountNumber = dashboardController.accountNumber;
  final wallet = dashboardController.primaryWallet;
}
```

---

## 🎯 **Implementation Priority:**

### **Phase 1: Minimum Viable** (Do This First)
1. ✅ Create `WalletModel` class
2. ✅ Add `wallets` field to `UserModel`
3. ✅ Update `fromJson` to parse wallet array
4. ✅ Update homescreen to display real balance

### **Phase 2: Controller Pattern** (Optional)
5. ⭐ Create `DashboardController` 
6. ⭐ Implement `getAllUserData()` method
7. ⭐ Use controller pattern in UI

---

## 📋 **Current Status:**

| Feature | Status | Notes |
|---------|--------|-------|
| `/api/v1/user/me` endpoint | ✅ Working | Returns wallet array |
| `UserModel` parsing | ❌ Missing | No wallet field |
| `WalletModel` class | ❌ Not created | Needed for wallet data |
| Dashboard balance display | ❌ Hardcoded | Shows ₦0.00 always |
| `getAllUserData()` method | ❌ Missing | No such method exists |
| `dashboardController` | ❌ Missing | No controller pattern |
| Pull-to-refresh | ✅ Working | Calls `refreshUserProfile()` |

---

## 🔍 **Backend Wallet Structure (Unknown)**

We need to know what the backend actually returns in the `wallet` array. From your logs, it's currently empty:

```json
{
  "wallet": []  // ← Empty, user might not have wallet yet
}
```

**Questions for Backend Team:**

1. What fields are in each wallet object?
2. Can a user have multiple wallets?
3. Which wallet is the "primary" one?
4. Sample populated wallet response?

**Expected wallet structure:**
```json
{
  "wallet": [
    {
      "id": "wallet-id-123",
      "accountNumber": "1234567890",
      "accountName": "Tosin Olowu",
      "balance": 50000.00,
      "currency": "NGN",
      "bankName": "ValarPay Bank",
      "bankCode": "999",
      "isActive": true,
      "createdAt": "2025-01-01T00:00:00Z"
    }
  ]
}
```

---

## 🚀 **Quick Implementation Plan:**

### **Option A: Simple Approach** (Recommended for now)

Just update the homescreen to use existing user data:

```dart
// homescreen.dart
@override
Widget build(BuildContext context) {
  final user = ref.watch(userProvider);
  
  // Use real profile image
  final profileImageUrl = user?.profileImageUrl?.isNotEmpty == true
      ? user!.profileImageUrl!
      : 'https://i.pravatar.cc/150?img=3';
  
  // Balance - wait for wallet implementation
  final balance = '₦0.00'; // TODO: Get from user.wallets[0].balance
  
  // ... rest
}
```

### **Option B: Full Implementation** (Complete Solution)

1. Create `WalletModel`
2. Update `UserModel` with wallets
3. Create `DashboardController`
4. Implement `getAllUserData()`
5. Update all UI to use controller

---

## ✅ **What You Should Do:**

### **Immediate Action:**

1. **Check Backend Response** - What's in the wallet array when user has funds?
2. **Create WalletModel** - Based on actual backend structure
3. **Update UserModel** - Add wallets field
4. **Test** - Verify wallet data parses correctly

### **Then:**

5. **Update Dashboard** - Display real balance
6. **Add Refresh** - Already works with pull-to-refresh
7. **Test Transactions** - Verify balance updates after payment

---

**Date:** October 17, 2025  
**Status:** Analysis Complete - Ready for Implementation
**Next Step:** Get actual wallet object structure from backend

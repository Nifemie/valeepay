# UI Screens & Updates After User Profile Implementation

## 📋 Overview

After implementing the `getUserProfile` endpoint and user data refresh functionality, here's what screens and UI elements you need to build or update.

---

## ✅ **ALREADY IMPLEMENTED (No New Screens Needed)**

### **1. KYC Widget on Home Screen** ✅
**Status:** Already done!

**File:** `lib/features/dashboard/view/home/homescreen.dart`

**What it does:**
```dart
Consumer(
  builder: (context, ref, child) {
    final user = ref.watch(userProvider);
    final isKycComplete = user?.isBvnVerified == true && 
                          user?.isWalletPinSet == true;
    
    if (isKycComplete) {
      return const SizedBox.shrink(); // ✅ Hides when complete
    }
    
    return const KYCWidget(); // Shows "Complete Your KYC"
  },
)
```

**Behavior:**
- ✅ Shows "Complete Your KYC" card when user hasn't finished KYC
- ✅ Automatically hides after BVN verification + PIN setup
- ✅ No new screen needed - already working!

---

### **2. User Data Refresh After PIN Setup** ✅
**Status:** Already done!

**File:** `lib/features/dashboard/view/KYC/confirm_transaction_pin_page.dart`

**What it does:**
```dart
// After successful PIN setup
final updatedUser = await ref
    .read(userNotifierProvider.notifier)
    .refreshUserProfile();  // ✅ Fetches fresh user data

if (updatedUser != null) {
  ref.read(userProvider.notifier).setUser(updatedUser);  // ✅ Updates local state
  await SessionService.saveSession(...);  // ✅ Saves to storage
}
```

**Behavior:**
- ✅ Automatically refreshes user data after PIN setup
- ✅ Updates `isWalletPinSet` flag
- ✅ Triggers KYC widget to hide on home screen
- ✅ No new screen needed!

---

## 📝 **SCREENS YOU MAY WANT TO BUILD LATER (Optional)**

### **1. Profile/Settings Screen** 📱 (OPTIONAL)

**Purpose:** Show user's account information and verification status

**Location:** Could be in "More" tab or hamburger menu

**What to display:**

```dart
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: ListView(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user?.profileImageUrl ?? ''),
          ),
          
          // User Info
          ListTile(
            title: Text('Full Name'),
            subtitle: Text(user?.fullname ?? 'N/A'),
          ),
          
          ListTile(
            title: Text('Email'),
            subtitle: Text(user?.email ?? 'N/A'),
          ),
          
          ListTile(
            title: Text('Phone'),
            subtitle: Text(user?.phoneNumber ?? 'N/A'),
          ),
          
          // Verification Status
          Divider(),
          ListTile(
            title: Text('KYC Status'),
            subtitle: Text(user?.tierLevel ?? 'KYC0'),
            trailing: _getKycBadge(user?.tierLevel),
          ),
          
          // Verification Checkmarks
          _VerificationItem(
            title: 'Email Verified',
            isVerified: user?.isEmailVerified ?? false,
          ),
          
          _VerificationItem(
            title: 'Phone Verified',
            isVerified: user?.isPhoneVerified ?? false,
          ),
          
          _VerificationItem(
            title: 'BVN Verified',
            isVerified: user?.isBvnVerified ?? false,
          ),
          
          _VerificationItem(
            title: 'Wallet PIN Set',
            isVerified: user?.isWalletPinSet ?? false,
          ),
          
          // Account Limits
          Divider(),
          ListTile(
            title: Text('Daily Transaction Limit'),
            subtitle: Text('₦${user?.dailyCummulativeTransactionLimit ?? 0}'),
          ),
          
          ListTile(
            title: Text('Balance Limit'),
            subtitle: Text('₦${user?.cummulativeBalanceLimit ?? 0}'),
          ),
        ],
      ),
    );
  }
}

class _VerificationItem extends StatelessWidget {
  final String title;
  final bool isVerified;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isVerified ? Icons.check_circle : Icons.cancel,
        color: isVerified ? Colors.green : Colors.red,
      ),
      title: Text(title),
      trailing: Text(
        isVerified ? 'Verified' : 'Not Verified',
        style: TextStyle(
          color: isVerified ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
```

**When to build:** When you want users to see their account details and verification status.

**Priority:** LOW (Nice to have, but not critical for core functionality)

---

### **2. KYC Status/Progress Screen** 📊 (OPTIONAL)

**Purpose:** Show detailed KYC completion progress

**What to display:**

```dart
class KycStatusScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('KYC Status')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Overall Progress
            Text('KYC Level: ${user?.tierLevel ?? "KYC0"}'),
            LinearProgressIndicator(
              value: _calculateKycProgress(user),
            ),
            
            SizedBox(height: 24),
            
            // Step-by-step checklist
            _KycStep(
              title: 'Email Verification',
              isComplete: user?.isEmailVerified ?? false,
              description: 'Verify your email address',
            ),
            
            _KycStep(
              title: 'Phone Verification',
              isComplete: user?.isPhoneVerified ?? false,
              description: 'Verify your phone number',
            ),
            
            _KycStep(
              title: 'BVN Verification',
              isComplete: user?.isBvnVerified ?? false,
              description: 'Verify your Bank Verification Number',
              onTap: user?.isBvnVerified == false
                  ? () => Navigator.push(...)  // Go to BVN screen
                  : null,
            ),
            
            _KycStep(
              title: 'Transaction PIN',
              isComplete: user?.isWalletPinSet ?? false,
              description: 'Set up your 4-digit transaction PIN',
              onTap: user?.isWalletPinSet == false
                  ? () => Navigator.push(...)  // Go to PIN setup
                  : null,
            ),
            
            _KycStep(
              title: 'NIN Verification (Level 2)',
              isComplete: user?.isNinVerified ?? false,
              description: 'Verify your National Identification Number',
              isOptional: true,
            ),
          ],
        ),
      ),
    );
  }
  
  double _calculateKycProgress(UserModel? user) {
    if (user == null) return 0.0;
    
    int completed = 0;
    int total = 4;
    
    if (user.isEmailVerified) completed++;
    if (user.isPhoneVerified) completed++;
    if (user.isBvnVerified) completed++;
    if (user.isWalletPinSet) completed++;
    
    return completed / total;
  }
}
```

**When to build:** If you want a dedicated screen showing KYC progress.

**Priority:** LOW (The home screen KYC widget already handles this)

---

### **3. Account Settings Screen** ⚙️ (OPTIONAL)

**Purpose:** Manage account settings and security

**What to include:**

```dart
class AccountSettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Account Settings')),
      body: ListView(
        children: [
          // Security Section
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Transaction PIN'),
            subtitle: Text('Update your 4-digit PIN'),
            onTap: () => _changePin(context),
          ),
          
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Two-Factor Authentication'),
            subtitle: Text(user?.enabledTwoFa == true ? 'Enabled' : 'Disabled'),
            trailing: Switch(
              value: user?.enabledTwoFa ?? false,
              onChanged: (value) => _toggle2FA(context, value),
            ),
          ),
          
          // Account Info
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            onTap: () => _editProfile(context),
          ),
          
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Upgrade KYC Level'),
            subtitle: Text('Current: ${user?.tierLevel ?? "KYC0"}'),
            onTap: () => _upgradeKyc(context),
          ),
          
          // Danger Zone
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
```

**When to build:** When you want users to manage their account settings.

**Priority:** MEDIUM (Common feature in fintech apps)

---

## 🚫 **SCREENS YOU DON'T NEED TO BUILD**

### **1. User Data Display After Refresh**
❌ **Not needed** - Data automatically updates everywhere via `userProvider`

### **2. KYC Completion Confirmation**
❌ **Not needed** - Already handled by success dialog after PIN setup

### **3. Token Refresh Screen**
❌ **Not needed** - Happens automatically in background

### **4. Profile Sync Loading**
❌ **Not needed** - Refresh happens quickly, no loading screen required

---

## 🎯 **WHAT YOU ACTUALLY NEED TO DO**

### **Minimum (Already Done):** ✅
1. ✅ KYC widget hides when complete
2. ✅ User data refreshes after PIN setup
3. ✅ No new screens needed!

### **Optional Future Enhancements:** 📝

#### **Phase 1: Basic Profile (If Needed)**
- Profile screen showing user info
- Verification status indicators
- Account limits display

#### **Phase 2: Settings (If Needed)**
- Change PIN functionality
- Toggle 2FA
- Edit profile information

#### **Phase 3: Advanced (If Needed)**
- KYC progress tracking
- Transaction history with PIN
- Account upgrade options

---

## 💡 **WHERE USER DATA IS ALREADY DISPLAYED**

### **Home Screen:**
```dart
// User's name in greeting
final firstName = (user?.fullname ?? 'Guest').split(' ').first;

// Profile image
final profileImageUrl = user?.profileImageUrl ?? 'https://i.pravatar.cc/150?img=3';

// KYC widget (shows/hides based on verification status)
final isKycComplete = user?.isBvnVerified == true && user?.isWalletPinSet == true;
```

### **Throughout App:**
Any screen that uses `ref.watch(userProvider)` will automatically get updated user data after refresh!

---

## 🔄 **AUTOMATIC UI UPDATES**

After calling `refreshUserProfile()`, these update automatically:

1. ✅ **Home screen** - KYC widget hides if complete
2. ✅ **User name** - Updates if changed
3. ✅ **Profile image** - Updates if changed
4. ✅ **Any widget using userProvider** - Gets fresh data

No manual UI updates needed!

---

## 📊 **VISUAL FLOW**

```
User completes PIN setup
         ↓
Success dialog shows
         ↓
User clicks "Done"
         ↓
App calls refreshUserProfile() ✅
         ↓
Backend returns updated user data
         ↓
Local state updates automatically
         ↓
Home screen re-renders
         ↓
KYC widget checks: isBvnVerified && isWalletPinSet
         ↓
Both are TRUE ✅
         ↓
KYC widget HIDES automatically! 🎉
```

---

## ✅ **SUMMARY**

### **Do You Need New Screens? NO! 🎉**

Everything you need is already implemented:
- ✅ User data refreshes automatically
- ✅ KYC widget hides when complete
- ✅ UI updates happen automatically via userProvider
- ✅ No new screens required for core functionality

### **Optional Screens for Future:**
- 📱 Profile screen (show user details)
- ⚙️ Settings screen (change PIN, toggle 2FA)
- 📊 KYC progress screen (detailed status)

**Priority:** All optional - core functionality works without them!

---

**Conclusion:** You're good to go! Just send the correct endpoint URL to the backend team and everything will work automatically. No new screens needed! 🚀

---

**Date:** October 17, 2025

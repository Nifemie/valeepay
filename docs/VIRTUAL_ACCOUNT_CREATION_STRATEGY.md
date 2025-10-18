# Virtual Account Creation Implementation Strategy

## Overview
The backend has a "Create Virtual Account" endpoint that requires:
```json
{
    "bvn": "22222222254",
    "dateOfBirth": "05-Apr-1994"
}
```

## Current Situation

### Data Available
1. **BVN**: Collected during KYC flow (stored in `bvnProvider`)
2. **Date of Birth**: Already stored in `UserModel.dateOfBirth` (from backend `/api/v1/user/me`)

### Current Flow
```
1. BVN Entry (BVN.dart)
   ↓
2. Initialize BVN API → Get verificationId
   ↓
3. OTP Verification (bvn_otp_verification.dart)
   ↓
4. Validate BVN API → Success: isBvnVerified = true
   ↓
5. Setup Transaction PIN (setup_pin.dart)
   ↓
6. Dashboard (wallet still empty)
```

## Recommended Implementation

### 🎯 Option 1: Call After BVN Validation (RECOMMENDED)

**When**: Immediately after successful BVN validation (in `bvn_otp_verification.dart`)

**Why This is Best**:
- ✅ User just verified their BVN - it's fresh and valid
- ✅ We have both required fields: `bvn` (from widget) and `dateOfBirth` (from UserModel)
- ✅ Creates wallet immediately after verification
- ✅ User sees their wallet balance on dashboard right after KYC
- ✅ Natural flow: Verify Identity → Get Wallet → Set PIN → Use Wallet

**Implementation Location**:
```dart
// In bvn_otp_verification.dart, after validateBvn success:

if (response != null) {
  // Success - BVN verified
  AppMessenger.show(context, type: MessageType.success, message: response.message);
  
  // 🆕 CREATE VIRTUAL ACCOUNT HERE
  await _createVirtualAccount();
  
  // Then proceed to PIN setup
  ref.read(kycStepProvider.notifier).state = 4;
  Navigator.pushReplacement(context, MaterialPageRoute(...));
}
```

**Advantages**:
1. Wallet exists before PIN setup
2. User can see account number immediately
3. Logical flow: Identity → Account → Security
4. All data is available (BVN + DOB from user profile)

---

### Option 2: Call After PIN Setup

**When**: After successful transaction PIN creation

**Why Less Ideal**:
- ⚠️ User completes entire KYC but wallet still empty
- ⚠️ Additional API call after user thinks they're done
- ⚠️ Potential error leaves user in "verified but no wallet" state

**Use Case**: Only if backend requires PIN to exist before wallet creation (unlikely)

---

### Option 3: Background Creation

**When**: Backend creates wallet automatically after BVN verification

**Why Not Ideal**:
- ⚠️ No control over timing
- ⚠️ User might reach dashboard before wallet exists
- ⚠️ Requires polling or waiting
- ⚠️ We already tested this - user had empty wallet array

## Detailed Implementation Plan

### Step 1: Create Request/Response Models

**File**: `lib/features/models/create_virtual_account_request.dart`
```dart
class CreateVirtualAccountRequest {
  final String bvn;
  final String dateOfBirth;

  CreateVirtualAccountRequest({
    required this.bvn,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() => {
    'bvn': bvn,
    'dateOfBirth': dateOfBirth,
  };
}
```

**File**: `lib/features/models/create_virtual_account_response.dart`
```dart
class CreateVirtualAccountResponse {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data; // Contains wallet info

  CreateVirtualAccountResponse({
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory CreateVirtualAccountResponse.fromJson(Map<String, dynamic> json) {
    return CreateVirtualAccountResponse(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
      data: json['data'],
    );
  }

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
```

### Step 2: Add API Endpoint

**File**: `lib/core/constants/api_endpoints.dart`
```dart
class ApiEndpoints {
  // ... existing endpoints ...
  
  // Wallet - Virtual Account
  static const String createVirtualAccount = '/api/v1/wallet/create-virtual-account';
}
```

### Step 3: Add Repository Method

**File**: `lib/features/repositories/user_repository.dart`
```dart
import 'package:valarpay/features/models/create_virtual_account_request.dart';
import 'package:valarpay/features/models/create_virtual_account_response.dart';

class UserRepository {
  // ... existing methods ...
  
  Future<CreateVirtualAccountResponse> createVirtualAccount(
      CreateVirtualAccountRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.createVirtualAccount,
        data: request.toJson(),
      );
      return CreateVirtualAccountResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create virtual account'
      );
    }
  }
}
```

### Step 4: Add Notifier Method

**File**: `lib/features/notifiers/user_notifier.dart`
```dart
Future<CreateVirtualAccountResponse?> createVirtualAccount(
    CreateVirtualAccountRequest request) async {
  try {
    final response = await _repository.createVirtualAccount(request);
    
    if (response.isSuccess) {
      // Refresh user profile to get new wallet data
      await refreshUserProfile();
    }
    
    return response;
  } catch (e, stack) {
    log('[UserNotifier Create Virtual Account Error] $e\n$stack');
    state = state.copyWith(message: e.toString());
    return null;
  }
}
```

### Step 5: Integrate in BVN OTP Verification

**File**: `lib/features/dashboard/view/KYC/bvn_otp_verification.dart`

**Add method to state class**:
```dart
Future<void> _createVirtualAccount() async {
  try {
    // Get user's date of birth from profile
    final user = ref.read(userProvider).value;
    final dateOfBirth = user?.dateOfBirth;
    
    if (dateOfBirth == null || dateOfBirth.isEmpty) {
      print('⚠️ Date of birth not available, skipping virtual account creation');
      return;
    }
    
    print('🏦 Creating virtual account for user...');
    
    final request = CreateVirtualAccountRequest(
      bvn: widget.bvn,
      dateOfBirth: dateOfBirth,
    );
    
    final response = await ref
        .read(userNotifierProvider.notifier)
        .createVirtualAccount(request);
    
    if (response != null && response.isSuccess) {
      print('✅ Virtual account created successfully');
      // User profile will be refreshed in the notifier
    } else {
      print('⚠️ Virtual account creation failed: ${response?.message}');
      // Don't block the flow - user can still use the app
    }
  } catch (e) {
    print('❌ Error creating virtual account: $e');
    // Don't block the flow - user can still proceed
  }
}
```

**Update the verify OTP method**:
```dart
Future<void> _verifyOtp() async {
  // ... existing validation code ...
  
  final response = await ref
      .read(userNotifierProvider.notifier)
      .validateBvn(request);

  if (response != null) {
    // Success - BVN verified
    AppMessenger.show(
      context,
      type: MessageType.success,
      message: response.message,
    );

    // 🆕 CREATE VIRTUAL ACCOUNT
    await _createVirtualAccount();

    // Navigate to PIN setup
    ref.read(kycStepProvider.notifier).state = 4;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SetupTransactionPinPage(),
      ),
    );
  } else {
    // Error handling...
  }
}
```

## Date Format Handling

### Backend Expects: "05-Apr-1994"
### Backend Provides: "13-May-2005" (from user profile)

The formats appear to match! But let's add validation:

```dart
// Helper method to ensure date format
String _formatDateOfBirth(String? dob) {
  if (dob == null || dob.isEmpty) return '';
  
  // Backend already provides in correct format: "13-May-2005"
  // Just validate it matches expected pattern
  final regex = RegExp(r'^\d{2}-[A-Za-z]{3}-\d{4}$');
  if (regex.hasMatch(dob)) {
    return dob;
  }
  
  // If format is different, you may need to convert it
  throw Exception('Invalid date of birth format: $dob');
}
```

## Error Handling Strategy

### Non-Blocking Approach (RECOMMENDED)
- Virtual account creation failure should NOT block KYC flow
- User can still proceed to PIN setup
- Show warning message but continue
- User can retry from settings/profile later

```dart
try {
  await _createVirtualAccount();
} catch (e) {
  // Log error but don't stop the flow
  print('⚠️ Virtual account creation failed: $e');
  // Optionally show a non-blocking snackbar
}
```

### Retry Mechanism
Add a "Create Wallet" button in user settings/profile for users who:
- Had creation fail during KYC
- Skipped BVN verification (testing)
- Need to retry for any reason

## Testing Plan

### Test Scenarios
1. ✅ Happy Path: BVN verified → Virtual account created → PIN setup → Wallet visible
2. ⚠️ Missing DOB: Handle gracefully, show appropriate message
3. ⚠️ API Failure: Log error, continue to PIN setup
4. 🔄 Retry: Test creating account from settings page
5. 📱 Already Exists: Handle "account already exists" response

### Verification Checklist
- [ ] Virtual account created after BVN validation
- [ ] Wallet appears in user.wallets array
- [ ] Balance shows on dashboard
- [ ] Account number displays correctly
- [ ] Flow continues to PIN setup even if creation fails
- [ ] Error messages are user-friendly

## Alternative: Manual Trigger

If you prefer manual control, add a button in the app:

**Location**: Settings page or Profile page

```dart
ElevatedButton(
  onPressed: () async {
    final user = ref.read(userProvider).value;
    if (user?.dateOfBirth != null && user?.isBvnVerified == true) {
      // Create virtual account
      final request = CreateVirtualAccountRequest(
        bvn: user.bvn ?? '',
        dateOfBirth: user.dateOfBirth!,
      );
      await ref.read(userNotifierProvider.notifier)
          .createVirtualAccount(request);
    }
  },
  child: Text('Create Virtual Account'),
)
```

## Summary

**RECOMMENDED APPROACH**: 
✅ **Call Create Virtual Account API immediately after BVN validation succeeds**

**Location**: `bvn_otp_verification.dart` → `_verifyOtp()` method → After `validateBvn()` success

**Data Sources**:
- `bvn`: From widget parameter (already passed through flow)
- `dateOfBirth`: From `UserModel` (already in user profile from backend)

**Flow**:
1. User enters BVN → Initialize → OTP
2. User verifies OTP → Validate BVN ✅
3. **Create Virtual Account** 🏦 ← NEW
4. Setup Transaction PIN
5. Dashboard shows wallet with balance

**Benefits**:
- Immediate wallet creation
- User sees balance right away
- Clean, logical flow
- All data readily available
- Non-blocking error handling


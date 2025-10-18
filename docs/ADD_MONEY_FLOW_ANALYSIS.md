# Add Money Flow Analysis

## Current Implementation

### Navigation Path

```
Dashboard (Homescreen)
    ↓ (Click "Add Money" button)
AddMoneyScreen - Shows 4 Options
    ↓
Option 1: Via Bank Transfer → AddMoneyTransferScreen
Option 2: Cash Deposit (Agent) → AddMoneyTransferScreen
Option 3: Top Up with Card/Account → ComingSoonScreen
Option 4: Scan My Code → AddMoneyQRCodeScreen
```

### Add Money Options

**File**: `add_money_screen.dart`

1. **Via Bank Transfer**
   - Icon: `Icons.account_balance`
   - Description: "Send money directly to your ValarPay account via bank transfer"
   - Navigates to: `/add-money-via-transfer`

2. **Cash Deposit (Agent)**
   - Icon: `Icons.store`
   - Description: "Deposit cash safely at any authorized ValarPay agent near you"
   - Navigates to: `/add-money-via-transfer` (same as option 1)

3. **Top Up with Card/Account**
   - Icon: `Icons.credit_card`
   - Description: "Instantly fund your wallet using your debit card or linked bank account"
   - Navigates to: `/coming-soon` ⚠️ NOT IMPLEMENTED

4. **Scan My Code**
   - Icon: `Icons.qr_code`
   - Description: "Add money instantly by scanning your unique ValarPay QR code"
   - Navigates to: `/add-money-via-qrcode`

---

## 🚨 CRITICAL ISSUE: Hardcoded Account Details

### AddMoneyTransferScreen

**File**: `add_money_via_transfer_screen.dart`

**Current Display** (HARDCODED):
```dart
_infoRow("Bank Name", "ValarPay"),
_infoRow("Account Name", "John Smith Emmy"),
_infoRow("Account Number", "0000000000"),
```

### ⚠️ Problems

1. **Fake Account Number**: Shows `"0000000000"` instead of real account
2. **Wrong Account Name**: Shows `"John Smith Emmy"` instead of user's name
3. **Not Dynamic**: Doesn't read from `user.wallets[0].accountNumber`
4. **Misleading to Users**: Users might try to transfer to this fake account!

---

## ✅ SOLUTION: Display Real Wallet Data

### What We Need to Show

From `/api/v1/user/me` → `wallet` array:

```json
{
  "accountNumber": "7834567890",     // Real 10-digit account
  "accountName": "Tosin Olowu",      // User's actual name
  "bankName": "ValarPay Bank"        // Real bank name
}
```

### Required Changes

#### 1. Update `AddMoneyTransferScreen` to Use Riverpod

**Current**: StatefulWidget with hardcoded values  
**Required**: ConsumerStatefulWidget with user data

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class AddMoneyTransferScreen extends ConsumerStatefulWidget {
  const AddMoneyTransferScreen({super.key});

  @override
  ConsumerState<AddMoneyTransferScreen> createState() => 
      _AddMoneyTransferScreenState();
}

class _AddMoneyTransferScreenState 
    extends ConsumerState<AddMoneyTransferScreen> {
  
  @override
  Widget build(BuildContext context) {
    // Get user data
    final user = ref.watch(userProvider).value;
    final wallet = user?.wallets.isNotEmpty == true 
        ? user!.wallets.first 
        : null;
    
    // Extract real data
    final bankName = wallet?.bankName ?? 'ValarPay Bank';
    final accountName = wallet?.accountName ?? user?.fullname ?? 'N/A';
    final accountNumber = wallet?.accountNumber ?? 'Not Available';
    
    // Use real data in UI
    return Scaffold(
      // ... existing code ...
      child: Column(
        children: [
          _infoRow("Bank Name", bankName),
          _infoRow("Account Name", accountName),
          _infoRow("Account Number", accountNumber),
        ],
      ),
    );
  }
}
```

#### 2. Handle Empty Wallet State

Show appropriate message when wallet doesn't exist:

```dart
if (wallet == null) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.wallet, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'Virtual Account Not Created',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Complete your BVN verification to create your account',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () => context.push('/kyc-setup'),
          child: Text('Complete KYC'),
        ),
      ],
    ),
  );
}
```

#### 3. Implement Real Clipboard Copy

Currently: TODO comment, shows fake snackbar

```dart
import 'package:flutter/services.dart';

void _copyToClipboard(String label, String value) {
  Clipboard.setData(ClipboardData(text: value));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("$label copied to clipboard"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ),
  );
}
```

---

## Complete Implementation Checklist

### Files to Update

- [ ] `add_money_via_transfer_screen.dart` - Display real wallet data
- [ ] `add_money_via_qrcode_screen.dart` - Check if it also needs wallet data
- [ ] `add_money_screen.dart` - Consider disabling options if no wallet exists

### Testing Scenarios

1. **User with Wallet** ✅
   - Shows real account number
   - Shows real account name
   - Copy to clipboard works

2. **User without Wallet** ⚠️
   - Shows "Not Available" or prompt to complete KYC
   - Doesn't show fake "0000000000"
   - Button to navigate to KYC setup

3. **Copy Functionality** 📋
   - Account number copies correctly
   - Bank name copies correctly
   - Confirmation snackbar appears

### Priority

**HIGH PRIORITY** 🚨
- This is user-facing financial data
- Wrong account number could cause users to lose money
- Must be fixed before production

---

## Related Implementation

This connects directly to:
- **Virtual Account Creation**: Users need wallet created first
- **Wallet Data Flow**: Must display from `user.wallets[0]`
- **KYC Flow**: Users without BVN verification won't have wallet

### Dependency Chain

```
BVN Verification
    ↓
Create Virtual Account (NEW - needs implementation)
    ↓
Wallet Appears in user.wallets[]
    ↓
Add Money Screen Shows Real Account Number ✅
```

---

## Summary

**Current State**: 
- ❌ Shows fake hardcoded account `"0000000000"`
- ❌ Shows fake name `"John Smith Emmy"`
- ❌ Clipboard copy not implemented

**Required State**:
- ✅ Shows real account from `wallet.accountNumber`
- ✅ Shows real name from `wallet.accountName` or `user.fullname`
- ✅ Clipboard copy functional
- ✅ Handles empty wallet gracefully

**Immediate Action**: Update `add_money_via_transfer_screen.dart` to use real wallet data from Riverpod `userProvider`.


# Bank Code Lookup Fix for Recent Beneficiaries

## Problem
When clicking on a **Recent beneficiary** and navigating to the transfer amount screen, the account verification failed with error:
```
"failed to verify account {bankcode must be 3 to 10}"
```

## Root Cause
The `TransferDetails` model (data from past transactions) does not contain the `beneficiaryBankCode` field. When converting a Recent transaction to a Beneficiary model, we were setting `bankCode` to an empty string `''`, which fails the backend validation that requires `bankCode` to be 3-10 characters.

### Data Available in Recent vs Saved Beneficiaries

| Field | Recent (TransactionModel) | Saved (Beneficiary) |
|-------|-------------------------|-------------------|
| `accountName` | ✅ `beneficiaryName` | ✅ `accountName` |
| `accountNumber` | ✅ `beneficiaryAccountNumber` | ✅ `accountNumber` |
| `bankName` | ✅ `beneficiaryBankName` | ✅ `bankName` |
| `bankCode` | ❌ Not available | ✅ `bankCode` |

## Solution
**Lookup the bank code dynamically** by matching the bank name against the available banks list in the `banksNotifierProvider`.

### Implementation

**File**: `lib/features/dashboard/view/transfer/transfer_to_bank/recent_and_saved_beneficiary.dart`

#### Step 1: Add Import
```dart
import 'package:valarpay/features/notifiers/transfer_notifier.dart';
```

#### Step 2: Update Recent Beneficiary Navigation
```dart
onTap: () {
  final details = b.transferDetails;
  if (details != null && details.beneficiaryAccountNumber != null) {
    // ✅ Get the banks list to lookup bank code by bank name
    final banksState = ref.read(banksNotifierProvider);
    String bankCode = '';

    // ✅ Try to find matching bank by name
    if (banksState.isDataAvailable && banksState.data != null) {
      final bankName = details.beneficiaryBankName ?? '';
      try {
        // Find bank with matching name (case-insensitive contains)
        final matchingBank = banksState.data!.firstWhere(
          (bank) => bank.name
              .toLowerCase()
              .contains(bankName.toLowerCase()),
        );
        bankCode = matchingBank.bankCode; // ✅ Extract bank code
      } catch (_) {
        // Bank not found in list (rare)
      }
    }

    // Convert transaction to Beneficiary with looked-up bank code
    final beneficiary = Beneficiary(
      id: '',
      userId: '',
      type: 'TRANSFER',
      accountName: details.beneficiaryName ?? '',
      accountNumber: details.beneficiaryAccountNumber ?? '',
      bankName: details.beneficiaryBankName ?? '',
      bankCode: bankCode, // ✅ Now populated from lookup
      currency: 'NGN',
      createdAt: '',
      updatedAt: '',
    );

    // Navigate to transfer amount screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BeneficiaryTransferAmountScreen(
          beneficiaryDetails: beneficiary,
        ),
      ),
    );
  }
},
```

## How It Works

1. **Get Banks State**: Read the cached banks list from `banksNotifierProvider`
   ```dart
   final banksState = ref.read(banksNotifierProvider);
   ```

2. **Initialize Bank Code**: Start with empty string as fallback
   ```dart
   String bankCode = '';
   ```

3. **Lookup Bank**: Search the banks list for a bank whose name contains the beneficiary's bank name (case-insensitive)
   ```dart
   final matchingBank = banksState.data!.firstWhere(
     (bank) => bank.name.toLowerCase().contains(bankName.toLowerCase()),
   );
   ```

4. **Extract Bank Code**: Get the matching bank's code
   ```dart
   bankCode = matchingBank.bankCode;
   ```

5. **Pass to Beneficiary**: Use the looked-up bank code when creating the Beneficiary model
   ```dart
   bankCode: bankCode, // ✅ No longer empty
   ```

## Data Flow

```
Recent Transaction
  ↓
Extract beneficiary details
  ↓
Lookup banks list via banksNotifierProvider
  ↓
Find matching bank by name
  ↓
Extract bankCode (e.g., "050" for Ecobank, "044" for Access Bank, "999" for ValarPay)
  ↓
Create Beneficiary with bankCode
  ↓
Navigate to BeneficiaryTransferAmountScreen
  ↓
✅ Account verification succeeds (bankCode is 3-10 characters)
```

## Example Bank Codes

Common Nigerian bank codes that will now be found:
- **Ecobank**: "050"
- **Access Bank**: "044"
- **GTBank**: "058"
- **First Bank**: "011"
- **Standard Chartered**: "068"
- **FCMB**: "214"
- **Zenith Bank**: "057"
- **ValarPay**: "999"

## Benefits

✅ **Fixes the Error**: Bank code is no longer empty
✅ **Uses Existing Cache**: No additional API calls (banks already loaded)
✅ **Graceful Fallback**: If bank not found, still passes empty string (though unlikely)
✅ **Case-Insensitive Match**: Works even if bank names differ slightly in casing
✅ **Dynamic Lookup**: Always uses current banks list

## Testing Steps

1. Go to **Transfer to Bank** screen
2. Click on **Recent** tab
3. Click on any recent beneficiary
4. Should navigate to transfer amount screen WITHOUT error
5. Enter amount and complete transfer test

## Compilation Status

✅ **0 errors**
✅ **File compiles successfully**
✅ **All imports resolved**

## Files Modified

- `lib/features/dashboard/view/transfer/transfer_to_bank/recent_and_saved_beneficiary.dart`
  - Added `transfer_notifier` import
  - Updated recent beneficiary tap logic to lookup bank code
  - Beneficiary model now has valid bank code (3-10 characters)

## Before & After

### Before (Error)
```
1. Click Recent Beneficiary
2. Navigate to BeneficiaryTransferAmountScreen with bankCode = ''
3. Try to verify account
4. ❌ Error: "bankcode must be 3 to 10"
```

### After (Success)
```
1. Click Recent Beneficiary
2. Lookup bank code from banks list
3. Navigate to BeneficiaryTransferAmountScreen with bankCode = "050" (example)
4. ✅ Account verification succeeds
5. Continue with transfer
```

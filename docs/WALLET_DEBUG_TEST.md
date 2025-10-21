# Wallet Debug Test - User: Rabiu Aliyu

## User Info
- **Email**: net.rabiualiyu@gmail.com
- **Username**: rabalgaro
- **Phone**: 08064160204
- **Full Name**: Rabiu Aliyu
- **BVN Verified**: ✅ YES (`isBvnVerified: true`)
- **Wallet PIN Set**: ❌ NO (`isWalletPinSet: false`)
- **Date of Birth**: 4-Feb-1992
- **Tier Level**: one

## Testing Steps

### 1. Run the App and Login
```bash
flutter run
```

### 2. Look for Console Logs

After login/refresh, you should see:

```
[UserNotifier] Fetching user profile...
[UserNotifier] User profile fetched successfully
[UserNotifier] isPasscodeSet: false
[UserNotifier] isBvnVerified: true
[UserNotifier] 🏦 Wallet Count: X
```

### 3. Check Wallet Status

**If wallet exists** (Wallet Count: 1):
```
[UserNotifier] 💰 Balance: ₦0.00
[UserNotifier] 🔢 Account Number: 1234567890
```
✅ **Result**: Backend created wallet automatically, app should display it

**If no wallet** (Wallet Count: 0):
```
[UserNotifier] ⚠️ No wallet found for user!
```
❌ **Result**: Need to implement virtual account creation

### 4. Check Full Response

Look for the complete API response:
```
[API RESPONSE] => 200 {..., wallet: [...]}
```

## Expected Outcomes

### Outcome A: Wallet Exists
If backend returns:
```json
{
  "wallet": [
    {
      "id": "...",
      "accountNumber": "1234567890",
      "balance": 0.0,
      "bankName": "ValarPay Bank",
      "accountName": "Rabiu Aliyu"
    }
  ]
}
```

**Action**: None needed! App will display wallet data on dashboard.

### Outcome B: Empty Wallet Array
If backend returns:
```json
{
  "wallet": []
}
```

**Action**: Implement virtual account creation:
1. Call `POST /api/v1/wallet/create-virtual-account`
2. Pass BVN + DOB (`4-Feb-1992`)
3. Refresh user profile

### Outcome C: No Wallet Field
If backend returns no `wallet` field at all:
```json
{
  // ... user fields, but no wallet
}
```

**Action**: Contact backend team - field should always be present.

## Previous Test Comparison

### User: Tosin Olowu (Previous Test)
```json
{
  "isBvnVerified": false,
  "isWalletPinSet": true,
  "wallet": []  // ✅ Field exists, empty
}
```
- No BVN verification
- Empty wallet array ✅

### User: Rabiu Aliyu (Current Test)
```json
{
  "isBvnVerified": true,
  "isWalletPinSet": false,
  "wallet": ???  // Need to verify
}
```
- BVN verified ✅
- Wallet status unknown (need full response)

## Debug Checklist

- [ ] Run app and login with Rabiu's account
- [ ] Check console for wallet count log
- [ ] Verify if wallet array is empty or has data
- [ ] Check full API response for wallet field
- [ ] Test dashboard balance display
- [ ] Navigate to "Add Money" → Bank Transfer
- [ ] Check if account number shows or "Not Available"

## Next Steps Based on Results

### If Wallet Count = 1:
✅ Backend is working correctly
- Dashboard should show balance
- Add Money should show account number
- No action needed

### If Wallet Count = 0:
❌ Need to create virtual account
- Implement POST `/api/v1/wallet/create-virtual-account`
- Call after BVN verification
- Or add manual button in settings

### If Response Missing Wallet Field:
🐛 Backend issue
- Contact backend team
- Should always return wallet field (even if empty)

## Related Files
- `lib/features/notifiers/user_notifier.dart` - Added wallet logging
- `lib/features/models/user.dart` - Wallet parsing
- `lib/features/models/wallet.dart` - Wallet model
- `docs/VIRTUAL_ACCOUNT_CREATION_STRATEGY.md` - Implementation guide
- `docs/WALLET_DATA_IMPLEMENTATION.md` - Complete wallet flow

## Expected Console Output

```
I/flutter (12345): [UserNotifier] Fetching user profile...
I/flutter (12345): [API REQUEST] => GET /api/v1/user/me
I/flutter (12345): [API RESPONSE] => 200 {id: e3c7643a..., wallet: [...]}
I/flutter (12345): [UserNotifier] User profile fetched successfully
I/flutter (12345): [UserNotifier] isPasscodeSet: false
I/flutter (12345): [UserNotifier] isBvnVerified: true
I/flutter (12345): [UserNotifier] 🏦 Wallet Count: ?
I/flutter (12345): [UserNotifier] 💰 Balance: ? OR ⚠️ No wallet found!
```

The `?` will be filled with actual data when you run the test.

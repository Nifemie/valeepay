# Airtime Screen Implementation Pattern - Complete Guide

## Overview
The airtime screen demonstrates the complete flow for a service payment screen with API integration, state management, error handling, and user feedback. This pattern should be replicated across all service screens (electricity, cable, data, giftcard, etc.).

---

## 1. IMPORTS & SETUP

### Required Imports
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/features/notifiers/[service]_notifier.dart';
import 'package:valarpay/features/providers/[service]_providers.dart';
import 'package:valarpay/features/providers/user_provider.dart';
```

### Screen Type
```dart
class [Service]Screen extends ConsumerStatefulWidget {
  const [Service]Screen({super.key});
  
  @override
  ConsumerState<[Service]Screen> createState() => _[Service]ScreenState();
}
```

---

## 2. STATE VARIABLES

### Essential Variables
```dart
class _[Service]ScreenState extends ConsumerState<[Service]Screen> {
  // Input Controllers
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  
  // UI State
  bool _saveBeneficiary = false;
  bool _loadingShown = false;
  
  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
```

---

## 3. HELPER METHODS

### 3.1 Loading State Management
```dart
void _showLoading() {
  if (_loadingShown) return; // Prevent duplicate dialogs
  _loadingShown = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
}

void _hideLoading() {
  if (!_loadingShown) return; // Prevent error if not shown
  _loadingShown = false;
  
  if (mounted && Navigator.canPop(context)) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
```

### 3.2 Form Validation
```dart
bool _isFormValid(String network, int operatorId) =>
    _phoneController.text.isNotEmpty &&
    _amountController.text.isNotEmpty &&
    network.isNotEmpty &&
    operatorId > 0;
```

---

## 4. THE PIN ENTRY FLOW (CRITICAL PATTERN)

### Complete _handlePin Method
```dart
Future<void> _handlePin({bool biometric = false}) async {
  // STEP 1: Check Balance
  final user = ref.read(userProvider);
  final hasEnough = checkBalanceLeft(
    context,
    user?.wallets.first.balance.toString() ?? '0',
    _amountController.text.replaceAll(',', ''),
  );
  if (!hasEnough) return; // Balance check failed, user already notified
  
  // STEP 2: Get PIN from User
  final pin = biometric
      ? await BiometricTransactionPinModal.show(context)
      : await TransactionPinModal.show(context);
  
  // STEP 3: Validate PIN Input
  if (pin == null || pin.length != 4 || !mounted) return;
  
  // STEP 4: Get Dependent Data
  final operatorId = ref.read(airtimeSelectedOperatorIdProvider);
  
  // STEP 5: Show Loading
  _showLoading();
  
  try {
    // STEP 6: Build Request
    final request = AirtimePurchaseRequest(
      walletPin: pin,
      amount: Helpers.parsedAmount(_amountController.text),
      operatorId: operatorId,
      phone: _phoneController.text.trim(),
      currency: 'NGN',
      addBeneficiary: _saveBeneficiary,
    );
    
    // STEP 7: Call API via Notifier
    await ref
        .read(airtimePurchaseNotifierProvider.notifier)
        .purchase(request);
    
    // STEP 8: Hide Loading
    _hideLoading();
    
    if (!mounted) return;
    
    // STEP 9: READ State After API Call
    final state = ref.read(airtimePurchaseNotifierProvider);
    
    // STEP 10: Check if Data is Available
    if (state.isDataAvailable) {
      // SUCCESS: Navigate to receipt
      _navigateToReceipt();
    } else {
      // ERROR: Show Error Message
      final errorMessage = state.message ?? 'Transaction failed. Please try again.';
      
      // Check for Specific Error Patterns
      final isIncorrectPin = errorMessage.toLowerCase().contains('incorrect pin') ||
          errorMessage.toLowerCase().contains('wrong pin') ||
          errorMessage.toLowerCase().contains('invalid pin') ||
          errorMessage.toLowerCase().contains('pin is incorrect');
      
      AppMessenger.show(
        context,
        message: isIncorrectPin ? 'Incorrect PIN. Please try again.' : errorMessage,
        type: MessageType.error,
      );
    }
  } catch (e) {
    // STEP 11: Handle Exceptions
    _hideLoading();
    
    if (!mounted) return;
    
    final errorMessage = e.toString();
    final isIncorrectPin = errorMessage.toLowerCase().contains('incorrect pin') ||
        errorMessage.toLowerCase().contains('wrong pin') ||
        errorMessage.toLowerCase().contains('invalid pin') ||
        errorMessage.toLowerCase().contains('pin is incorrect');
    
    AppMessenger.show(
      context,
      message: isIncorrectPin
          ? 'Incorrect PIN. Please try again.'
          : 'An unexpected error occurred: $errorMessage',
      type: MessageType.error,
    );
  }
}
```

### Key Points in _handlePin:
1. ✅ **Balance Check First** - Prevents wasting API calls
2. ✅ **PIN Validation** - Check for null, length, mounted
3. ✅ **Show Loading** - Block user from multiple submissions
4. ✅ **Request Building** - Gather all needed data
5. ✅ **API Call** - Via notifier.method(request)
6. ✅ **Hide Loading** - Always before state check
7. ✅ **Read State After API** - Check `isDataAvailable`
8. ✅ **Success Logic** - Navigate on success
9. ✅ **Error Pattern Matching** - Check for specific errors (PIN, balance, etc.)
10. ✅ **User Feedback** - AppMessenger with appropriate message

---

## 5. NAVIGATION METHODS

### 5.1 Receipt Navigation
```dart
void _navigateToReceipt() {
  final selectedNetwork = ref.read(airtimeSelectedNetworkProvider);
  final now = DateTime.now();
  
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TransactionReceiptWidget(
        headerText: 'Transaction',
        amount: currencyFormatter(
          _amountController.text.replaceAll(',', ''),
        ),
        topDetails: [
          TransactionDetail(
            label: 'Transaction ID',
            value: 'TXN${now.millisecondsSinceEpoch}',
            showCopyIcon: true,
          ),
          TransactionDetail(
            label: 'Recipient Number',
            value: _phoneController.text,
          ),
          TransactionDetail(
            label: 'Network',
            value: selectedNetwork.toUpperCase(),
          ),
          TransactionDetail(
            label: 'Amount',
            value: currencyFormatter(
              _amountController.text.replaceAll(',', ''),
            ),
          ),
        ],
        onShareReceipt: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReceiptShareScreen(
                date: '${now.day} ${Helpers.getMonthName(now.month)} ${now.year} | ${DateFormat.jm().format(now)}',
                transactionDetailList: [
                  // Share details
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
```

### 5.2 Transaction Details Navigation
```dart
void _navigateToDetails(String network, int operatorId) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ReuseableTransactionDetailsScreen(
        hasBottom: false,
        saveBeneficiary: _saveBeneficiary,
        onSaveBeneficiaryChanged: (v) => setState(() => _saveBeneficiary = v),
        topTitleText: 'Transaction',
        topTransactionsDetailsList: [
          buildDetailRow('Recipient Number', _phoneController.text, isDark),
          buildDetailRow('Provider', network, isDark),
          buildDetailRow(
            'Amount',
            currencyFormatter(_amountController.text.replaceAll(',', '')),
            isDark,
          ),
        ],
        onButtonPressed: () => _handlePin(biometric: false),
        onBiometricButtonPressed: () => _handlePin(biometric: true),
      ),
    ),
  );
}
```

---

## 6. BUILD METHOD PATTERN

### Structure in build()
```dart
@override
Widget build(BuildContext context) {
  // STEP 1: Watch User State
  final user = ref.watch(userProvider);
  final isVerified = user?.isBvnVerified ?? false;
  
  // STEP 2: Watch UI Provider States
  final network = ref.watch(airtimeSelectedNetworkProvider);
  final operatorId = ref.watch(airtimeSelectedOperatorIdProvider);
  
  // STEP 3: Watch API Response States
  final planState = ref.watch(airtimePlanNotifierProvider);
  final plan = planState.data?.isNotEmpty == true ? planState.data!.first : null;
  
  return Scaffold(
    appBar: AppBar(
      title: const Text('Airtime'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: !isVerified
        ? const KycNotSetWidget(
          title: 'KYC Not Completed',
          subtitle: 'Complete your KYC to purchase airtime.',
        )
        : SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Phone Input Field
                ReuseableTextFieldWithCountry(
                  controller: _phoneController,
                  countryCode: '+234 ',
                  hintText: '812 345 6789',
                  textInputType: TextInputType.phone,
                  suffixWidget: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: appTheme.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    onPressed: _pickContact,
                  ),
                  onChanged: (v) {
                    setState(() {});
                    // AUTO-DETECT: Fetch plan when 10+ digits
                    if (v.replaceAll(RegExp(r'\D'), '').length >= 10) {
                      ref
                          .read(airtimePlanNotifierProvider.notifier)
                          .getPlan(phone: v, currency: 'NGN')
                          .then((_) {
                            // Update providers after API response
                            final s = ref.read(airtimePlanNotifierProvider);
                            if (s.isDataAvailable && s.data!.isNotEmpty) {
                              final p = s.data!.first;
                              ref.read(airtimeSelectedNetworkProvider.notifier).state = p.name;
                              ref.read(airtimeSelectedOperatorIdProvider.notifier).state = p.operatorId;
                            }
                          });
                    }
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Provider Display
                const Text('Network Provider', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: planState.isInitialLoading
                      ? const Center(child: CircularProgressIndicator())
                      : plan == null
                      ? const Text(
                        'Enter phone number to automatically detect network provider',
                        style: TextStyle(color: Colors.orange),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            plan.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.check_circle, color: appTheme.primaryColor),
                        ],
                      ),
                ),
                
                const SizedBox(height: 24),
                
                // Amount Input
                const Text('Amount', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                ReuseableAmountTextfield(
                  amountController: _amountController,
                  prefixText: '₦',
                  hintText: '500',
                  onChanged: (_) => setState(() {}),
                ),
                
                const SizedBox(height: 30),
                
                // Continue Button
                FullWidthButton(
                  text: 'Continue',
                  isEnabled: _isFormValid(network, operatorId),
                  onPressed: () => _navigateToDetails(network, operatorId),
                ),
              ],
            ),
          ),
        ),
  );
}
```

---

## 7. RIVERPOD INTEGRATION

### Provider Setup
```dart
// airtime_providers.dart
final airtimeSelectedNetworkProvider = StateProvider<String>((ref) => '');
final airtimeSelectedOperatorIdProvider = StateProvider<int>((ref) => 0);

// airtime_notifier.dart
class AirtimeNotifier extends StateNotifier<DataState<AirtimePlan>> {
  Future<void> getPlan({required String phone, required String currency}) async {
    state = state.copyWith(isInitialLoading: true);
    try {
      final response = await _repository.getPlan(phone: phone, currency: currency);
      state = state.copyWith(
        isInitialLoading: false,
        data: response.plans,
        isDataAvailable: true,
        message: response.message,
      );
    } catch (e, stack) {
      log('[AirtimeNotifier] Error: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }
  
  Future<void> purchase(AirtimePurchaseRequest request) async {
    state = state.copyWith(isInitialLoading: true);
    try {
      await _repository.purchase(request);
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: 'Purchase successful',
      );
    } catch (e, stack) {
      log('[AirtimeNotifier] Purchase Error: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }
}
```

---

## 8. KEY PATTERNS TO REPLICATE

### Pattern 1: Auto-Detection on Input
```dart
onChanged: (v) {
  setState(() {}); // Trigger rebuild
  if (v.replaceAll(RegExp(r'\D'), '').length >= 10) {
    ref.read(notifier.notifier)
        .method(params)
        .then((_) {
          // Update UI providers after response
          final state = ref.read(notifier);
          if (state.isDataAvailable && state.data!.isNotEmpty) {
            // Extract data and update providers
          }
        });
  }
}
```

### Pattern 2: State Check with .then()
```dart
// After calling an async method, use .then() to check result
ref.read(notifierProvider.notifier)
    .asyncMethod(request)
    .then((_) {
      final state = ref.read(notifierProvider);
      
      if (state.isDataAvailable) {
        // SUCCESS
      } else {
        // ERROR - Use state.message for error message
      }
    });
```

### Pattern 3: Error Pattern Matching
```dart
final errorMessage = state.message ?? 'Default error';
final isIncorrectPin = errorMessage.toLowerCase().contains('incorrect pin') ||
    errorMessage.toLowerCase().contains('wrong pin') ||
    errorMessage.toLowerCase().contains('invalid pin');

if (isIncorrectPin) {
  AppMessenger.show(context, message: 'Incorrect PIN. Please try again.', type: MessageType.error);
} else {
  AppMessenger.show(context, message: errorMessage, type: MessageType.error);
}
```

### Pattern 4: Loading State Protection
```dart
void _showLoading() {
  if (_loadingShown) return; // Prevent duplicate
  _loadingShown = true;
  // Show dialog
}

void _hideLoading() {
  if (!_loadingShown) return; // Prevent error if not shown
  _loadingShown = false;
  if (mounted && Navigator.canPop(context)) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
```

---

## 9. CHECKLIST FOR OTHER SCREENS

When implementing electricity, cable, data, or other service screens:

- [ ] Import necessary widgets and providers
- [ ] Create StateVariables (controllers, flags)
- [ ] Implement _showLoading() and _hideLoading()
- [ ] Implement _isFormValid() with all required fields
- [ ] Implement _handlePin() with:
  - [ ] Balance check
  - [ ] PIN input validation
  - [ ] Loading show/hide
  - [ ] API call via notifier
  - [ ] State check (isDataAvailable)
  - [ ] Success navigation
  - [ ] Error handling with pattern matching
- [ ] Implement _navigateToReceipt()
- [ ] Implement _navigateToDetails()
- [ ] Watch providers in build()
- [ ] Handle KYC verification check
- [ ] Display appropriate loading/error states
- [ ] Auto-detect providers/plans if applicable
- [ ] Format amounts with currency formatter

---

## 10. COMMON ISSUES & SOLUTIONS

### Issue: Blank screen after transaction
**Solution**: Make sure to call `_hideLoading()` before checking state

### Issue: Form button not enabling
**Solution**: Check `_isFormValid()` - all fields must be filled AND network/operator ID must be > 0

### Issue: Provider not updating
**Solution**: After API response, manually update providers:
```dart
ref.read(selectedNetworkProvider.notifier).state = newValue;
```

### Issue: Multiple loading dialogs
**Solution**: Use `_loadingShown` flag to prevent duplicates

### Issue: Black screen on error
**Solution**: Always use `AppMessenger.show()` for user feedback, never swallow errors silently


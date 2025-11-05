# Airtime vs Data Screen - Implementation Comparison

## CRITICAL DIFFERENCE

The **Data Screen** and **Airtime Screen** follow DIFFERENT patterns, especially in the build method and state management.

---

## 1. BUILD METHOD APPROACH

### ✅ Airtime Screen (RECOMMENDED - CLEANER)
```dart
@override
Widget build(BuildContext context) {
  final user = ref.watch(userProvider);
  final network = ref.watch(airtimeSelectedNetworkProvider);
  final operatorId = ref.watch(airtimeSelectedOperatorIdProvider);
  final planState = ref.watch(airtimePlanNotifierProvider);
  final plan = planState.data?.isNotEmpty == true ? planState.data!.first : null;
  
  // Use watched state directly in build
  // UI rebuilds when providers change
}
```

**Key**: 
- Uses `ref.watch()` - automatically rebuilds when state changes
- Simple, reactive pattern
- Good for UI that depends on notifier state

---

### ❌ Data Screen (OLD - MORE COMPLEX)
```dart
@override
Widget build(BuildContext context) {
  final user = ref.watch(userProvider);
  final plansState = ref.watch(dataPlansNotifierProvider);
  final availablePlans = plansState.data ?? <DataPlanInfo>[];
  
  // Uses ref.listen() multiple times inside build
  ref.listen<DataState<DataPlanInfo>>(dataPlansNotifierProvider, (prev, next) {
    if (next.message != null && !next.isInitialLoading && !next.isDataAvailable) {
      AppMessenger.show(context, message: next.message!, type: MessageType.error);
    }
  });
  
  // Multiple listeners for different providers
  ref.listen<DataState<DataPlan>>(dataVariationNotifierProvider, (prev, next) {
    if (!next.isInitialLoading && next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
      setState(() {
        amountController.text = next.data!.first.fixedAmounts.first.toStringAsFixed(0);
      });
    }
  });
  
  // More listeners for purchase results...
}
```

**Issues**:
- Uses `ref.listen()` inside build method (called every rebuild)
- Multiple listeners scattered in build()
- Mixes imperative (setState, AppMessenger) with declarative UI
- Harder to follow logic
- More prone to bugs

---

## 2. LOCAL STATE MANAGEMENT

### ✅ Airtime Screen
```dart
class _AirtimeScreenState extends ConsumerStatefulWidget {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  bool _saveBeneficiary = false;
  bool _loadingShown = false; // Track loading state
  
  // Stores local UI state only
  // Providers store selected values
}
```

**Pattern**: 
- Local state = UI state (loading, beneficiary, controllers)
- Providers = Data state (selected network, operator ID)
- Clean separation

---

### ❌ Data Screen
```dart
class _DataScreenState extends ConsumerStatefulWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController amountController = TextEditingController(text: '0');
  bool _useCashback = false;
  String _selectedNetwork = '';
  int _selectedOperatorId = 0;
  String _selectedPlan = '';
  bool saveBeneficiary = false;
  
  // Stores BOTH UI state AND data
  // Doesn't use providers for selections
}
```

**Issues**:
- Stores selected values in local state instead of providers
- Makes it harder to access selections in different methods
- Duplicate state (local vs provider)

---

## 3. AUTO-DETECTION PATTERN

### ✅ Airtime Screen (IN TEXTFIELD onChanged)
```dart
onChanged: (v) {
  setState(() {}); // Trigger rebuild
  if (v.replaceAll(RegExp(r'\D'), '').length >= 10) {
    ref
        .read(airtimePlanNotifierProvider.notifier)
        .getPlan(phone: v, currency: 'NGN')
        .then((_) {
          // After API response, update providers
          final s = ref.read(airtimePlanNotifierProvider);
          if (s.isDataAvailable && s.data!.isNotEmpty) {
            final p = s.data!.first;
            ref.read(airtimeSelectedNetworkProvider.notifier).state = p.name;
            ref.read(airtimeSelectedOperatorIdProvider.notifier).state = p.operatorId;
          }
        });
  }
}
```

**Clean**:
- Updates providers after API response
- Auto-fetch triggered by user input
- Providers always have latest data

---

### ❌ Data Screen (STILL REFRESHES)
```dart
onChanged: (value) {
  // Auto-fetch plans when phone number is complete (10 digits)
  if (value.length >= 10) {
    ref
        .read(dataPlansNotifierProvider.notifier)
        .getPlans(phone: value, currency: 'NGN');
  }
}
```

**Problem**: 
- Doesn't store result in local state
- Providers update but local _selectedNetwork isn't updated
- Have to read from provider every time, not reactive

---

## 4. PIN ENTRY FLOW COMPARISON

### ✅ Airtime (RECOMMENDED)
```dart
Future<void> _handlePin({bool biometric = false}) async {
  // 1. Check balance
  final hasEnough = checkBalanceLeft(...);
  if (!hasEnough) return;
  
  // 2. Get PIN
  final pin = biometric ? ... : ...;
  if (pin == null || pin.length != 4 || !mounted) return;
  
  // 3. Show loading
  _showLoading(); // Uses flag to prevent duplicates
  
  try {
    // 4. Call API
    await ref.read(airtimePurchaseNotifierProvider.notifier).purchase(request);
    
    // 5. Hide loading
    _hideLoading();
    
    if (!mounted) return;
    
    // 6. Check state
    final state = ref.read(airtimePurchaseNotifierProvider);
    
    if (state.isDataAvailable) {
      // SUCCESS
      _navigateToReceipt();
    } else {
      // ERROR
      final errorMessage = state.message ?? 'Failed';
      final isIncorrectPin = errorMessage.toLowerCase().contains('incorrect pin');
      AppMessenger.show(context, message: ..., type: MessageType.error);
    }
  } catch (e) {
    _hideLoading();
    AppMessenger.show(context, message: ..., type: MessageType.error);
  }
}
```

**Advantages**:
- Simple, linear flow
- Clear success/error handling
- Easy to follow
- Minimal state checks

---

### ❌ Data (COMPLEX)
```dart
Future<void> _handlePinEntry() async {
  // ... same setup ...
  
  try {
    await ref.read(dataPurchaseNotifierProvider.notifier).purchase(request);
    
    // Uses postFrameCallback (complex!)
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Multiple checks in callback
        if (!mounted) return;
        
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        
        // Delayed check!
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          
          // Check state after delay
          final state = ref.read(dataPurchaseNotifierProvider);
          
          // Complex conditions
          final isSuccessMessage = 
              state.message != null &&
              state.message!.toLowerCase().contains('success');
          
          if ((state.isDataAvailable && state.data != null && state.data!.isNotEmpty) ||
              isSuccessMessage) {
            // Navigate
          } else if (state.message != null) {
            // Error
          }
        });
      });
    }
  } catch (e) {
    if (mounted) Navigator.pop(context);
    if (mounted) AppMessenger.show(...);
  }
}
```

**Problems**:
- Uses `WidgetsBinding.instance.addPostFrameCallback()` (unnecessary complexity)
- Adds `Future.delayed()` to wait for loading dialog to close
- Multiple nested callbacks
- Hard to debug
- Fragile timing dependencies

---

## 5. KEY DIFFERENCES SUMMARY

| Aspect | Airtime (✅) | Data (❌) |
|--------|-------------|----------|
| **build() listeners** | No `ref.listen()` | Multiple `ref.listen()` in build |
| **Loading state** | Boolean flag `_loadingShown` | Direct `showDialog()` |
| **State selection storage** | Providers | Local state variables |
| **Auto-detect update** | Updates providers explicitly | Doesn't update local state |
| **PIN flow** | Direct try-catch | postFrameCallback + delayed checks |
| **Error matching** | Simple pattern match | Complex nested conditions |
| **State check timing** | Immediate after API | Delayed via callbacks |
| **Code complexity** | 200 lines | 1100+ lines |
| **Maintainability** | High | Low |

---

## 6. WHAT NEEDS TO BE FIXED

### In Data Screen:
1. **Remove `ref.listen()` from build()** - Move to separate method or use providers reactively
2. **Use `_loadingShown` flag** instead of direct `showDialog()`
3. **Store selections in providers** not local state
4. **Simplify PIN entry** - Remove `postFrameCallback` and `Future.delayed()`
5. **Follow airtime pattern exactly** for PIN handling

### Migration Path:
```dart
// BEFORE (Data pattern - complex)
ref.listen<DataState<DataPlan>>(dataVariationNotifierProvider, (prev, next) {
  if (!next.isInitialLoading && next.isDataAvailable && next.data != null && next.data!.isNotEmpty) {
    setState(() {
      amountController.text = next.data!.first.fixedAmounts.first.toStringAsFixed(0);
    });
  }
});

// AFTER (Airtime pattern - simple)
final variationState = ref.watch(dataVariationNotifierProvider);
if (!variationState.isInitialLoading && variationState.isDataAvailable && variationState.data!.isNotEmpty) {
  // Directly use in build or trigger side effect
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (amountController.text == '0' && variationState.data!.isNotEmpty) {
      setState(() {
        amountController.text = variationState.data!.first.fixedAmounts.first.toStringAsFixed(0);
      });
    }
  });
}
```

---

## 7. WHICH PATTERN TO USE

### ✅ USE AIRTIME PATTERN FOR:
- New screens (electricity, cable, giftcard)
- Any service payment screen
- Simple, maintainable code
- React ive UI updates

### ❌ AVOID DATA PATTERN:
- Too complex for maintenance
- Harder to debug
- Uses `postFrameCallback` unnecessarily
- Multiple listeners in build()

---

## CONCLUSION

**The Airtime Screen is the correct implementation pattern to follow.**

Data screen works but uses outdated patterns that make it harder to maintain and debug. Eventually, the data screen should be refactored to match the airtime pattern.

The key principle: **WATCHERS IN BUILD, LISTENERS IN METHODS, IMPERATIVE CODE OUTSIDE BUILD()**


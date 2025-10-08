# Shopping Service Widgets

This folder contains all the widgets and screens related to shopping payment functionality.

## Screens

### 1. ShoppingScreen
Main screen for shopping services with:
- List of shopping platforms (Jumia, Amazon, Aliexpress, etc.)
- Navigation to saved beneficiaries
- Shopping bag icons for each provider

### 2. ShoppingSavedBeneficiaryScreen
Displays saved shopping beneficiaries with:
- List of saved order IDs and providers
- Edit/Delete options for each beneficiary
- Empty state when no beneficiaries exist

### 3. ShoppingProviderPaymentScreen
Provider-specific shopping payment form with:
- Order ID input field
- Transaction type selection
- Amount input with provider hint
- Multiple action buttons (Pay Shopping, Continue)

### 4. ShoppingTransactionDetailsScreen
Transaction summary before payment with:
- Transaction details review
- Payment method selection
- Confirmation button

### 5. ShoppingTransactionSuccessScreen
Success screen after payment completion with:
- Success animation
- Transaction amount
- Transaction details
- Share receipt option

## Modal Widgets

### 1. ShoppingServiceOptionModal
Bottom sheet for selecting transaction type:
- Options 1-6 available
- Radio button selection
- Star rating for selected option

### 2. ShoppingPaymentMethodModal
Bottom sheet for payment method selection:
- List of available banks/payment methods
- Star rating for preferred methods
- PIN entry integration

### 3. ShoppingPinEntryModal
PIN entry screen with:
- 4-digit PIN input
- Number pad interface
- Visual PIN dots
- Delete functionality
- Auto-navigation to success screen

## Usage Example

```dart
// Navigate to shopping services
ShoppingNavigationHelper.navigateToShopping(context);

// Navigate to specific provider
ShoppingNavigationHelper.navigateToProviderPayment(
  context,
  'Jumia.com.ng',
);

// Show service option modal
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => ShoppingServiceOptionModal(
    selectedOption: selectedTransactionType,
    onOptionSelected: (option) {
      setState(() {
        selectedTransactionType = option;
      });
    },
  ),
);
```

## Features Implemented

✅ Dark/Light theme support
✅ Responsive design
✅ Transaction type selection
✅ Multiple action buttons
✅ Form validation
✅ Navigation flow
✅ Payment integration
✅ Transaction success handling
✅ Saved beneficiaries management

## Shopping Payment Flow

1. **Provider Selection** - Choose shopping platform from list
2. **Payment Details** - Enter order ID, transaction type, amount
3. **Transaction Review** - Confirm details and payment method
4. **Payment** - Enter PIN for secure transaction
5. **Success** - Confirmation and receipt sharing

## Supported Shopping Platforms

- **Jumia.com.ng**
- **Amazon.com**
- **Aliexpress.com**
- **Shein.com**
- **Ebay.com**

## Transaction Types

- Option 1
- Option 2
- Option 3
- Option 4
- Option 5
- Option 6

## Color Scheme

- Primary Orange: `#F76301`
- Dark Background: `#000000`
- Card Background (Dark): `#2B2725`
- Light Background: `#FFFFFF`
- Card Background (Light): `Colors.grey[100]`

## Data Models

### Transaction Data
```dart
Map<String, String> transactionData = {
  'provider': 'Jumia.com.ng',
  'orderId': '0000000000000',
  'transactionType': 'Option 1',
  'amount': '500000',
};
```

### Beneficiary Data
```dart
Map<String, String> beneficiary = {
  'orderId': '0000000000',
  'provider': 'Jumia.com',
  'transactionType': 'Option 1',
};
```

## Special Features

- **Shopping Bag Icons**: Shopping-themed icons throughout the interface
- **Multiple Action Buttons**: Both "Pay Shopping" and "Continue" buttons
- **Order ID Validation**: Proper formatting and validation for order IDs
- **Provider Branding**: Consistent styling for shopping platforms
- **Amount Hints**: Provider-specific amount hints (₦ From Jumia)
# Settings Feature

This folder contains all the settings screens and functionality for the ValarPay app.

## Files

- `settings.dart` - Main settings screen with all setting categories
- `security_settings_screen.dart` - Security questions setup
- `login_settings_screen.dart` - Login and biometric settings
- `transaction_pin_settings_screen.dart` - Transaction PIN management
- `finance_settings_screen.dart` - Finance and savings settings
- `notification_settings_screen.dart` - Notification preferences
- `change_pin_screen.dart` - PIN change functionality

## Features

### Main Settings Screen
- **Login Settings** - Password, biometrics, auto-logout
- **Security Settings** - Security questions setup
- **Transaction PIN Settings** - PIN management and biometrics
- **Finance Settings** - Savings and investment preferences
- **Notification Settings** - Notification preferences
- **Close Account** - Account deletion with confirmation flow
- **Logout** - Secure logout functionality

### Security Settings
- **Security Questions Setup** - 3 security questions from predefined list
- **Question Selection** - Dropdown with common security questions
- **Answer Input** - Secure answer storage
- **Validation** - Ensures all questions are answered
- **Success Confirmation** - Visual feedback on completion

### Login Settings
- **Password Management** - Current password access
- **Auto Logout Settings** - Session timeout configuration
- **Biometric Authentication**:
  - Fingerprint toggle
  - Face ID toggle
  - Login with Face ID option
- **Settings Persistence** - Saves user preferences

### Transaction PIN Settings
- **PIN Management**:
  - Change PIN functionality
  - Forgot PIN recovery
- **Biometric Options**:
  - Fingerprint for transactions
  - Face ID for transactions
- **PIN Change Flow**:
  - Current PIN verification
  - New PIN entry
  - PIN confirmation
  - Success/error handling

### Finance Settings
- **Target Savings** - Enable/disable auto-save features
- **Fixed Savings** - Fixed savings wallet management
- **Fixed Deposit** - Investment options toggle
- **Wallet Preferences** - Financial service settings

### Notification Settings
- **Granular Control** - Individual notification types
- **Categories**:
  - Transactions - Payment and account activities
  - Services - Service updates and activities
  - Updates - App improvements and features
  - Messages - Direct communications
- **Toggle Interface** - Easy on/off switches

### Account Management
- **Close Account Flow**:
  1. Warning dialog with consequences
  2. Reason selection for feedback
  3. Transaction PIN verification
  4. Final confirmation
  5. Account deletion confirmation
- **Logout** - Simple logout with confirmation

## Navigation Flow

```
Settings Screen
├── Login Settings
│   ├── Password Management
│   ├── Auto Logout Settings
│   └── Biometric Settings
├── Security Settings
│   └── Security Questions Setup
├── Transaction PIN Settings
│   ├── Change PIN → Change PIN Screen
│   ├── Forgot PIN
│   └── Biometric Settings
├── Finance Settings
│   ├── Target Savings Toggle
│   ├── Fixed Savings Toggle
│   └── Fixed Deposit Toggle
├── Notification Settings
│   ├── Transactions Toggle
│   ├── Services Toggle
│   ├── Updates Toggle
│   └── Messages Toggle
├── Close Account
│   ├── Warning Dialog
│   ├── Reason Selection
│   ├── PIN Verification
│   ├── Final Confirmation
│   └── Success Dialog
└── Logout
    └── Confirmation Dialog
```

## Reusable Widgets

Located in `lib/features/dashboard/widgets/home_widgets/settings_widgets.dart`:

- `SettingsListTile` - Standard settings list item
- `SettingsToggleTile` - Settings item with toggle switch
- `SecurityQuestionDropdown` - Security question selector
- `CloseAccountDialog` - Account closure warning
- `HelpUsImproveDialog` - Feedback collection
- `TransactionPinDialog` - PIN entry interface
- `QuestionSelectionBottomSheet` - Question picker

## Usage

To navigate to settings from any screen:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const SettingsScreen(),
  ),
);
```

## Security Features

- **PIN Verification** - Required for sensitive operations
- **Biometric Integration** - Fingerprint and Face ID support
- **Security Questions** - Account recovery mechanism
- **Session Management** - Auto-logout configuration
- **Account Protection** - Multi-step account deletion

## Data Persistence

Settings are designed to persist user preferences:
- Biometric settings
- Notification preferences
- Finance settings
- Security configurations
- Auto-logout timers

## Error Handling

- PIN mismatch validation
- Network error handling
- Biometric availability checks
- Form validation
- User feedback dialogs

## Accessibility

- Screen reader support
- High contrast compatibility
- Large text support
- Touch target sizing
- Keyboard navigation
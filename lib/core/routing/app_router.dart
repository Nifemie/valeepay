import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:valarpay/features/dashboard/view/commingsoon.dart';
import 'package:valarpay/features/dashboard/view/account/account_screen.dart';
import 'package:valarpay/features/dashboard/view/account/account_setup_screen.dart';
import 'package:valarpay/features/dashboard/view/addmoney/add_money_screen.dart';
import 'package:valarpay/features/dashboard/view/addmoney/add_money_via_qrcode_screen.dart';
import 'package:valarpay/features/dashboard/view/addmoney/add_money_via_transfer_screen.dart';
import 'package:valarpay/features/dashboard/view/comming_soon.dart';
import 'package:valarpay/features/dashboard/view/transfer/select_bank_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_to_bank/transfer_to_bank.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_amount_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transaction_details_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_success_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_to_valarpay/transfer_to_valarpay_screen.dart';
import 'package:valarpay/features/dashboard/view/withdraw/withdraw_bank_branch_screen.dart';
import 'package:valarpay/features/dashboard/view/withdraw/withdraw_merchant_screen.dart';
import 'package:valarpay/features/dashboard/view/withdraw/withdraw_screen.dart';

import '../../features/auth/views/introductory/intro_wrapper.dart';
import '../../features/auth/views/onboarding/change_password.dart';
import '../../features/auth/views/onboarding/forgot_password.dart';
import '../../features/auth/views/onboarding/signin/biometric_login.dart';
import '../../features/auth/views/onboarding/signin/passcode_login.dart';
import '../../features/auth/views/onboarding/signin/signin.dart';
import '../../features/auth/views/onboarding/signin/verify_fingerprint.dart';
import '../../features/auth/views/onboarding/signup/business_details.dart';
import '../../features/auth/views/onboarding/signup/email_password.dart';
import '../../features/auth/views/onboarding/signup/personal_details.dart';
import '../../features/auth/views/onboarding/signup/phone_number.dart';
import '../../features/auth/views/onboarding/signup/signup.dart';
import '../../features/auth/views/onboarding/signup/signup_success.dart';
import '../../features/auth/views/onboarding/signup/verify_email.dart';
import '../../features/auth/views/onboarding/signup/verify_phone.dart';
import '../../features/auth/views/splashscreen/splashscreen.dart';
import '../../features/dashboard/dashboard_wrapper.dart';
import '../../features/dashboard/view/card.dart';
import '../../features/dashboard/view/home_screen.dart';
import '../../features/dashboard/view/invest.dart';
import '../../features/dashboard/view/me.dart';
import '../../features/dashboard/view/savings.dart';
import '../../features/dashboard/view/settings/settings.dart';
import '../../features/dashboard/view/settings/security_settings_screen.dart';
import '../../features/dashboard/view/settings/login_settings_screen.dart';
import '../../features/dashboard/view/settings/transaction_pin_settings_screen.dart';
import '../../features/dashboard/view/settings/notification_settings_screen.dart';
import '../../features/dashboard/view/settings/finance_settings_screen.dart';
import '../../features/dashboard/view/settings/change_pin_screen.dart';
import '../../features/dashboard/view/settings/auto_logout_settings_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Auth routes (without dashboard wrapper)
    GoRoute(
      path: '/splash',
      builder: (context, state) =>
          SplashScreen(onAnimationComplete: () => context.push('/intro')),
    ),
    GoRoute(path: '/intro', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/personal-details',
      builder: (context, state) => const PersonalDetailsScreen(),
    ),
    GoRoute(
      path: '/business-details',
      builder: (context, state) => const BusinessDetailsScreen(),
    ),
    GoRoute(
      path: '/email-password',
      builder: (context, state) => const EmailPasswordScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: '/phone-number',
      builder: (context, state) => const PhoneNumberScreen(),
    ),
    GoRoute(
      path: '/verify-phone',
      builder: (context, state) => const VerifyPhoneScreen(),
    ),
    GoRoute(
      path: '/signup-success',
      builder: (context, state) =>
          SignupSuccessScreen(firstName: state.extra as String? ?? 'User'),
    ),
    GoRoute(
      path: '/signin',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SignInScreen()),
    ),
    GoRoute(
      path: '/biometric-login',
      builder: (context, state) => const BiometricLoginScreen(),
    ),
    GoRoute(
      path: '/verify-fingerprint',
      builder: (context, state) => const VerifyFingerprintScreen(),
    ),
    GoRoute(
      path: '/passcode-login',
      builder: (context, state) => const PasscodeLoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    // Dashboard shell route with bottom navigation
    ShellRoute(
      builder: (context, state, child) => DashboardWrapper(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Homescreen(
            firstName: 'John',
            profileImageUrl:
                'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
            balance: '1000',
          ),
        ),
        GoRoute(
          path: '/finance',
          builder: (context, state) => const SavingsComingSoonScreen(),
        ),
        GoRoute(
          path: '/invest',
          builder: (context, state) => const InvestmentsComingSoonScreen(),
        ),
        GoRoute(
          path: '/cards',
          builder: (context, state) => const CardScreen(),
        ),
        GoRoute(
          path: '/me',
          builder: (context, state) => const MeScreen(),
        ),
      ],
    ),

    // Standalone routes (without dashboard wrapper)
    GoRoute(
      path: '/coming-soon',
      builder: (context, state) => const ComingSoonScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/notification-settings',
      builder: (context, state) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/customer-service',
      builder: (context, state) => const CustomerServiceScreen(),
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const FAQScreen(),
    ),
    GoRoute(
      path: '/visit-office',
      builder: (context, state) => const VisitOfficeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/security-settings',
      builder: (context, state) => const SecuritySettingsScreen(),
    ),
    GoRoute(
      path: '/login-settings',
      builder: (context, state) => const LoginSettingsScreen(),
    ),
    GoRoute(
      path: '/transaction-pin-settings',
      builder: (context, state) => const TransactionPinSettingsScreen(),
    ),
    GoRoute(
      path: '/finance-settings',
      builder: (context, state) => const FinanceSettingsScreen(),
    ),
    GoRoute(
      path: '/change-pin',
      builder: (context, state) => const ChangePinScreen(),
    ),
    GoRoute(
      path: '/auto-logout-settings',
      builder: (context, state) => const AutoLogoutSettingsScreen(),
    ),
    GoRoute(
      path: '/transfer-to-valarpay',
      builder: (context, state) => const TransferToValarPayScreen(),
    ),
    GoRoute(
      path: '/transfer-amount',
      builder: (context, state) => const TransferAmountScreen(),
    ),
    GoRoute(
      path: '/transaction-details',
      builder: (context, state) => const TransactionDetailsScreen(),
    ),
    GoRoute(
      path: '/transfer-success',
      builder: (context, state) => const TransferSuccessScreen(),
    ),
    GoRoute(
      path: '/transfer-to-bank',
      builder: (context, state) => const TransferToBankScreen(),
    ),
    GoRoute(
      path: '/select-bank',
      builder: (context, state) => const SelectBankScreen(),
    ),
    GoRoute(
      path: '/withdraw',
      builder: (context, state) => const WithdrawScreen(),
    ),
    GoRoute(
      path: '/withdraw-via-bank',
      builder: (context, state) => const WithdrawBankBranchScreen(),
    ),
    GoRoute(
      path: '/withdraw-via-marchant',
      builder: (context, state) => const WithdrawMerchantScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: '/account-setup',
      builder: (context, state) => const AccountSetupScreen(),
    ),
    GoRoute(
      path: '/add-money',
      builder: (context, state) => const AddMoneyScreen(),
    ),
    GoRoute(
      path: '/add-money-via-transfer',
      builder: (context, state) => const AddMoneyTransferScreen(),
    ),
    GoRoute(
      path: '/add-money-via-qrcode',
      builder: (context, state) => const AddMoneyQRCode(),
    ),
  ],
);

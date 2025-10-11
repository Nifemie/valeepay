import 'package:go_router/go_router.dart';
import 'package:valarpay/features/dashboard/view/cards/get_physical_card.dart';
import 'package:valarpay/features/dashboard/view/me/rewards.dart';
import 'package:valarpay/features/dashboard/view/services/betting/betting.dart';
import 'package:valarpay/features/dashboard/view/services/cabletv/cabletv_screen.dart';
import 'package:valarpay/features/dashboard/view/services/education/education.dart';
import 'package:valarpay/features/dashboard/view/services/electricity/electricity_screen.dart';
import 'package:valarpay/features/dashboard/view/services/flight/flight_screen.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/gift_card.dart';
import 'package:valarpay/features/dashboard/view/services/insurance/insurance.dart';
import 'package:valarpay/features/dashboard/view/services/international_airtime/international_airtime_screen.dart';
import 'package:valarpay/features/dashboard/view/services/internet/internet_screen.dart';
import 'package:valarpay/features/dashboard/view/services/shopping/shopping.dart';
import 'package:valarpay/features/dashboard/view/services/swap_currency/swap_currency.dart';
import 'package:valarpay/features/dashboard/view/settings/close_account_screen.dart';
import '../../features/dashboard/view/services/airtime/airtime.dart';
import '../../features/dashboard/view/services/data/data.dart';
import '../../features/dashboard/view/services/airtime/schedule_topup.dart';
import '../../features/dashboard/view/services/airtime/ussd_enquiry.dart';
import '../../features/dashboard/view/me/transaction_history.dart';
import '../../features/dashboard/view/me/account_settings.dart';
import '../../features/dashboard/view/me/account_statement.dart';
import '../../features/dashboard/view/me/theme.dart';
import '../../features/dashboard/view/home/notifications/notification_view.dart';
import 'package:valarpay/features/dashboard/view/account/account_screen.dart';
import 'package:valarpay/features/dashboard/view/account/account_setup_screen.dart';
import '../../features/dashboard/view/me/portfolio.dart';
import 'package:valarpay/features/dashboard/view/addmoney/add_money_screen.dart';
import 'package:valarpay/features/dashboard/view/addmoney/add_money_via_qrcode_screen.dart';
import 'package:valarpay/features/dashboard/view/addmoney/add_money_via_transfer_screen.dart';
import 'package:valarpay/features/dashboard/view/comming_soon.dart';
import 'package:valarpay/features/dashboard/view/home/notifications/notifications_screen.dart';
import 'package:valarpay/features/dashboard/view/home/support/customer_service_screen.dart';
import 'package:valarpay/features/dashboard/view/home/support/faq_screen.dart';
import 'package:valarpay/features/dashboard/view/home/support/visit_office_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/select_bank_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_to_bank/transfer_to_bank.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_amount_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transaction_details_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_success_screen.dart';
import 'package:valarpay/features/dashboard/view/transfer/transfer_to_valarpay/transfer_to_valarpay_screen.dart';
import 'package:valarpay/features/dashboard/view/withdraw/withdraw_bank_branch_screen.dart';
import 'package:valarpay/features/dashboard/view/withdraw/withdraw_merchant_screen.dart';
import 'package:valarpay/features/dashboard/view/withdraw/withdraw_screen.dart';
import '../../features/dashboard/view/me/about_us.dart';
import '../../features/auth/views/introductory/intro_wrapper.dart';
import '../../features/auth/views/onboarding/change_password.dart';
import '../../features/auth/views/onboarding/forgot_password.dart';
import '../../features/auth/views/onboarding/signin/biometric_login.dart';
import '../../features/auth/views/onboarding/signin/passcode_login.dart';
import '../../features/auth/views/onboarding/signin/signin.dart';
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
import '../../features/dashboard/view/cards/card.dart';
import '../../features/dashboard/view/home/homescreen.dart';
import '../../features/dashboard/view/home/support/faq_detail_screen.dart';
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
  initialLocation: kDebugMode ? '/' : '/splash', // Always show splash screen

  routes: [
    // Auth routes (without dashboard wrapper)
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(),
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
          builder: (context, state) => const CardsScreen(),
        ),
        GoRoute(
          path: '/get-phisical-card',
          builder: (context, state) => const GetPhysicalCardScreen(),
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
      path: '/security-centre',
      builder: (context, state) => const SecuritySettingsScreen(),
    ),
    GoRoute(
      path: '/about-us',
      builder: (context, state) => const AboutUsPage(),
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
      path: '/my-rewards',
      builder: (context, state) => const MyRewardsPage(),
    ),
    GoRoute(
      path: 'My Portfolio',
      builder: (context, state) => const MyPortfolioPage(),
    ),
    // Services routes
    GoRoute(
      path: '/airtime',
      builder: (context, state) => const AirtimeScreen(),
    ),
    GoRoute(
      path: '/data',
      builder: (context, state) => const DataScreen(),
    ),
    GoRoute(
      path: '/schedule-topup',
      builder: (context, state) => const ScheduleTopupScreen(),
    ),
    GoRoute(
      path: '/ussd-enquiry',
      builder: (context, state) => const USSDEnquiryScreen(),
    ),

    // Me section routes
    GoRoute(
      path: '/transaction-history',
      builder: (context, state) => const TransactionHistoryPage(),
    ),
    GoRoute(
      path: '/account-settings',
      builder: (context, state) => const AccountSettingsPage(),
    ),
    GoRoute(
      path: '/account-statement',
      builder: (context, state) => const AccountStatementPage(),
    ),
    GoRoute(
      path: '/themes',
      builder: (context, state) => const ThemesPage(),
    ),

    // Notification routes
    GoRoute(
      path: '/notification-view',
      builder: (context, state) {
        final Map<String, String> data = state.extra as Map<String, String>? ??
            {'title': 'Notification', 'content': 'No content'};
        return NotificationViewScreen(
          title: data['title']!,
          content: data['content']!,
        );
      },
    ),

    // FAQ Detail route
    GoRoute(
      path: '/faq-detail',
      builder: (context, state) {
        final Map<String, String> data = state.extra as Map<String, String>? ??
            {'question': 'FAQ', 'answer': 'No answer available'};
        return FAQDetailScreen(
          question: data['question']!,
          answer: data['answer']!,
        );
      },
    ),
    GoRoute(
      path: '/electricity',
      builder: (context, state) => const ElectricityScreen(),
    ),
    GoRoute(
      path: '/flight',
      builder: (context, state) => const FlightScreen(),
    ),
    GoRoute(
      path: '/swap-currency',
      builder: (context, state) => const SwapCurrencyScreen(),
    ),
    GoRoute(
      path: '/insurance',
      builder: (context, state) => const InsuranceScreen(),
    ),
    GoRoute(
      path: '/international-airtime',
      builder: (context, state) => const InternationalAirtimeScreen(),
    ),
    GoRoute(
      path: '/education',
      builder: (context, state) => const EducationScreen(),
    ),
    GoRoute(
      path: '/internet',
      builder: (context, state) => const InternetScreen(),
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
    GoRoute(
      path: '/close-account',
      builder: (context, state) => const CloseAccountScreen(),
    ),
    GoRoute(
      path: '/cable-tv',
      builder: (context, state) => const CableTvScreen(),
    ),
    GoRoute(
      path: '/betting',
      builder: (context, state) => const BettingScreen(),
    ),
    GoRoute(
      path: '/shopping',
      builder: (context, state) => const ShoppingScreen(),
    ),

    GoRoute(
      path: '/gift-card',
      builder: (context, state) => const GiftCardScreen(),
    ),
  ],
);

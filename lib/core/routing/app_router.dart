import 'package:go_router/go_router.dart';
import 'package:valarpay/features/dashboard/view/commingsoon.dart';
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
import '../../features/dashboard/view/card.dart';
import '../../features/dashboard/view/home/homescreen.dart';
import '../../features/dashboard/view/invest.dart';
import '../../features/dashboard/view/me.dart';
import '../../features/dashboard/view/savings.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder:
          (context, state) =>
              SplashScreen(onAnimationComplete: () => context.push('/intro')),
    ),
    GoRoute(
      path: '/',
      builder:
          (context, state) => const Homescreen(
            firstName: 'John',
            profileImageUrl:
                'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
            balance: '1000',
          ),
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
      builder:
          (context, state) =>
              SignupSuccessScreen(firstName: state.extra as String? ?? 'User'),
    ),
    GoRoute(
      path: '/signin',
      pageBuilder:
          (context, state) => const NoTransitionPage(child: SignInScreen()),
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
    GoRoute(path: '/me', builder: (context, state) => const MeScreen()),
    GoRoute(
      path: '/finance',
      builder: (context, state) => const SavingsComingSoonScreen(),
    ),
    GoRoute(path: '/cards', builder: (context, state) => const CardScreen()),
    GoRoute(
      path: '/invest',
      builder: (context, state) => const InvestmentsComingSoonScreen(),
    ),
    GoRoute(
      path: '/coming-soon',
      builder: (context, state) => const ComingSoonScreen(),
    ),
  ],
);

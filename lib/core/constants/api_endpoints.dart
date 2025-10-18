class ApiEndpoints {
  //auth apis
  static const String login = '/api/v1/auth/login';
  static const String loginWithPasscode = '/api/v1/auth/passcode-login';
  static const String resend2fa = '/api/v1/auth/resend-2fa';
  static const String verify2fa = '/api/v1/auth/verify-2fa';
  //user api
  static const String existanceCheck = '/api/v1/user/existance-check';
  static const String register = '/api/v1/user/register';
  static const String registerBusiness = '/api/v1/user/register-business';
  static const String verifyEmail = '/api/v1/user/verify-email';
  static const String validateEmail = '/api/v1/user/validate-email';
  static const String verifyPhone = '/api/v1/user/verify-phonenumber';
  static const String validatePhone = '/api/v1/user/validate-phonenumber';
  static const String forgotPassword = '/api/v1/user/forgot-password';
  static const String resetPassword = '/api/v1/user/reset-password';
  static const String verifyForgotPassword =
      '/api/v1/user/verify-forgot-password';

  // KYC - BVN Verification
  static const String initializeBvn =
      '/api/v1/wallet/initiate-bvn-verification';
  static const String validateBvn = '/api/v1/wallet/validate-bvn-verification';

  // Wallet - Transaction PIN
  static const String setWalletPin = '/api/v1/user/set-wallet-pin';
  static const String verifyWalletPin = '/api/v1/user/verify-wallet-pin';

  // User Profile
  static const String getUserProfile = '/api/v1/user/me';

  // future endpoints can go here
}

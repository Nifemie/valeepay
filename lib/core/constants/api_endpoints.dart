class ApiEndpoints {
  //auth apis
  static const String login = '/api/v1/auth/login';
  static const String loginWithPasscode = '/api/v1/auth/passcode-login';
  //user api
  static const String register = '/api/v1/user/register';
  static const String registerBusiness = '/api/v1/user/register-business';
  static const String verifyEmail = '/api/v1/user/verify-email';
  static const String resendVerificationCode = '/api/v1/user/validate-email';
  static const String forgotPassword = '/api/v1/user/forgot-password';
  static const String resetPassword = '/api/v1/user/reset-password';
  static const String verifyForgotPassword =
      '/api/v1/user/verify-forgot-password';

  // future endpoints can go here
}

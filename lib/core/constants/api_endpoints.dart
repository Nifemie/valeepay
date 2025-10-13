
// AUTHSERVICE ENDPOINTS
class ApiEndpoints {
  static const String login = '/api/v1/auth/login';
  static const String loginWithPasscode = '/api/v1/auth/passcode-login';
  static const String register = '/api/v1/auth/register';
  static const String verifyEmail = '/api/v1/auth/verify-email';
  static const String resendVerificationCode = '/api/v1/auth/resend-verify-email';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String verifyForgotPassword = '/api/v1/auth/verify-forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String registerBusiness = '/api/v1/auth/register-business';
  // future endpoints can go here
}

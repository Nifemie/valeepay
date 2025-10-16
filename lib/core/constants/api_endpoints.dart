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

  // Bill payment endpoints
  static const String getAirtimeNetworkProviders =
      '/api/v1/bill/airtime/network-providers';
  static const String getAirtimePlan = '/api/v1/bill/airtime/get-plan';
  static const String getAirtimeVariation =
      '/api/v1/bill/airtime/get-variation';
  static const String payAirtime = '/api/v1/bill/airtime/pay';
  static const String getDataNetworkProviders =
      '/api/v1/bill/data/network-providers';
  static const String getDataPlan = '/api/v1/bill/data/get-plan';
  static const String getDataVariation = '/api/v1/bill/data/get-variation';
  static const String purchaseData = '/api/v1/bill/data/pay';

  // International airtime endpoints
  static const String getInternationalFxRate =
      '/api/v1/bill/airtime/international/get-fx-rate';
  static const String getInternationalPlan =
      '/api/v1/bill/airtime/international/get-plan';
  static const String payInternationalAirtime =
      '/api/v1/bill/airtime/international/pay';

  // future endpoints can go here
}

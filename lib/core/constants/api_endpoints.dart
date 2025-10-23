class ApiEndpoints {
  //auth apis
  static const String login = '/api/v1/auth/login';
  static const String loginWithPasscode = '/api/v1/auth/passcode-login';
  static const String createPasscode = '/api/v1/auth/create-passcode';
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

  // // Wallet - Transfers & Transactions
  // static const String getBanks = '/api/v1/wallet/get-banks';
  // static const String getTransferFee = '/api/v1/wallet/get-transfer-fee';
  // static const String verifyAccount = '/api/v1/wallet/verify-account'; //post name inquery
  // static const String initiateTransfer = '/api/v1/wallet/initiate-transfer'; //both for internal and external
  static const String getAllTransactions = '/api/v1/wallet/transaction';

  // Support endpoints
  static const String reportScam = '/api/v1/user/report-scam';
  static const String changePasscode = '/api/v1/user/change-passcode';
  static const String changePassword = '/api/v1/user/change-password';

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

  // Cable TV endpoints
  static const String getCablePlan = '/api/v1/bill/cable/get-plan';
  static const String getCableBillInfo = '/api/v1/bill/cable/get-bill-info';
  static const String verifyCableNumber =
      '/api/v1/bill/cable/verify-cable-number';
  static const String payCable = '/api/v1/bill/cable/pay';

  // Internet endpoints
  static const String getInternetPlan = '/api/v1/bill/internet/get-plan';
  static const String getInternetBillInfo =
      '/api/v1/bill/internet/get-bill-info';
  static const String payInternet = '/api/v1/bill/internet/pay';

  // International airtime endpoints
  static const String getInternationalFxRate =
      '/api/v1/bill/airtime/international/get-fx-rate';
  static const String getInternationalPlan =
      '/api/v1/bill/airtime/international/get-plan';
  static const String payInternationalAirtime =
      '/api/v1/bill/airtime/international/pay';

  // Giftcard endpoints
  static const String getGiftCardCategories =
      '/api/v1/bill/giftcard/get-categories';
  static const String getGiftCardProducts = '/api/v1/bill/giftcard/get-product';
  static const String payGiftCard = '/api/v1/bill/giftcard/pay';
  static const String getGiftCardRedeemCode =
      '/api/v1/bill/giftcard/get-redeem-code';
  static const String getGiftCardFxRate = '/api/v1/bill/giftcard/get-fx-rate';

  // Electricity endpoints
  static const String getElectricityPlan = '/api/v1/bill/electricity/get-plan';
  static const String getElectricityBillInfo =
      '/api/v1/bill/electricity/get-bill-info';
  static const String verifyMeterNumber =
      '/api/v1/bill/electricity/verify-meter-number';
  static const String payElectricity = '/api/v1/bill/electricity/pay';

  // Transfer endpoints
  static const String getBanks = '/api/v1/wallet/get-banks';
  static const String getTransferFee = '/api/v1/wallet/get-transfer-fee';
  static const String initiateTransfer = '/api/v1/wallet/initiate-transfer';
  static const String verifyAccount = '/api/v1/wallet/verify-account';
  static const String getTransactions = '/api/v1/wallet/transaction';
  static const String generateQRCode = '/api/v1/wallet/generate-qrcode';
  static const String decodeQRCode = '/api/v1/wallet/decode-qrcode';

  // future endpoints can go here
}

class BvnValidateRequest {
  final String verificationId;
  final String otpCode;

  BvnValidateRequest({
    required this.verificationId,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => {
        'verificationId': verificationId,
        'otpCode': otpCode,
      };
}

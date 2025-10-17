class BvnValidateRequest {
  final String bvn;
  final String verificationId;
  final String otpCode;

  BvnValidateRequest({
    required this.bvn,
    required this.verificationId,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => {
        'bvn': bvn,
        'verificationId': verificationId,
        'otpCode': otpCode,
      };
}

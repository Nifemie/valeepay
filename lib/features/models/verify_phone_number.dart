class VerifyPhoneOtpRequest {
  final String? phoneNumber;
  final String? otpCode;

  const VerifyPhoneOtpRequest({
    this.phoneNumber,
    this.otpCode,
  });

  VerifyPhoneOtpRequest copyWith({
    String? phoneNumber,
    String? otpCode,
  }) {
    return VerifyPhoneOtpRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  factory VerifyPhoneOtpRequest.fromJson(Map<String, dynamic> json) {
    return VerifyPhoneOtpRequest(
      phoneNumber: json['phoneNumber'],
      otpCode: json['otpCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otpCode': otpCode,
    };
  }
}

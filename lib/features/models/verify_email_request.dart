class VerifyEmailRequest {
  final String? email;
  final String? otpCode;

  const VerifyEmailRequest({
    this.email,
    this.otpCode,
  });

  VerifyEmailRequest copyWith({
    String? email,
    String? otpCode,
  }) {
    return VerifyEmailRequest(
      email: email ?? this.email,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) {
    return VerifyEmailRequest(
      email: json['email'],
      otpCode: json['otpCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otpCode': otpCode,
    };
  }
}

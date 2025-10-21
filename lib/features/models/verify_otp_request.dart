class VerifyOtpRequest {
  final String? username;
  final String? otpCode;

  const VerifyOtpRequest({
    this.username,
    this.otpCode,
  });

  VerifyOtpRequest copyWith({
    String? username,
    String? otpCode,
  }) {
    return VerifyOtpRequest(
      username: username ?? this.username,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequest(
      username: json['username'],
      otpCode: json['otpCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'otpCode': otpCode,
    };
  }
}

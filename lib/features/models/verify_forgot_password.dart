class VerifyForgotPassword {
  final String? username;
  final String? otpCode;

  const VerifyForgotPassword({
    this.username,
    this.otpCode,
  });

  VerifyForgotPassword copyWith({
    String? username,
    String? otpCode,
  }) {
    return VerifyForgotPassword(
      username: username ?? this.username,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  factory VerifyForgotPassword.fromJson(Map<String, dynamic> json) {
    return VerifyForgotPassword(
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

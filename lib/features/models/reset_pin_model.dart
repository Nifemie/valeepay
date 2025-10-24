class ResetPinRequest {
  final String? otpCode;
  final String? pin;
  final String? confirmPin;

  const ResetPinRequest({
    this.otpCode,
    this.pin,
    this.confirmPin,
  });

  ResetPinRequest copyWith({
    String? otpCode,
    String? pin,
    String? confirmPin,
  }) {
    return ResetPinRequest(
      otpCode: otpCode ?? this.otpCode,
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
    );
  }

  factory ResetPinRequest.fromJson(Map<String, dynamic> json) {
    return ResetPinRequest(
      otpCode: json['otpCode'],
      pin: json['pin'],
      confirmPin: json['confirmPin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otpCode': otpCode,
      'pin': pin,
      'confirmPin': confirmPin,
    };
  }
}

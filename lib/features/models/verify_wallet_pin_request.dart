class VerifyWalletPinRequest {
  final String pin;

  VerifyWalletPinRequest({
    required this.pin,
  });

  Map<String, dynamic> toJson() {
    return {
      'pin': pin,
    };
  }

  factory VerifyWalletPinRequest.fromJson(Map<String, dynamic> json) {
    return VerifyWalletPinRequest(
      pin: json['pin'] as String,
    );
  }
}

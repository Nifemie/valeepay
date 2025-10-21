class SetWalletPinRequest {
  final String pin;

  SetWalletPinRequest({required this.pin});

  Map<String, dynamic> toJson() {
    return {
      'pin': pin,
    };
  }
}

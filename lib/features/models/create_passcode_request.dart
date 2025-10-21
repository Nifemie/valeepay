class CreatePasscodeRequest {
  final String passcode;

  CreatePasscodeRequest({
    required this.passcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'passcode': passcode,
    };
  }

  factory CreatePasscodeRequest.fromJson(Map<String, dynamic> json) {
    return CreatePasscodeRequest(
      passcode: json['passcode'] as String,
    );
  }
}

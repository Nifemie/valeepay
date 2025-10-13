class PhoneNumberRequest {
  final String? phoneNumber;

  const PhoneNumberRequest({
    this.phoneNumber,
  });

  PhoneNumberRequest copyWith({
    String? phoneNumber,
  }) {
    return PhoneNumberRequest(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory PhoneNumberRequest.fromJson(Map<String, dynamic> json) {
    return PhoneNumberRequest(
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
    };
  }
}

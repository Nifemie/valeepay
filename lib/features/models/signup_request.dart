class SignUpRequest {
  final String? username;
  final String? fullname;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? dateOfBirth;
  final String? countryCode;
  final String? referralCode;
  final String? accountType;
  final String? businessName;
  final String? companyRegistrationNumber;

  const SignUpRequest({
    this.username,
    this.fullname,
    this.email,
    this.phoneNumber,
    this.password,
    this.dateOfBirth,
    this.countryCode,
    this.referralCode,
    this.accountType,
    this.businessName,
    this.companyRegistrationNumber,
  });

  SignUpRequest copyWith({
    String? username,
    String? fullname,
    String? email,
    String? phoneNumber,
    String? password,
    String? dateOfBirth,
    String? countryCode,
    String? referralCode,
    String? accountType,
    String? businessName,
    String? companyRegistrationNumber,
  }) {
    return SignUpRequest(
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      countryCode: countryCode ?? this.countryCode,
      referralCode: referralCode ?? this.referralCode,
      accountType: accountType ?? this.accountType,
      businessName: businessName ?? this.businessName,
      companyRegistrationNumber:
          companyRegistrationNumber ?? this.companyRegistrationNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'countryCode': countryCode,
      'referralCode': referralCode,
      'accountType': accountType,
      'businessName': businessName,
      'companyRegistrationNumber': companyRegistrationNumber,
    };
  }

  static SignUpRequest fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      username: json['username'],
      fullname: json['fullname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      dateOfBirth: json['dateOfBirth'],
      countryCode: json['countryCode'],
      referralCode: json['referralCode'],
      accountType: json['accountType'],
      businessName: json['businessName'],
      companyRegistrationNumber: json['companyRegistrationNumber'],
    );
  }
}

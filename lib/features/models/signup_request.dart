
class SignUpRequest {
  final String? username;
  final String? fullname;
  final String? email;
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
      'password': password,
      'dateOfBirth': dateOfBirth,
      'countryCode': countryCode,
      'referralCode': referralCode,
      'accountType': accountType,
      'businessName': businessName,
      'companyRegistrationNumber': companyRegistrationNumber,
    };
  }
}


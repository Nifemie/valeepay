import 'package:valarpay/features/models/user.dart';

class LoginRequest {
  final String email;
  final String password;
  final String ipAddress;
  final String deviceName;
  final String operatingSystem;

  LoginRequest({
    required this.email,
    required this.password,
    required this.ipAddress,
    required this.deviceName,
    required this.operatingSystem,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "ipAddress": ipAddress,
        "deviceName": deviceName,
        "operatingSystem": operatingSystem,
      };
}

class PasscodeLoginRequest {
  final String email;
  final String passcode;
  final String ipAddress;
  final String deviceName;
  final String operatingSystem;

  PasscodeLoginRequest({
    required this.email,
    required this.passcode,
    required this.ipAddress,
    required this.deviceName,
    required this.operatingSystem,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'passcode': passcode,
      'ipAddress': ipAddress,
      'deviceName': deviceName,
      'operatingSystem': operatingSystem,
    };
  }
}

class LoginResponse {
  final String message;
  final UserModel user;
  final int statusCode;

  LoginResponse({
    required this.message,
    required this.user,
    required this.statusCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json['message'] ?? '',
        user: UserModel.fromJson(json['user']),
        statusCode: json['statusCode'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'user': user.toJson(),
        'statusCode': statusCode,
      };
}

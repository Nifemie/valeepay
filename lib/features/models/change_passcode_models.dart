class ChangePasscodeRequest {
  final String oldPasscode;
  final String newPasscode;

  ChangePasscodeRequest({
    required this.oldPasscode,
    required this.newPasscode,
  });

  Map<String, dynamic> toJson() => {
        'oldPasscode': oldPasscode,
        'newPasscode': newPasscode,
      };
}

class ChangePasscodeResponse {
  final String message;
  final int statusCode;

  ChangePasscodeResponse({
    required this.message,
    required this.statusCode,
  });

  factory ChangePasscodeResponse.fromJson(Map<String, dynamic> json) =>
      ChangePasscodeResponse(
        message: json['message'] ?? 'Password updated successfully',
        statusCode: json['statusCode'] ?? 200,
      );
}

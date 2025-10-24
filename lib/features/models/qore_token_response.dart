class QoreTokenResponse {
  final String? accessToken;
  final int? expiresIn;
  final String? tokenType;
  final int? statusCode;
  final String? message;

  QoreTokenResponse({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.statusCode,
    this.message,
  });

  factory QoreTokenResponse.fromJson(Map<String, dynamic> json) =>
      QoreTokenResponse(
        accessToken: json['accessToken'],
        expiresIn: json['expiresIn'],
        tokenType: json['tokenType'],
        statusCode: json['statusCode'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresIn': expiresIn,
    'tokenType': tokenType,
    'statusCode': statusCode,
    'message': message,
  };
}

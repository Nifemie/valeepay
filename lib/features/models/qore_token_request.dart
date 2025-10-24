class QoreTokenRequest {
  final String clientId;
  final String secret;

  QoreTokenRequest({required this.clientId, required this.secret});

  factory QoreTokenRequest.fromJson(Map<String, dynamic> json) =>
      QoreTokenRequest(
        clientId: json['clientId'] ?? '',
        secret: json['secret'] ?? '',
      );

  Map<String, dynamic> toJson() => {'clientId': clientId, 'secret': secret};
}

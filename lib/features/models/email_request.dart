class EmailRequest {
  final String? email;

  const EmailRequest({
    this.email,
  });

  EmailRequest copyWith({
    String? email,
  }) {
    return EmailRequest(
      email: email ?? this.email,
    );
  }

  factory EmailRequest.fromJson(Map<String, dynamic> json) {
    return EmailRequest(
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

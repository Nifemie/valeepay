class UserAvailabilityRequest {
  final String? username;
  final String? email;
  final String? phoneNumber;

  const UserAvailabilityRequest({
    this.username,
    this.email,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    }..removeWhere((key, value) => value == null);
  }

  factory UserAvailabilityRequest.fromJson(Map<String, dynamic> json) {
    return UserAvailabilityRequest(
      username: json['username'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  UserAvailabilityRequest copyWith({
    String? username,
    String? email,
    String? phoneNumber,
  }) {
    return UserAvailabilityRequest(
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

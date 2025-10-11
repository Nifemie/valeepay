class UserModel {
  final String id;
  final String email;
  final String username;
  final String fullname;
  final String role;
  final String status;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.fullname,
    required this.role,
    required this.status,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        fullname: json['fullname'],
        role: json['role'],
        status: json['status'],
        isEmailVerified: json['isEmailVerified'],
        isPhoneVerified: json['isPhoneVerified'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'fullname': fullname,
        'role': role,
        'status': status,
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
      };
}

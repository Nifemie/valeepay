class QoreBvnFaceVerificationRequest {
  final String idNumber;
  final String photoBase64;
  final String? photoUrl;
  final String? photo;

  QoreBvnFaceVerificationRequest({
    required this.idNumber,
    required this.photoBase64,
    this.photoUrl,
    this.photo,
  });

  factory QoreBvnFaceVerificationRequest.fromJson(Map<String, dynamic> json) =>
      QoreBvnFaceVerificationRequest(
        idNumber: json['idNumber'] ?? '',
        photoBase64: json['photoBase64'] ?? '',
        photoUrl: json['photoUrl'],
        photo: json['photo'],
      );

  Map<String, dynamic> toJson() => {
        'idNumber': idNumber,
        'photoBase64': photoBase64,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (photo != null) 'photo': photo,
      };
}

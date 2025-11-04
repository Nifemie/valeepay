class BvnVerificationRequest {
  final String? bvn;
  final String? selfieImage;

  BvnVerificationRequest({this.bvn, this.selfieImage});

  Map<String, dynamic> toJson() => {'bvn': bvn, 'selfieImage': selfieImage};
}

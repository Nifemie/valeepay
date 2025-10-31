class NinVerificationRequest {
  final String nin;
  final String selfieImage;

  NinVerificationRequest({
    required this.nin,
    required this.selfieImage,
  });

  factory NinVerificationRequest.fromJson(Map<String, dynamic> json) =>
      NinVerificationRequest(
        nin: json['nin'] ?? '',
        selfieImage: json['selfieImage'] ?? '',
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nin': nin,
    };
    
    // Only include selfieImage if it's not empty
    if (selfieImage.isNotEmpty) {
      map['selfieImage'] = selfieImage;
    }
    
    return map;
  }
}

class QoreBvnFaceVerificationResponse {
  final int? id;
  final QoreBvnFaceVerificationSummary? summary;
  final int? statusCode;
  final String? message;

  QoreBvnFaceVerificationResponse({
    this.id,
    this.summary,
    this.statusCode,
    this.message,
  });

  factory QoreBvnFaceVerificationResponse.fromJson(Map<String, dynamic> json) =>
      QoreBvnFaceVerificationResponse(
        id: json['id'],
        summary:
            json['summary'] != null
                ? QoreBvnFaceVerificationSummary.fromJson(json['summary'])
                : null,
        statusCode: json['statusCode'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (summary != null) 'summary': summary!.toJson(),
    'statusCode': statusCode,
    'message': message,
  };
}

class QoreBvnFaceVerificationSummary {
  final QoreFaceVerificationCheck? faceVerificationCheck;

  QoreBvnFaceVerificationSummary({this.faceVerificationCheck});

  factory QoreBvnFaceVerificationSummary.fromJson(Map<String, dynamic> json) =>
      QoreBvnFaceVerificationSummary(
        faceVerificationCheck:
            json['face_verification_check'] != null
                ? QoreFaceVerificationCheck.fromJson(
                  json['face_verification_check'],
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    if (faceVerificationCheck != null)
      'face_verification_check': faceVerificationCheck!.toJson(),
  };
}

class QoreFaceVerificationCheck {
  final QoreFaceVerificationStatus? status;
  final QoreFaceVerificationDetails? faceVerification;

  QoreFaceVerificationCheck({this.status, this.faceVerification});

  factory QoreFaceVerificationCheck.fromJson(Map<String, dynamic> json) =>
      QoreFaceVerificationCheck(
        status:
            json['status'] != null
                ? QoreFaceVerificationStatus.fromJson(json['status'])
                : null,
        faceVerification:
            json['face_verification'] != null
                ? QoreFaceVerificationDetails.fromJson(
                  json['face_verification'],
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    if (status != null) 'status': status!.toJson(),
    if (faceVerification != null)
      'face_verification': faceVerification!.toJson(),
  };
}

class QoreFaceVerificationStatus {
  final String? state;
  final String? status;

  QoreFaceVerificationStatus({this.state, this.status});

  factory QoreFaceVerificationStatus.fromJson(Map<String, dynamic> json) =>
      QoreFaceVerificationStatus(state: json['state'], status: json['status']);

  Map<String, dynamic> toJson() => {'state': state, 'status': status};
}

class QoreFaceVerificationDetails {
  final String? bvn;
  final String? firstname;
  final String? lastname;
  final String? birthdate;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? lgaOfResidence;
  final String? maritalStatus;
  final String? nationality;
  final String? residentialAddress;
  final String? stateOfResidence;
  final String? email;
  final String? enrollmentBank;
  final String? watchListed;

  QoreFaceVerificationDetails({
    this.bvn,
    this.firstname,
    this.lastname,
    this.birthdate,
    this.gender,
    this.phone,
    this.photo,
    this.lgaOfResidence,
    this.maritalStatus,
    this.nationality,
    this.residentialAddress,
    this.stateOfResidence,
    this.email,
    this.enrollmentBank,
    this.watchListed,
  });

  factory QoreFaceVerificationDetails.fromJson(Map<String, dynamic> json) =>
      QoreFaceVerificationDetails(
        bvn: json['bvn'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        birthdate: json['birthdate'],
        gender: json['gender'],
        phone: json['phone'],
        photo: json['photo'],
        lgaOfResidence: json['lga_of_residence'],
        maritalStatus: json['marital_status'],
        nationality: json['nationality'],
        residentialAddress: json['residential_address'],
        stateOfResidence: json['state_of_residence'],
        email: json['email'],
        enrollmentBank: json['enrollment_bank'],
        watchListed: json['watch_listed'],
      );

  Map<String, dynamic> toJson() => {
    'bvn': bvn,
    'firstname': firstname,
    'lastname': lastname,
    'birthdate': birthdate,
    'gender': gender,
    'phone': phone,
    'photo': photo,
    'lga_of_residence': lgaOfResidence,
    'marital_status': maritalStatus,
    'nationality': nationality,
    'residential_address': residentialAddress,
    'state_of_residence': stateOfResidence,
    'email': email,
    'enrollment_bank': enrollmentBank,
    'watch_listed': watchListed,
  };
}

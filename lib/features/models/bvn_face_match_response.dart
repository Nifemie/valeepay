import 'dart:convert';

class BvnFaceMatchResponse {
  final int? id;
  final Summary? summary;
  final Status? status;
  final FaceVerification? faceVerification;

  BvnFaceMatchResponse({
    this.id,
    this.summary,
    this.status,
    this.faceVerification,
  });

  factory BvnFaceMatchResponse.fromJson(Map<String, dynamic> json) {
    return BvnFaceMatchResponse(
      id: json['id'],
      summary:
          json['summary'] != null ? Summary.fromJson(json['summary']) : null,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      faceVerification: json['face_verification'] != null
          ? FaceVerification.fromJson(json['face_verification'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summary': summary?.toJson(),
      'status': status?.toJson(),
      'face_verification': faceVerification?.toJson(),
    };
  }

  static BvnFaceMatchResponse fromJsonString(String source) =>
      BvnFaceMatchResponse.fromJson(json.decode(source));

  String toJsonString() => json.encode(toJson());
}

class Summary {
  final FaceVerificationCheck? faceVerificationCheck;

  Summary({this.faceVerificationCheck});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      faceVerificationCheck: json['face_verification_check'] != null
          ? FaceVerificationCheck.fromJson(json['face_verification_check'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'face_verification_check': faceVerificationCheck?.toJson(),
    };
  }
}

class FaceVerificationCheck {
  final bool? match;
  final double? matchScore;
  final double? matchingThreshold;
  final double? maxScore;

  FaceVerificationCheck({
    this.match,
    this.matchScore,
    this.matchingThreshold,
    this.maxScore,
  });

  factory FaceVerificationCheck.fromJson(Map<String, dynamic> json) {
    return FaceVerificationCheck(
      match: json['match'],
      matchScore: (json['match_score'] as num?)?.toDouble(),
      matchingThreshold: (json['matching_threshold'] as num?)?.toDouble(),
      maxScore: (json['max_score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match': match,
      'match_score': matchScore,
      'matching_threshold': matchingThreshold,
      'max_score': maxScore,
    };
  }
}

class Status {
  final String? state;
  final String? status;

  Status({this.state, this.status});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      state: json['state'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'status': status,
    };
  }
}

class FaceVerification {
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

  FaceVerification({
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

  factory FaceVerification.fromJson(Map<String, dynamic> json) {
    return FaceVerification(
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
  }

  Map<String, dynamic> toJson() {
    return {
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
}

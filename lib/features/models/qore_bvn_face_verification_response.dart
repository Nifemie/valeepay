class QoreBvnFaceVerificationResponse {
  final int? id;
  final Metadata? metadata;
  final Summary? summary;
  final Status? status;
  final BvnData? bvn;
  final String? message;
  final int? statusCode;
  final FaceVerification? faceVerification;

  const QoreBvnFaceVerificationResponse({
    this.id,
    this.metadata,
    this.summary,
    this.status,
    this.bvn,
    this.faceVerification,
    this.message,
    this.statusCode,
  });

  QoreBvnFaceVerificationResponse copyWith({
    int? id,
    Metadata? metadata,
    Summary? summary,
    Status? status,
    BvnData? bvn,
    String? message,
    int? statusCode,
    FaceVerification? faceVerification,
  }) {
    return QoreBvnFaceVerificationResponse(
      id: id ?? this.id,
      statusCode: this.statusCode,
      message: this.message,
      metadata: metadata ?? this.metadata,
      summary: summary ?? this.summary,
      status: status ?? this.status,
      bvn: bvn ?? this.bvn,
      faceVerification: faceVerification ?? this.faceVerification,
    );
  }

  factory QoreBvnFaceVerificationResponse.fromJson(Map<String, dynamic> json) {
    return QoreBvnFaceVerificationResponse(
      id: json['id'],
      statusCode: json['statusCode'],
      message: json['message'],
      metadata:
          json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null,
      summary:
          json['summary'] != null ? Summary.fromJson(json['summary']) : null,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      bvn: json['bvn'] != null ? BvnData.fromJson(json['bvn']) : null,
      faceVerification:
          json['face_verification'] != null
              ? FaceVerification.fromJson(json['face_verification'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statusCode': statusCode,
      'message': message,
      'metadata': metadata?.toJson(),
      'summary': summary?.toJson(),
      'status': status?.toJson(),
      'bvn': bvn?.toJson(),
      'face_verification': faceVerification?.toJson(),
    };
  }
}

class Metadata {
  final String? type;
  final bool? match;
  final double? matchScore;
  final double? matchingThreshold;
  final double? maxScore;
  final String? imageUrl;

  const Metadata({
    this.type,
    this.match,
    this.matchScore,
    this.matchingThreshold,
    this.maxScore,
    this.imageUrl,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      type: json['type'],
      match: json['match'],
      matchScore: (json['match_score'] as num?)?.toDouble(),
      matchingThreshold: (json['matching_threshold'] as num?)?.toDouble(),
      maxScore: (json['max_score'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'match': match,
      'match_score': matchScore,
      'matching_threshold': matchingThreshold,
      'max_score': maxScore,
      'imageUrl': imageUrl,
    };
  }
}

class Summary {
  final FaceVerificationCheck? faceVerificationCheck;
  final BvnCheck? bvnCheck;

  const Summary({this.faceVerificationCheck, this.bvnCheck});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      faceVerificationCheck:
          json['face_verification_check'] != null
              ? FaceVerificationCheck.fromJson(json['face_verification_check'])
              : null,
      bvnCheck:
          json['bvn_check'] != null
              ? BvnCheck.fromJson(json['bvn_check'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'face_verification_check': faceVerificationCheck?.toJson(),
      'bvn_check': bvnCheck?.toJson(),
    };
  }
}

class FaceVerificationCheck {
  final bool? match;
  final double? matchScore;
  final double? matchingThreshold;
  final double? maxScore;

  const FaceVerificationCheck({
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

class BvnCheck {
  final String? status;
  final FieldMatches? fieldMatches;

  const BvnCheck({this.status, this.fieldMatches});

  factory BvnCheck.fromJson(Map<String, dynamic> json) {
    return BvnCheck(
      status: json['status'],
      fieldMatches:
          json['fieldMatches'] != null
              ? FieldMatches.fromJson(json['fieldMatches'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'fieldMatches': fieldMatches?.toJson()};
  }
}

class FieldMatches {
  final bool? firstname;
  final bool? lastname;
  final bool? dob;
  final bool? phoneNumber;
  final bool? gender;
  final bool? emailAddress;

  const FieldMatches({
    this.firstname,
    this.lastname,
    this.dob,
    this.phoneNumber,
    this.gender,
    this.emailAddress,
  });

  factory FieldMatches.fromJson(Map<String, dynamic> json) {
    return FieldMatches(
      firstname: json['firstname'],
      lastname: json['lastname'],
      dob: json['dob'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      emailAddress: json['emailAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'dob': dob,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'emailAddress': emailAddress,
    };
  }
}

class Status {
  final String? state;
  final String? status;

  const Status({this.state, this.status});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(state: json['state'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {'state': state, 'status': status};
  }
}

class BvnData {
  final String? bvn;
  final String? firstname;
  final String? lastname;
  final String? middlename;
  final String? birthdate;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? lgaOfOrigin;
  final String? lgaOfResidence;
  final String? maritalStatus;
  final String? nationality;
  final String? residentialAddress;
  final String? stateOfOrigin;
  final String? stateOfResidence;
  final String? email;
  final String? enrollmentBank;
  final String? enrollmentBranch;
  final String? title;
  final String? nameOnCard;
  final String? nin;
  final String? levelOfAccount;
  final String? phone2;
  final String? registrationDate;
  final String? watchListed;
  final String? imageUrl;

  const BvnData({
    this.bvn,
    this.firstname,
    this.lastname,
    this.middlename,
    this.birthdate,
    this.gender,
    this.phone,
    this.photo,
    this.lgaOfOrigin,
    this.lgaOfResidence,
    this.maritalStatus,
    this.nationality,
    this.residentialAddress,
    this.stateOfOrigin,
    this.stateOfResidence,
    this.email,
    this.enrollmentBank,
    this.enrollmentBranch,
    this.title,
    this.nameOnCard,
    this.nin,
    this.levelOfAccount,
    this.phone2,
    this.registrationDate,
    this.watchListed,
    this.imageUrl,
  });

  factory BvnData.fromJson(Map<String, dynamic> json) {
    return BvnData(
      bvn: json['bvn'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      phone: json['phone'],
      photo: json['photo'],
      lgaOfOrigin: json['lga_of_origin'],
      lgaOfResidence: json['lga_of_residence'],
      maritalStatus: json['marital_status'],
      nationality: json['nationality'],
      residentialAddress: json['residential_address'],
      stateOfOrigin: json['state_of_origin'],
      stateOfResidence: json['state_of_residence'],
      email: json['email'],
      enrollmentBank: json['enrollment_bank'],
      enrollmentBranch: json['enrollment_branch'],
      title: json['title'],
      nameOnCard: json['name_on_card'],
      nin: json['nin'],
      levelOfAccount: json['level_of_account'],
      phone2: json['phone2'],
      registrationDate: json['registration_date'],
      watchListed: json['watch_listed'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bvn': bvn,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'birthdate': birthdate,
      'gender': gender,
      'phone': phone,
      'photo': photo,
      'lga_of_origin': lgaOfOrigin,
      'lga_of_residence': lgaOfResidence,
      'marital_status': maritalStatus,
      'nationality': nationality,
      'residential_address': residentialAddress,
      'state_of_origin': stateOfOrigin,
      'state_of_residence': stateOfResidence,
      'email': email,
      'enrollment_bank': enrollmentBank,
      'enrollment_branch': enrollmentBranch,
      'title': title,
      'name_on_card': nameOnCard,
      'nin': nin,
      'level_of_account': levelOfAccount,
      'phone2': phone2,
      'registration_date': registrationDate,
      'watch_listed': watchListed,
      'imageUrl': imageUrl,
    };
  }
}

class FaceVerification {
  final bool? match;
  final double? matchScore;
  final double? matchingThreshold;
  final double? maxScore;

  const FaceVerification({
    this.match,
    this.matchScore,
    this.matchingThreshold,
    this.maxScore,
  });

  factory FaceVerification.fromJson(Map<String, dynamic> json) {
    return FaceVerification(
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

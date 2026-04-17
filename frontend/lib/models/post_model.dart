import 'package:cloud_firestore/cloud_firestore.dart';

enum VerificationStatus {
  verified,
  falseCase,
  pending,
}

class Post {
  final String? id;
  final String userName;
  final String profilePic;
  final String location;
  final List<String> mediaUrls;
  final String caseTitle;
  final String caseId;
  final String description;
  final double raised;
  final double goal;
  final VerificationStatus status;
  final String? createdBy;
  final String? creatorEmail;
  final DateTime? createdAt;

  // Personal issue fields
  final String? issueType; // 'personal' or 'social'
  final String? victimName;
  final String? victimAge;
  final String? victimGender;
  final String? relation;
  final String? victimBackground;

  // Social issue fields
  final String? contactPerson;
  final String? policeStation;
  final String? socialIssueDetails;

  Post({
    this.id,
    required this.userName,
    required this.profilePic,
    required this.location,
    required this.mediaUrls,
    required this.caseTitle,
    required this.caseId,
    required this.description,
    required this.raised,
    required this.goal,
    required this.status,
    this.createdBy,
    this.creatorEmail,
    this.createdAt,
    this.issueType,
    this.victimName,
    this.victimAge,
    this.victimGender,
    this.relation,
    this.victimBackground,
    this.contactPerson,
    this.policeStation,
    this.socialIssueDetails,
  });

  factory Post.fromJson(Map<String, dynamic> json, {String? docId}) {
    return Post(
      id: docId ?? json['id'] as String?,
      userName: json['userName'] as String? ?? 'Unknown',
      profilePic: json['profilePic'] as String? ?? '',
      location: json['location'] as String? ?? '',
      mediaUrls: (json['mediaUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      caseTitle: json['title'] as String? ?? json['caseTitle'] as String? ?? '',
      caseId: json['caseId'] as String? ?? docId ?? '',
      description: json['description'] as String? ?? '',
      raised: (json['raised'] as num?)?.toDouble() ?? 0.0,
      goal: (json['fundGoal'] as num?)?.toDouble() ??
          (json['goal'] as num?)?.toDouble() ??
          0.0,
      status: _parseStatus(json['status']),
      createdBy: json['createdBy'] as String?,
      creatorEmail: json['creatorEmail'] as String?,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : json['createdAt'] is String
              ? DateTime.tryParse(json['createdAt'] as String)
              : null,
      issueType: json['issueType'] as String?,
      victimName: json['victimName'] as String?,
      victimAge: json['victimAge'] as String?,
      victimGender: json['victimGender'] as String?,
      relation: json['relation'] as String?,
      victimBackground: json['victimBackground'] as String?,
      contactPerson: json['contactPerson'] as String?,
      policeStation: json['policeStation'] as String?,
      socialIssueDetails: json['socialIssueDetails'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'profilePic': profilePic,
      'location': location,
      'mediaUrls': mediaUrls,
      'title': caseTitle,
      'caseId': caseId,
      'description': description,
      'raised': raised,
      'fundGoal': goal,
      'status': _statusToString(status),
      'createdBy': createdBy,
      'creatorEmail': creatorEmail,
      'createdAt': FieldValue.serverTimestamp(),
      if (issueType != null) 'issueType': issueType,
      if (victimName != null) 'victimName': victimName,
      if (victimAge != null) 'victimAge': victimAge,
      if (victimGender != null) 'victimGender': victimGender,
      if (relation != null) 'relation': relation,
      if (victimBackground != null) 'victimBackground': victimBackground,
      if (contactPerson != null) 'contactPerson': contactPerson,
      if (policeStation != null) 'policeStation': policeStation,
      if (socialIssueDetails != null) 'socialIssueDetails': socialIssueDetails,
    };
  }

  // The Cloud Functions expect 'creatorName' — add an alias
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['creatorName'] = userName;
    return json;
  }

  static VerificationStatus _parseStatus(dynamic value) {
    if (value == null) return VerificationStatus.pending;
    final s = value.toString().toLowerCase();
    if (s == 'verified' || s == 'active') return VerificationStatus.verified;
    if (s == 'falsecase' || s == 'false_case' || s == 'rejected') {
      return VerificationStatus.falseCase;
    }
    return VerificationStatus.pending;
  }

  static String _statusToString(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return 'active';
      case VerificationStatus.falseCase:
        return 'rejected';
      case VerificationStatus.pending:
        return 'pending';
    }
  }
}

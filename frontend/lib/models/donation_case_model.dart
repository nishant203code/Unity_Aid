import 'package:cloud_firestore/cloud_firestore.dart';

class DonationCase {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String category;
  final String location;
  final String imageUrl;
  final double targetAmount;
  final double raisedAmount;
  final DateTime deadline;
  final String urgencyLevel; // "Critical", "High", "Medium", "Low"
  
  // Beneficiary Information
  final String beneficiaryName;
  final int? beneficiaryAge;
  final String? beneficiaryGender;
  
  // Case Details
  final String caseStory;
  final List<String> requirements;
  final String currentStatus;
  
  // NGO/Handler Information
  final String? handlingNGO;
  final String? ngoLogoUrl;
  final bool isVerified;
  
  // Additional Info
  final int supportersCount;
  final DateTime createdDate;
  final List<String>? additionalImages;
  final Map<String, String>? documents; // Document name -> URL

  DonationCase({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.targetAmount,
    required this.raisedAmount,
    required this.deadline,
    required this.urgencyLevel,
    required this.beneficiaryName,
    this.beneficiaryAge,
    this.beneficiaryGender,
    required this.caseStory,
    required this.requirements,
    required this.currentStatus,
    this.handlingNGO,
    this.ngoLogoUrl,
    required this.isVerified,
    required this.supportersCount,
    required this.createdDate,
    this.additionalImages,
    this.documents,
  });

  double get progressPercentage => (raisedAmount / targetAmount) * 100;
  
  double get remainingAmount => targetAmount - raisedAmount;
  
  int get daysRemaining {
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }
  
  bool get isUrgent => urgencyLevel == "Critical" || urgencyLevel == "High";
  
  bool get isExpiringSoon => daysRemaining <= 7;

  factory DonationCase.fromJson(Map<String, dynamic> json, {String? docId}) {
    return DonationCase(
      id: docId ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      fullDescription: json['fullDescription'] as String? ?? '',
      category: json['category'] as String? ?? 'Other',
      location: json['location'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      raisedAmount: (json['raisedAmount'] as num?)?.toDouble() ?? 0.0,
      deadline: json['deadline'] is Timestamp
          ? (json['deadline'] as Timestamp).toDate()
          : json['deadline'] is String
              ? DateTime.tryParse(json['deadline'] as String) ?? DateTime.now().add(const Duration(days: 30))
              : DateTime.now().add(const Duration(days: 30)),
      urgencyLevel: json['urgencyLevel'] as String? ?? 'Medium',
      beneficiaryName: json['beneficiaryName'] as String? ?? '',
      beneficiaryAge: json['beneficiaryAge'] as int?,
      beneficiaryGender: json['beneficiaryGender'] as String?,
      caseStory: json['caseStory'] as String? ?? '',
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      currentStatus: json['currentStatus'] as String? ?? 'Active',
      handlingNGO: json['handlingNGO'] as String?,
      ngoLogoUrl: json['ngoLogoUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      supportersCount: json['supportersCount'] as int? ?? 0,
      createdDate: json['createdDate'] is Timestamp
          ? (json['createdDate'] as Timestamp).toDate()
          : json['createdDate'] is String
              ? DateTime.tryParse(json['createdDate'] as String) ?? DateTime.now()
              : DateTime.now(),
      additionalImages: (json['additionalImages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      documents: (json['documents'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'category': category,
      'location': location,
      'imageUrl': imageUrl,
      'targetAmount': targetAmount,
      'raisedAmount': raisedAmount,
      'deadline': Timestamp.fromDate(deadline),
      'urgencyLevel': urgencyLevel,
      'beneficiaryName': beneficiaryName,
      if (beneficiaryAge != null) 'beneficiaryAge': beneficiaryAge,
      if (beneficiaryGender != null) 'beneficiaryGender': beneficiaryGender,
      'caseStory': caseStory,
      'requirements': requirements,
      'currentStatus': currentStatus,
      if (handlingNGO != null) 'handlingNGO': handlingNGO,
      if (ngoLogoUrl != null) 'ngoLogoUrl': ngoLogoUrl,
      'isVerified': isVerified,
      'supportersCount': supportersCount,
      'createdDate': Timestamp.fromDate(createdDate),
      if (additionalImages != null) 'additionalImages': additionalImages,
      if (documents != null) 'documents': documents,
    };
  }
}

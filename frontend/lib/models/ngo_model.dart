class NGO {
  final String name;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final String logoUrl;
  final int members;
  final int followers;

  // Legal & Registration Information
  final String? registrationNumber;
  final String? fcraNumber;
  final String? darpanNumber;
  final String? legalStatus;
  final String? panNumber;
  final String? tanNumber;
  final List<String>? certificates;
  final List<AnnualReport>? annualReports;
  final String? ownerName;

  // Mission & Objectives
  final String? mission;
  final String? vision;
  final List<String>? targetCommunities;
  final List<String>? projectTypes;

  // Financial Transparency
  final List<FinancialReport>? financialReports;
  final List<String>? fundingSources;
  final ExpenseBreakdown? expenseBreakdown;
  final List<String>? auditReports;

  // Leadership & Governance
  final List<BoardMember>? boardMembers;
  final String? governanceStructure;

  // Program Evidence & Impact
  final List<Project>? projects;
  final List<String>? testimonials;
  final ImpactMetrics? impactMetrics;

  // Public Reputation & Partnerships
  final List<Partnership>? partnerships;
  final List<Review>? reviews;
  final double? rating;
  final List<String>? mediaMentions;

  // Communication & Accessibility
  final String? website;
  final String? email;
  final String? phone;
  final String? address;
  final Map<String, String>? socialMedia;

  // Banking Information
  final String? bankName;
  final String? bankAccountNumber;
  final String? ifscCode;

  NGO({
    required this.name,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.logoUrl,
    required this.members,
    required this.followers,
    this.registrationNumber,
    this.fcraNumber,
    this.darpanNumber,
    this.legalStatus,
    this.panNumber,
    this.tanNumber,
    this.certificates,
    this.annualReports,
    this.ownerName,
    this.mission,
    this.vision,
    this.targetCommunities,
    this.projectTypes,
    this.financialReports,
    this.fundingSources,
    this.expenseBreakdown,
    this.auditReports,
    this.boardMembers,
    this.governanceStructure,
    this.projects,
    this.testimonials,
    this.impactMetrics,
    this.partnerships,
    this.reviews,
    this.rating,
    this.mediaMentions,
    this.website,
    this.email,
    this.phone,
    this.address,
    this.socialMedia,
    this.bankName,
    this.bankAccountNumber,
    this.ifscCode,
  });

  /// Create an NGO from a Firestore document map.
  /// Only deserializes the core fields; nested objects are not yet stored.
  factory NGO.fromJson(Map<String, dynamic> json) {
    return NGO(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      logoUrl: json['logoUrl'] as String? ?? '',
      members: json['members'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      registrationNumber: json['registrationNumber'] as String?,
      fcraNumber: json['fcraNumber'] as String?,
      darpanNumber: json['darpanNumber'] as String?,
      legalStatus: json['legalStatus'] as String?,
      panNumber: json['panNumber'] as String?,
      tanNumber: json['tanNumber'] as String?,
      ownerName: json['ownerName'] as String?,
      mission: json['mission'] as String?,
      vision: json['vision'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      bankName: json['bankName'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      ifscCode: json['ifscCode'] as String?,
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      targetCommunities: (json['targetCommunities'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      projectTypes: (json['projectTypes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      fundingSources: (json['fundingSources'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      testimonials: (json['testimonials'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      mediaMentions: (json['mediaMentions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      socialMedia: (json['socialMedia'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'logoUrl': logoUrl,
      'members': members,
      'followers': followers,
      if (registrationNumber != null) 'registrationNumber': registrationNumber,
      if (fcraNumber != null) 'fcraNumber': fcraNumber,
      if (darpanNumber != null) 'darpanNumber': darpanNumber,
      if (legalStatus != null) 'legalStatus': legalStatus,
      if (ownerName != null) 'ownerName': ownerName,
      if (panNumber != null) 'panNumber': panNumber,
      if (tanNumber != null) 'tanNumber': tanNumber,
      if (mission != null) 'mission': mission,
      if (vision != null) 'vision': vision,
      if (website != null) 'website': website,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (rating != null) 'rating': rating,
      if (bankName != null) 'bankName': bankName,
      if (bankAccountNumber != null) 'bankAccountNumber': bankAccountNumber,
      if (ifscCode != null) 'ifscCode': ifscCode,
      if (certificates != null) 'certificates': certificates,
      if (targetCommunities != null) 'targetCommunities': targetCommunities,
      if (projectTypes != null) 'projectTypes': projectTypes,
      if (fundingSources != null) 'fundingSources': fundingSources,
      if (testimonials != null) 'testimonials': testimonials,
      if (mediaMentions != null) 'mediaMentions': mediaMentions,
      if (socialMedia != null) 'socialMedia': socialMedia,
    };
  }
}

class AnnualReport {
  final String year;
  final String reportUrl;
  final String title;

  AnnualReport({
    required this.year,
    required this.reportUrl,
    required this.title,
  });
}

class FinancialReport {
  final String year;
  final double totalRevenue;
  final double totalExpenses;
  final String reportUrl;

  FinancialReport({
    required this.year,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.reportUrl,
  });
}

class ExpenseBreakdown {
  final double programCosts;
  final double adminCosts;
  final double fundraisingCosts;

  ExpenseBreakdown({
    required this.programCosts,
    required this.adminCosts,
    required this.fundraisingCosts,
  });

  double get programPercentage =>
      (programCosts / (programCosts + adminCosts + fundraisingCosts)) * 100;
  double get adminPercentage =>
      (adminCosts / (programCosts + adminCosts + fundraisingCosts)) * 100;
  double get fundraisingPercentage =>
      (fundraisingCosts / (programCosts + adminCosts + fundraisingCosts)) * 100;
}

class BoardMember {
  final String name;
  final String position;
  final String background;
  final String? photoUrl;

  BoardMember({
    required this.name,
    required this.position,
    required this.background,
    this.photoUrl,
  });
}

class Project {
  final String title;
  final String description;
  final List<String> photos;
  final String status;
  final String? outcome;
  final DateTime startDate;
  final DateTime? endDate;

  Project({
    required this.title,
    required this.description,
    required this.photos,
    required this.status,
    this.outcome,
    required this.startDate,
    this.endDate,
  });
}

class ImpactMetrics {
  final int beneficiariesReached;
  final int projectsCompleted;
  final int communitiesServed;
  final Map<String, dynamic>? customMetrics;

  ImpactMetrics({
    required this.beneficiariesReached,
    required this.projectsCompleted,
    required this.communitiesServed,
    this.customMetrics,
  });
}

class Partnership {
  final String organizationName;
  final String description;
  final String? logoUrl;

  Partnership({
    required this.organizationName,
    required this.description,
    this.logoUrl,
  });
}

class Review {
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

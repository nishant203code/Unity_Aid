class NGO {
  final String name;
  final String description;
  final String location;
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

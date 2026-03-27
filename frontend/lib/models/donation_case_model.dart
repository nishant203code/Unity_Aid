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
}

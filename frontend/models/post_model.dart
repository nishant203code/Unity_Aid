enum VerificationStatus {
  verified,
  falseCase,
  pending,
}

class Post {
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

  Post({
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
  });
}

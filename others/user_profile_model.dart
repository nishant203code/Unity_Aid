/// User Profile Model for Recommendation System
/// Contains user demographic, behavioral, and preference data

class BehavioralFeatures {
  /// Number of items viewed by the user
  final int itemsViewed;

  /// Number of items clicked by the user
  final int itemsClicked;

  /// List of case IDs in user's purchase/donation history
  final List<String> purchaseHistory;

  /// Ratings given by user (case_id to rating map)
  final Map<String, double> ratingsGiven;

  /// Total watch time in seconds for videos
  final int watchTimeSeconds;

  /// Number of sessions in a given period
  final int sessionFrequency;

  /// Average items viewed per session
  double get averageItemsPerSession =>
      sessionFrequency > 0 ? itemsViewed / sessionFrequency : 0;

  /// Click-through rate
  double get clickThroughRate =>
      itemsViewed > 0 ? itemsClicked / itemsViewed : 0;

  /// Average rating given
  double get averageRating {
    if (ratingsGiven.isEmpty) return 0;
    final sum = ratingsGiven.values.fold<double>(0, (a, b) => a + b);
    return sum / ratingsGiven.length;
  }

  BehavioralFeatures({
    required this.itemsViewed,
    required this.itemsClicked,
    required this.purchaseHistory,
    required this.ratingsGiven,
    required this.watchTimeSeconds,
    required this.sessionFrequency,
  });

  factory BehavioralFeatures.empty() {
    return BehavioralFeatures(
      itemsViewed: 0,
      itemsClicked: 0,
      purchaseHistory: [],
      ratingsGiven: {},
      watchTimeSeconds: 0,
      sessionFrequency: 0,
    );
  }

  BehavioralFeatures copyWith({
    int? itemsViewed,
    int? itemsClicked,
    List<String>? purchaseHistory,
    Map<String, double>? ratingsGiven,
    int? watchTimeSeconds,
    int? sessionFrequency,
  }) {
    return BehavioralFeatures(
      itemsViewed: itemsViewed ?? this.itemsViewed,
      itemsClicked: itemsClicked ?? this.itemsClicked,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
      ratingsGiven: ratingsGiven ?? this.ratingsGiven,
      watchTimeSeconds: watchTimeSeconds ?? this.watchTimeSeconds,
      sessionFrequency: sessionFrequency ?? this.sessionFrequency,
    );
  }
}

class UserProfile {
  /// Unique user identifier
  final String userId;

  /// User age in years
  final int age;

  /// User gender (male, female, other)
  final String gender;

  /// User's city/region
  final String location;

  /// User's occupation
  final String occupation;

  /// Total amount donated in rupees
  final double fundsDonated;

  /// IDs of NGO types the user has joined
  final List<String> ngoTypesJoined;

  /// Behavioral and engagement features
  final BehavioralFeatures behavioralFeatures;

  /// User's preferences/interests
  final List<String> interests;

  /// Account creation timestamp (Unix milliseconds)
  final int createdAtMs;

  /// Last activity timestamp (Unix milliseconds)
  final int lastActivityMs;

  /// Average engagement score (0-100)
  double get engagementScore {
    final ctr = behavioralFeatures.clickThroughRate;
    final frequency = (behavioralFeatures.sessionFrequency / 30).clamp(0, 1);
    return ((ctr * 50) + (frequency * 50)).clamp(0, 100);
  }

  /// Donation tier based on funds donated
  String get donationTier {
    if (fundsDonated >= 100000) return 'platinum';
    if (fundsDonated >= 50000) return 'gold';
    if (fundsDonated >= 10000) return 'silver';
    if (fundsDonated > 0) return 'bronze';
    return 'none';
  }

  /// Account age in days
  int get accountAgeDays {
    final now = DateTime.now().millisecondsSinceEpoch;
    return ((now - createdAtMs) / (1000 * 60 * 60 * 24)).toInt();
  }

  UserProfile({
    required this.userId,
    required this.age,
    required this.gender,
    required this.location,
    required this.occupation,
    required this.fundsDonated,
    required this.ngoTypesJoined,
    required this.behavioralFeatures,
    required this.interests,
    required this.createdAtMs,
    required this.lastActivityMs,
  });

  factory UserProfile.empty(String userId) {
    return UserProfile(
      userId: userId,
      age: 25,
      gender: 'other',
      location: 'Unknown',
      occupation: 'Unknown',
      fundsDonated: 0,
      ngoTypesJoined: [],
      behavioralFeatures: BehavioralFeatures.empty(),
      interests: [],
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
      lastActivityMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  UserProfile copyWith({
    String? userId,
    int? age,
    String? gender,
    String? location,
    String? occupation,
    double? fundsDonated,
    List<String>? ngoTypesJoined,
    BehavioralFeatures? behavioralFeatures,
    List<String>? interests,
    int? createdAtMs,
    int? lastActivityMs,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      occupation: occupation ?? this.occupation,
      fundsDonated: fundsDonated ?? this.fundsDonated,
      ngoTypesJoined: ngoTypesJoined ?? this.ngoTypesJoined,
      behavioralFeatures: behavioralFeatures ?? this.behavioralFeatures,
      interests: interests ?? this.interests,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      lastActivityMs: lastActivityMs ?? this.lastActivityMs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'age': age,
      'gender': gender,
      'location': location,
      'occupation': occupation,
      'fundsDonated': fundsDonated,
      'ngoTypesJoined': ngoTypesJoined,
      'interests': interests,
      'createdAtMs': createdAtMs,
      'lastActivityMs': lastActivityMs,
      'behavioralFeatures': {
        'itemsViewed': behavioralFeatures.itemsViewed,
        'itemsClicked': behavioralFeatures.itemsClicked,
        'purchaseHistory': behavioralFeatures.purchaseHistory,
        'watchTimeSeconds': behavioralFeatures.watchTimeSeconds,
        'sessionFrequency': behavioralFeatures.sessionFrequency,
      },
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      age: json['age'] ?? 25,
      gender: json['gender'] ?? 'other',
      location: json['location'] ?? 'Unknown',
      occupation: json['occupation'] ?? 'Unknown',
      fundsDonated: (json['fundsDonated'] ?? 0).toDouble(),
      ngoTypesJoined: List<String>.from(json['ngoTypesJoined'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      createdAtMs: json['createdAtMs'] ?? DateTime.now().millisecondsSinceEpoch,
      lastActivityMs: json['lastActivityMs'] ?? DateTime.now().millisecondsSinceEpoch,
      behavioralFeatures: BehavioralFeatures(
        itemsViewed: json['behavioralFeatures']?['itemsViewed'] ?? 0,
        itemsClicked: json['behavioralFeatures']?['itemsClicked'] ?? 0,
        purchaseHistory: List<String>.from(json['behavioralFeatures']?['purchaseHistory'] ?? []),
        ratingsGiven: {},
        watchTimeSeconds: json['behavioralFeatures']?['watchTimeSeconds'] ?? 0,
        sessionFrequency: json['behavioralFeatures']?['sessionFrequency'] ?? 0,
      ),
    );
  }
}

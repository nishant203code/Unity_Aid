/// Item Profile Model for Recommendation System
/// Represents a case/donation item with all its features

class CoreFeatures {
  final String caseId;
  final String caseType; // "personal" | "social"
  final String causeCategory;

  CoreFeatures({
    required this.caseId,
    required this.caseType,
    required this.causeCategory,
  });

  Map<String, dynamic> toJson() => {
    'caseId': caseId,
    'caseType': caseType,
    'causeCategory': causeCategory,
  };

  factory CoreFeatures.fromJson(Map<String, dynamic> json) {
    return CoreFeatures(
      caseId: json['caseId'] ?? '',
      caseType: json['caseType'] ?? 'personal',
      causeCategory: json['causeCategory'] ?? 'others',
    );
  }
}

class TextFeatures {
  final String title;
  final String description;
  final String extraDetails;
  final List<double> textEmbedding;

  TextFeatures({
    required this.title,
    required this.description,
    required this.extraDetails,
    required this.textEmbedding,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'extraDetails': extraDetails,
    'textEmbedding': textEmbedding,
  };

  factory TextFeatures.fromJson(Map<String, dynamic> json) {
    return TextFeatures(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      extraDetails: json['extraDetails'] ?? '',
      textEmbedding: List<double>.from(json['textEmbedding'] ?? []),
    );
  }
}

class LocationFeatures {
  final String city;
  final String state;
  final String country;
  final double latitude;
  final double longitude;

  LocationFeatures({
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  /// Calculate distance between two coordinates using Haversine formula
  double distanceTo(double lat, double lon) {
    const earthRadius = 6371; // kilometers
    final dLat = _degreesToRadians(lat - latitude);
    final dLon = _degreesToRadians(lon - longitude);
    final a = (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
        (Math.cos(_degreesToRadians(latitude)) *
            Math.cos(_degreesToRadians(lat)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2));
    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * Math.pi / 180;
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'state': state,
    'country': country,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory LocationFeatures.fromJson(Map<String, dynamic> json) {
    return LocationFeatures(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? 'India',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}

class FinancialFeatures {
  final double fundGoal;
  final double fundGoalNormalized;
  final double fundsRaised;
  final double fundsRaisedRatio;
  final double minimumDonation;

  FinancialFeatures({
    required this.fundGoal,
    required this.fundGoalNormalized,
    required this.fundsRaised,
    required this.fundsRaisedRatio,
    required this.minimumDonation,
  });

  /// Funding progress percentage (0-100)
  double get fundingProgress => (fundsRaisedRatio * 100).clamp(0, 100);

  /// Amount remaining to reach goal
  double get amountRemaining => (fundGoal - fundsRaised).clamp(0, fundGoal);

  Map<String, dynamic> toJson() => {
    'fundGoal': fundGoal,
    'fundGoalNormalized': fundGoalNormalized,
    'fundsRaised': fundsRaised,
    'fundsRaisedRatio': fundsRaisedRatio,
    'minimumDonation': minimumDonation,
  };

  factory FinancialFeatures.fromJson(Map<String, dynamic> json) {
    return FinancialFeatures(
      fundGoal: (json['fundGoal'] ?? 0).toDouble(),
      fundGoalNormalized: (json['fundGoalNormalized'] ?? 0).toDouble(),
      fundsRaised: (json['fundsRaised'] ?? 0).toDouble(),
      fundsRaisedRatio: (json['fundsRaisedRatio'] ?? 0).toDouble(),
      minimumDonation: (json['minimumDonation'] ?? 0).toDouble(),
    );
  }
}

class EngagementFeatures {
  final int views;
  final int clicks;
  final int donationsCount;
  final double popularityScore;
  final double trendingScore;

  EngagementFeatures({
    required this.views,
    required this.clicks,
    required this.donationsCount,
    required this.popularityScore,
    required this.trendingScore,
  });

  /// Click-through rate
  double get clickThroughRate => views > 0 ? clicks / views : 0;

  /// Conversion rate (donations per click)
  double get conversionRate => clicks > 0 ? donationsCount / clicks : 0;

  Map<String, dynamic> toJson() => {
    'views': views,
    'clicks': clicks,
    'donationsCount': donationsCount,
    'popularityScore': popularityScore,
    'trendingScore': trendingScore,
  };

  factory EngagementFeatures.fromJson(Map<String, dynamic> json) {
    return EngagementFeatures(
      views: json['views'] ?? 0,
      clicks: json['clicks'] ?? 0,
      donationsCount: json['donationsCount'] ?? 0,
      popularityScore: (json['popularityScore'] ?? 0).toDouble(),
      trendingScore: (json['trendingScore'] ?? 0).toDouble(),
    );
  }
}

class PersonalCaseFeatures {
  final int victimAge;
  final String victimGender;
  final String victimBackground;

  PersonalCaseFeatures({
    required this.victimAge,
    required this.victimGender,
    required this.victimBackground,
  });

  Map<String, dynamic> toJson() => {
    'victimAge': victimAge,
    'victimGender': victimGender,
    'victimBackground': victimBackground,
  };

  factory PersonalCaseFeatures.fromJson(Map<String, dynamic> json) {
    return PersonalCaseFeatures(
      victimAge: json['victimAge'] ?? 0,
      victimGender: json['victimGender'] ?? 'other',
      victimBackground: json['victimBackground'] ?? '',
    );
  }
}

class DerivedFeatures {
  final double urgencyScore;
  final double severityScore;
  final int timeLeftDays;
  final bool isCritical;

  DerivedFeatures({
    required this.urgencyScore,
    required this.severityScore,
    required this.timeLeftDays,
    required this.isCritical,
  });

  Map<String, dynamic> toJson() => {
    'urgencyScore': urgencyScore,
    'severityScore': severityScore,
    'timeLeftDays': timeLeftDays,
    'isCritical': isCritical,
  };

  factory DerivedFeatures.fromJson(Map<String, dynamic> json) {
    return DerivedFeatures(
      urgencyScore: (json['urgencyScore'] ?? 0).toDouble(),
      severityScore: (json['severityScore'] ?? 0).toDouble(),
      timeLeftDays: json['timeLeftDays'] ?? 0,
      isCritical: json['isCritical'] ?? false,
    );
  }
}

class ItemProfile {
  final CoreFeatures core;
  final TextFeatures textFeatures;
  final LocationFeatures locationFeatures;
  final FinancialFeatures financialFeatures;
  final EngagementFeatures engagementFeatures;
  final PersonalCaseFeatures? personalCaseFeatures;
  final DerivedFeatures derivedFeatures;

  ItemProfile({
    required this.core,
    required this.textFeatures,
    required this.locationFeatures,
    required this.financialFeatures,
    required this.engagementFeatures,
    required this.personalCaseFeatures,
    required this.derivedFeatures,
  });

  /// Quality score based on various factors
  double get qualityScore {
    final popularity = (engagementFeatures.popularityScore / 100).clamp(0, 1);
    final engagement = engagementFeatures.conversionRate.clamp(0, 1);
    final urgency = (derivedFeatures.urgencyScore / 100).clamp(0, 1);
    return ((popularity * 0.3) + (engagement * 0.4) + (urgency * 0.3)) * 100;
  }

  factory ItemProfile.empty() {
    return ItemProfile(
      core: CoreFeatures(
        caseId: '',
        caseType: 'personal',
        causeCategory: 'others',
      ),
      textFeatures: TextFeatures(
        title: '',
        description: '',
        extraDetails: '',
        textEmbedding: [],
      ),
      locationFeatures: LocationFeatures(
        city: '',
        state: '',
        country: 'India',
        latitude: 0,
        longitude: 0,
      ),
      financialFeatures: FinancialFeatures(
        fundGoal: 0,
        fundGoalNormalized: 0,
        fundsRaised: 0,
        fundsRaisedRatio: 0,
        minimumDonation: 0,
      ),
      engagementFeatures: EngagementFeatures(
        views: 0,
        clicks: 0,
        donationsCount: 0,
        popularityScore: 0,
        trendingScore: 0,
      ),
      personalCaseFeatures: null,
      derivedFeatures: DerivedFeatures(
        urgencyScore: 0,
        severityScore: 0,
        timeLeftDays: 0,
        isCritical: false,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'item_features': {
      'core': core.toJson(),
      'text_features': textFeatures.toJson(),
      'location_features': locationFeatures.toJson(),
      'financial_features': financialFeatures.toJson(),
      'engagement_features': engagementFeatures.toJson(),
      'personal_case_features': personalCaseFeatures?.toJson(),
      'derived_features': derivedFeatures.toJson(),
    },
  };

  factory ItemProfile.fromJson(Map<String, dynamic> json) {
    final features = json['item_features'] ?? json;
    
    return ItemProfile(
      core: CoreFeatures.fromJson(features['core'] ?? {}),
      textFeatures:
          TextFeatures.fromJson(features['text_features'] ?? {}),
      locationFeatures:
          LocationFeatures.fromJson(features['location_features'] ?? {}),
      financialFeatures:
          FinancialFeatures.fromJson(features['financial_features'] ?? {}),
      engagementFeatures:
          EngagementFeatures.fromJson(features['engagement_features'] ?? {}),
      personalCaseFeatures:
          features['personal_case_features'] != null
              ? PersonalCaseFeatures.fromJson(
                  features['personal_case_features'])
              : null,
      derivedFeatures:
          DerivedFeatures.fromJson(features['derived_features'] ?? {}),
    );
  }
}

// Math utilities
class Math {
  static const double pi = 3.14159265359;
  static double sin(double x) => _sin(x);
  static double cos(double x) => _cos(x);
  static double atan2(double y, double x) => _atan2(y, x);
  static double sqrt(double x) => _sqrt(x);

  static double _sin(double x) {
    x = x % (2 * pi);
    return _sinTaylor(x);
  }

  static double _cos(double x) {
    x = x % (2 * pi);
    return _cosTaylor(x);
  }

  static double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + pi;
    if (x < 0 && y < 0) return _atan(y / x) - pi;
    if (x == 0 && y > 0) return pi / 2;
    if (x == 0 && y < 0) return -pi / 2;
    return 0;
  }

  static double _sqrt(double x) {
    if (x < 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  static double _sin(double x) {
    return _sinTaylor(x);
  }

  static double _sinTaylor(double x) {
    double result = 0;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      result += term;
      term *= -x * x / ((2 * i) * (2 * i + 1));
    }
    return result;
  }

  static double _cosTaylor(double x) {
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _atan(double x) {
    double result = 0;
    double term = x;
    for (int i = 1; i <= 100; i++) {
      result += term;
      term *= -x * x * (2 * i - 1) / (2 * i + 1);
    }
    return result;
  }
}

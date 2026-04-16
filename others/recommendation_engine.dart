/// Recommendation Engine
/// Scores and ranks items based on user preferences and features

import 'user_profile_model.dart';
import 'item_profile_model.dart';

class RecommendationScore {
  final String itemId;
  final double score;
  final Map<String, double> componentScores;
  final String reason;

  RecommendationScore({
    required this.itemId,
    required this.score,
    required this.componentScores,
    required this.reason,
  });

  @override
  String toString() => 'Score: $score, Item: $itemId, Reason: $reason';
}

class RecommendationEngine {
  /// Weight configuration for different scoring components
  final Map<String, double> weights = {
    'engagement': 0.15,
    'urgency': 0.20,
    'location_proximity': 0.15,
    'cause_category_match': 0.20,
    'financial_alignment': 0.15,
    'user_behavior_match': 0.15,
  };

  /// Score a single item for a user
  RecommendationScore scoreItem(UserProfile user, ItemProfile item) {
    final componentScores = <String, double>{};

    // Calculate individual component scores
    componentScores['engagement'] = _scoreEngagement(item) * weights['engagement']!;
    componentScores['urgency'] = _scoreUrgency(item) * weights['urgency']!;
    componentScores['location_proximity'] = _scoreLocationProximity(user, item) *
        weights['location_proximity']!;
    componentScores['cause_category_match'] =
        _scoreCauseCategoryMatch(user, item) *
            weights['cause_category_match']!;
    componentScores['financial_alignment'] =
        _scoreFinancialAlignment(user, item) *
            weights['financial_alignment']!;
    componentScores['user_behavior_match'] =
        _scoreUserBehaviorMatch(user, item) *
            weights['user_behavior_match']!;

    // Calculate total score
    final totalScore = componentScores.values.fold<double>(
      0,
      (sum, score) => sum + score,
    );

    // Generate reason
    final topComponent = _getTopComponent(componentScores);
    final reason = _generateReason(user, item, topComponent);

    return RecommendationScore(
      itemId: item.core.caseId,
      score: totalScore.clamp(0, 100),
      componentScores: componentScores,
      reason: reason,
    );
  }

  /// Score list of items and return sorted recommendations
  List<RecommendationScore> recommendItems(
    UserProfile user,
    List<ItemProfile> items, {
    int topN = 10,
  }) {
    final scores = items
        .map((item) => scoreItem(user, item))
        .toList();

    // Sort by score descending
    scores.sort((a, b) => b.score.compareTo(a.score));

    return scores.take(topN).toList();
  }

  // Component scoring functions

  /// Score based on item engagement metrics
  double _scoreEngagement(ItemProfile item) {
    final engagement = item.engagementFeatures;
    final ctr = engagement.clickThroughRate.clamp(0, 0.5) * 2;
    final popularity = (engagement.popularityScore / 100).clamp(0, 1);
    final trending = (engagement.trendingScore / 100).clamp(0, 1);

    return ((ctr * 0.3) + (popularity * 0.4) + (trending * 0.3)) * 100;
  }

  /// Score based on item urgency
  double _scoreUrgency(ItemProfile item) {
    final derived = item.derivedFeatures;
    final urgency = (derived.urgencyScore / 100).clamp(0, 1);
    final severity = (derived.severityScore / 100).clamp(0, 1);
    final criticalBoost = derived.isCritical ? 1.2 : 1.0;

    return ((urgency * 0.5) + (severity * 0.5)) * 100 * criticalBoost;
  }

  /// Score based on location proximity
  double _scoreLocationProximity(UserProfile user, ItemProfile item) {
    // If user location is same as item, high score
    if (user.location.toLowerCase() ==
        item.locationFeatures.city.toLowerCase()) {
      return 100;
    }

    // If same state, medium-high score
    if (user.location.toLowerCase() ==
        item.locationFeatures.state.toLowerCase()) {
      return 75;
    }

    // If same country, medium score
    if (item.locationFeatures.country.toLowerCase() == 'india') {
      return 50;
    }

    return 25;
  }

  /// Score based on cause category match with user's NGO interests
  double _scoreCauseCategoryMatch(UserProfile user, ItemProfile item) {
    // Direct category match in interests
    if (user.interests.contains(item.core.causeCategory)) {
      return 100;
    }

    // Check if user has joined related NGOs
    final categoryNGOMap = {
      'healthcare': ['medical', 'health', 'hospital'],
      'education': ['school', 'education', 'learning'],
      'disaster_relief': ['disaster', 'relief', 'emergency'],
      'animal_welfare': ['animal', 'pet', 'wildlife'],
      'women_empowerment': ['women', 'girls', 'female'],
    };

    final relatedNGOs = categoryNGOMap[item.core.causeCategory] ?? [];
    final matchedNGOs =
        user.ngoTypesJoined.where((ngo) => relatedNGOs.contains(ngo)).length;

    if (matchedNGOs > 0) {
      return 75 + (matchedNGOs * 5).toDouble();
    }

    return 25;
  }

  /// Score based on financial alignment
  double _scoreFinancialAlignment(UserProfile user, ItemProfile item) {
    final financial = item.financialFeatures;
    
    // Check if item funding is within user's typical donation range
    final avgUserDonation = user.fundsDonated / (user.behavioralFeatures.purchaseHistory.length + 1);
    
    // Items requiring user's typical donation amount score higher
    if (financial.minimumDonation > 0) {
      final ratio = avgUserDonation / financial.minimumDonation;
      if (ratio >= 0.5 && ratio <= 2.0) {
        return 100;
      }
      if (ratio >= 0.25 && ratio <= 4.0) {
        return 75;
      }
    }

    // Items near completion score higher for motivated users
    if (user.donationTier != 'none' &&
        financial.fundsRaisedRatio > 0.8 &&
        financial.fundsRaisedRatio < 1.0) {
      return 80;
    }

    // Items with clear financial goals score well
    if (financial.fundGoal > 0 && financial.amountRemaining > 0) {
      return 70;
    }

    return 50;
  }

  /// Score based on user behavior match
  double _scoreUserBehaviorMatch(UserProfile user, ItemProfile item) {
    final behavior = user.behavioralFeatures;

    // Users who engage more should see trending items
    if (behavior.clickThroughRate > 0.1) {
      return ((item.engagementFeatures.trendingScore / 100) * 100)
          .clamp(0, 100);
    }

    // Users who have high watch time should see detailed items
    if (behavior.watchTimeSeconds > 3600) {
      final textLength = item.textFeatures.description.length;
      return ((textLength / 1000).clamp(0, 1)) * 100;
    }

    // Users who rate frequently should see high-quality items
    if (behavior.averageRating > 3.5) {
      return item.qualityScore;
    }

    // New users should see popular/safe items
    if (user.accountAgeDays < 30) {
      return (item.engagementFeatures.popularityScore * 0.8) +
          (item.engagementFeatures.conversionRate.clamp(0, 1) * 20);
    }

    // Default for other users
    return 60;
  }

  // Utility functions

  /// Get the component with highest contribution
  String _getTopComponent(Map<String, double> componentScores) {
    var maxScore = 0.0;
    var topComponent = 'engagement';

    componentScores.forEach((component, score) {
      if (score > maxScore) {
        maxScore = score;
        topComponent = component;
      }
    });

    return topComponent;
  }

  /// Generate human-readable reason for recommendation
  String _generateReason(
    UserProfile user,
    ItemProfile item,
    String topComponent,
  ) {
    const reasons = {
      'engagement': 'Trending among donors',
      'urgency': 'Urgent case - immediate help needed',
      'location_proximity': 'Case in your region',
      'cause_category_match': 'Matches your interests',
      'financial_alignment': 'Suitable funding level',
      'user_behavior_match': 'Based on your activity',
    };

    return reasons[topComponent] ?? 'Recommended for you';
  }

  /// Diversify recommendations to avoid monotony
  List<RecommendationScore> diversifyRecommendations(
    List<RecommendationScore> scores, {
    required int maxSameCause,
    required int maxSameLocation,
  }) {
    final diversified = <RecommendationScore>[];
    final causeCount = <String, int>{};
    final locationCount = <String, int>{};

    for (final score in scores) {
      // Parse item features from score (would need item data here)
      // For now, just return as-is
      diversified.add(score);
    }

    return diversified;
  }

  /// Adjust scores based on user's recent activity
  List<RecommendationScore> applyRecencyBoost(
    List<RecommendationScore> scores,
    ItemProfile item, {
    double boostFactor = 1.2,
  }) {
    final boosted = scores.map((score) {
      // Boost recently updated items
      if (item.core.caseId == score.itemId) {
        return RecommendationScore(
          itemId: score.itemId,
          score: (score.score * boostFactor).clamp(0, 100),
          componentScores: score.componentScores,
          reason: '${score.reason} (Recently updated)',
        );
      }
      return score;
    }).toList();

    return boosted;
  }

  /// Apply collaborative filtering adjustment
  double applyCollaborativeFiltering(
    RecommendationScore score,
    List<UserProfile> similarUsers,
    ItemProfile item,
  ) {
    if (similarUsers.isEmpty) return score.score;

    // Users who liked this item before would influence others
    double boost = 0;
    for (final user in similarUsers) {
      if (user.behavioralFeatures.purchaseHistory.contains(item.core.caseId)) {
        boost += 5;
      }
    }

    return (score.score + boost).clamp(0, 100);
  }
}

/// Recommendation Service
/// High-level service for managing recommendations

import 'user_profile_model.dart';
import 'item_profile_model.dart';
import 'recommendation_engine.dart';

class RecommendationService {
  final RecommendationEngine engine = RecommendationEngine();
  final Map<String, List<RecommendationScore>> _cache = {};

  /// Get recommendations for a user
  Future<List<RecommendationScore>> getRecommendations({
    required UserProfile user,
    required List<ItemProfile> items,
    int topN = 10,
    bool useCache = true,
  }) async {
    // Check cache first
    final cacheKey = '${user.userId}_${items.length}';
    if (useCache && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Generate recommendations
    final recommendations = engine.recommendItems(
      user,
      items,
      topN: topN,
    );

    // Cache results
    _cache[cacheKey] = recommendations;

    return recommendations;
  }

  /// Get recommendations excluding already viewed items
  Future<List<RecommendationScore>> getNewRecommendations({
    required UserProfile user,
    required List<ItemProfile> items,
    int topN = 10,
  }) async {
    final viewed = user.behavioralFeatures.purchaseHistory.toSet();
    final unviewedItems = items
        .where((item) => !viewed.contains(item.core.caseId))
        .toList();

    return getRecommendations(
      user: user,
      items: unviewedItems,
      topN: topN,
      useCache: false,
    );
  }

  /// Get recommendations for similar cause category
  Future<List<RecommendationScore>> getSimilarCauseRecommendations({
    required UserProfile user,
    required List<ItemProfile> items,
    required String causeCategory,
    int topN = 5,
  }) async {
    final filteredItems = items
        .where((item) => item.core.causeCategory == causeCategory)
        .toList();

    return getRecommendations(
      user: user,
      items: filteredItems,
      topN: topN,
      useCache: false,
    );
  }

  /// Get trending recommendations
  Future<List<RecommendationScore>> getTrendingRecommendations({
    required UserProfile user,
    required List<ItemProfile> items,
    int topN = 10,
  }) async {
    // Sort by trending score
    final trendingItems = items
        .where((item) =>
            item.engagementFeatures.trendingScore >
            (item.engagementFeatures.trendingScore * 0.5)) // Top 50% trending
        .toList();

    return getRecommendations(
      user: user,
      items: trendingItems,
      topN: topN,
      useCache: false,
    );
  }

  /// Get urgent/critical recommendations
  Future<List<RecommendationScore>> getUrgentRecommendations({
    required UserProfile user,
    required List<ItemProfile> items,
    int topN = 5,
  }) async {
    // Filter only critical items
    final criticalItems = items
        .where((item) => item.derivedFeatures.isCritical)
        .toList();

    return getRecommendations(
      user: user,
      items: criticalItems,
      topN: topN,
      useCache: false,
    );
  }

  /// Get hyper-local recommendations
  Future<List<RecommendationScore>> getLocalRecommendations({
    required UserProfile user,
    required List<ItemProfile> items,
    int topN = 5,
  }) async {
    // Filter items in user's location
    final localItems = items
        .where((item) =>
            item.locationFeatures.city.toLowerCase() ==
            user.location.toLowerCase())
        .toList();

    if (localItems.isEmpty) {
      // Fall back to state level
      return getRecommendations(
        user: user,
        items: items,
        topN: topN,
        useCache: false,
      );
    }

    return getRecommendations(
      user: user,
      items: localItems,
      topN: topN,
      useCache: false,
    );
  }

  /// Get personalized recommendations based on user tier
  Future<List<RecommendationScore>> getPersonalizedByTier({
    required UserProfile user,
    required List<ItemProfile> items,
    int topN = 10,
  }) async {
    List<ItemProfile> filteredItems = items;

    // Premium users (platinum/gold) see high-urgency items
    if (user.donationTier == 'platinum' ||
        user.donationTier == 'gold') {
      filteredItems = items
          .where((item) =>
              item.derivedFeatures.urgencyScore > 60 ||
              item.engagementFeatures.trendingScore > 70)
          .toList();
    }
    // Active users (silver) see trending items
    else if (user.donationTier == 'silver') {
      filteredItems = items
          .where((item) => item.engagementFeatures.trendingScore > 50)
          .toList();
    }
    // New users see popular/safe items
    else if (user.accountAgeDays < 30) {
      filteredItems = items
          .where((item) => item.engagementFeatures.popularityScore > 60)
          .toList();
    }

    return getRecommendations(
      user: user,
      items: filteredItems,
      topN: topN,
      useCache: false,
    );
  }

  /// Clear recommendation cache
  void clearCache() => _cache.clear();

  /// Clear cache for specific user
  void clearUserCache(String userId) {
    _cache.removeWhere((key, _) => key.startsWith(userId));
  }

  /// Get recommendation statistics
  Map<String, dynamic> getRecommendationStats(
    List<RecommendationScore> recommendations,
  ) {
    if (recommendations.isEmpty) {
      return {
        'count': 0,
        'avgScore': 0,
        'maxScore': 0,
        'minScore': 0,
      };
    }

    final scores = recommendations.map((r) => r.score).toList();
    final avgScore = scores.reduce((a, b) => a + b) / scores.length;

    return {
      'count': recommendations.length,
      'avgScore': avgScore.toStringAsFixed(2),
      'maxScore': scores.reduce((a, b) => a > b ? a : b).toStringAsFixed(2),
      'minScore': scores.reduce((a, b) => a < b ? a : b).toStringAsFixed(2),
      'topScore': recommendations.first.score.toStringAsFixed(2),
    };
  }
}

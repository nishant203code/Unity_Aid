/// Example Usage and Test Cases
/// For UnityAid Recommendation System

import 'user_profile_model.dart';
import 'item_profile_model.dart';
import 'recommendation_engine.dart';
import 'recommendation_service.dart';

class RecommendationExamples {
  /// Create sample user for testing
  static UserProfile createSampleUser() {
    return UserProfile(
      userId: 'user_demo_001',
      age: 32,
      gender: 'female',
      location: 'Bangalore',
      occupation: 'Software Engineer',
      fundsDonated: 75000,
      ngoTypesJoined: ['healthcare', 'education', 'women_empowerment'],
      behavioralFeatures: BehavioralFeatures(
        itemsViewed: 128,
        itemsClicked: 34,
        purchaseHistory: ['case_001', 'case_005', 'case_012'],
        ratingsGiven: {
          'case_001': 4.5,
          'case_005': 4.0,
          'case_012': 5.0,
        },
        watchTimeSeconds: 7200, // 2 hours
        sessionFrequency: 15, // 15 sessions in period
      ),
      interests: ['healthcare', 'education', 'women_empowerment', 'disaster_relief'],
      createdAtMs: DateTime.now().subtract(const Duration(days: 180)).millisecondsSinceEpoch,
      lastActivityMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Create sample items for testing
  static List<ItemProfile> createSampleItems() {
    return [
      // Healthcare case
      ItemProfile(
        core: CoreFeatures(
          caseId: 'case_100',
          caseType: 'personal',
          causeCategory: 'healthcare',
        ),
        textFeatures: TextFeatures(
          title: 'Emergency Heart Surgery for 8-year-old Neha',
          description: 'Neha needs immediate open-heart surgery to survive congenital heart defect...',
          extraDetails: 'Parents are daily wage workers, already exhausted savings',
          textEmbedding: [0.12, 0.45, 0.78, 0.23, 0.56],
        ),
        locationFeatures: LocationFeatures(
          city: 'Bangalore',
          state: 'Karnataka',
          country: 'India',
          latitude: 12.9716,
          longitude: 77.5946,
        ),
        financialFeatures: FinancialFeatures(
          fundGoal: 500000,
          fundGoalNormalized: 0.5,
          fundsRaised: 320000,
          fundsRaisedRatio: 0.64,
          minimumDonation: 1000,
        ),
        engagementFeatures: EngagementFeatures(
          views: 1200,
          clicks: 180,
          donationsCount: 42,
          popularityScore: 78.5,
          trendingScore: 85.0,
        ),
        personalCaseFeatures: PersonalCaseFeatures(
          victimAge: 8,
          victimGender: 'female',
          victimBackground: 'Student, loves drawing',
        ),
        derivedFeatures: DerivedFeatures(
          urgencyScore: 95.0,
          severityScore: 92.0,
          timeLeftDays: 15,
          isCritical: true,
        ),
      ),

      // Education case
      ItemProfile(
        core: CoreFeatures(
          caseId: 'case_101',
          caseType: 'social',
          causeCategory: 'education',
        ),
        textFeatures: TextFeatures(
          title: 'Scholarship Fund for 100 Girls from Rural Areas',
          description: 'Help 100 girls from rural areas get quality education and break poverty cycle...',
          extraDetails: 'Partnership with local NGO, proven track record',
          textEmbedding: [0.34, 0.67, 0.12, 0.89, 0.45],
        ),
        locationFeatures: LocationFeatures(
          city: 'Pune',
          state: 'Maharashtra',
          country: 'India',
          latitude: 18.5204,
          longitude: 73.8567,
        ),
        financialFeatures: FinancialFeatures(
          fundGoal: 1000000,
          fundGoalNormalized: 1.0,
          fundsRaised: 450000,
          fundsRaisedRatio: 0.45,
          minimumDonation: 500,
        ),
        engagementFeatures: EngagementFeatures(
          views: 2100,
          clicks: 315,
          donationsCount: 89,
          popularityScore: 82.0,
          trendingScore: 72.0,
        ),
        personalCaseFeatures: null,
        derivedFeatures: DerivedFeatures(
          urgencyScore: 70.0,
          severityScore: 75.0,
          timeLeftDays: 90,
          isCritical: false,
        ),
      ),

      // Women empowerment case
      ItemProfile(
        core: CoreFeatures(
          caseId: 'case_102',
          caseType: 'social',
          causeCategory: 'women_empowerment',
        ),
        textFeatures: TextFeatures(
          title: 'Skill Training Center for Underprivileged Women',
          description: 'Provide vocational training to 50 women to become financially independent...',
          extraDetails: 'Job placement assistance included in program',
          textEmbedding: [0.56, 0.23, 0.89, 0.34, 0.67],
        ),
        locationFeatures: LocationFeatures(
          city: 'Mumbai',
          state: 'Maharashtra',
          country: 'India',
          latitude: 19.0760,
          longitude: 72.8777,
        ),
        financialFeatures: FinancialFeatures(
          fundGoal: 750000,
          fundGoalNormalized: 0.75,
          fundsRaised: 680000,
          fundsRaisedRatio: 0.91,
          minimumDonation: 2000,
        ),
        engagementFeatures: EngagementFeatures(
          views: 890,
          clicks: 134,
          donationsCount: 35,
          popularityScore: 71.5,
          trendingScore: 68.0,
        ),
        personalCaseFeatures: null,
        derivedFeatures: DerivedFeatures(
          urgencyScore: 65.0,
          severityScore: 70.0,
          timeLeftDays: 45,
          isCritical: false,
        ),
      ),

      // Disaster relief case
      ItemProfile(
        core: CoreFeatures(
          caseId: 'case_103',
          caseType: 'social',
          causeCategory: 'disaster_relief',
        ),
        textFeatures: TextFeatures(
          title: 'Emergency Relief for Flood Victims in Kerala',
          description: 'Immediate aid for 200 families affected by devastating floods...',
          extraDetails: 'Coordinated with local authorities, transparent fund usage',
          textEmbedding: [0.78, 0.34, 0.56, 0.12, 0.89],
        ),
        locationFeatures: LocationFeatures(
          city: 'Kochi',
          state: 'Kerala',
          country: 'India',
          latitude: 9.9312,
          longitude: 76.2673,
        ),
        financialFeatures: FinancialFeatures(
          fundGoal: 2000000,
          fundGoalNormalized: 2.0,
          fundsRaised: 1200000,
          fundsRaisedRatio: 0.6,
          minimumDonation: 100,
        ),
        engagementFeatures: EngagementFeatures(
          views: 5600,
          clicks: 784,
          donationsCount: 234,
          popularityScore: 92.0,
          trendingScore: 98.0,
        ),
        personalCaseFeatures: null,
        derivedFeatures: DerivedFeatures(
          urgencyScore: 98.0,
          severityScore: 95.0,
          timeLeftDays: 7,
          isCritical: true,
        ),
      ),
    ];
  }

  /// Test basic recommendation
  static void testBasicRecommendation() {
    print('\n=== Test 1: Basic Recommendation ===');
    
    final engine = RecommendationEngine();
    final user = createSampleUser();
    final items = createSampleItems();

    final recommendations = engine.recommendItems(user, items);

    print('User: ${user.userId} (Donation tier: ${user.donationTier})');
    print('Recommendations:');
    
    for (int i = 0; i < recommendations.length; i++) {
      final rec = recommendations[i];
      print('  ${i + 1}. ${rec.itemId}: ${rec.score.toStringAsFixed(2)} - ${rec.reason}');
    }
  }

  /// Test individual scoring components
  static void testComponentScoring() {
    print('\n=== Test 2: Component Scoring Breakdown ===');
    
    final engine = RecommendationEngine();
    final user = createSampleUser();
    final item = createSampleItems()[0]; // Healthcare case

    final score = engine.scoreItem(user, item);

    print('Item: ${score.itemId}');
    print('Total Score: ${score.score.toStringAsFixed(2)}');
    print('Component Breakdown:');
    
    score.componentScores.forEach((component, score) {
      print('  - $component: ${score.toStringAsFixed(2)}');
    });
  }

  /// Test service layer
  static Future<void> testServiceLayer() async {
    print('\n=== Test 3: Service Layer Usage ===');
    
    final service = RecommendationService();
    final user = createSampleUser();
    final items = createSampleItems();

    // Trending recommendations
    print('Trending Cases:');
    final trending = await service.getTrendingRecommendations(
      user: user,
      items: items,
      topN: 3,
    );
    
    for (final rec in trending) {
      print('  - ${rec.itemId}: ${rec.score.toStringAsFixed(2)}');
    }

    // Urgent recommendations
    print('\nUrgent Cases:');
    final urgent = await service.getUrgentRecommendations(
      user: user,
      items: items,
      topN: 3,
    );
    
    for (final rec in urgent) {
      print('  - ${rec.itemId}: ${rec.score.toStringAsFixed(2)}');
    }

    // Local recommendations
    print('\nLocal Cases:');
    final local = await service.getLocalRecommendations(
      user: user,
      items: items,
      topN: 3,
    );
    
    for (final rec in local) {
      print('  - ${rec.itemId}: ${rec.score.toStringAsFixed(2)}');
    }
  }

  /// Test statistics
  static void testStatistics() {
    print('\n=== Test 4: Recommendation Statistics ===');
    
    final engine = RecommendationEngine();
    final service = RecommendationService();
    final user = createSampleUser();
    final items = createSampleItems();

    final recommendations = engine.recommendItems(user, items);
    final stats = service.getRecommendationStats(recommendations);

    print('Statistics:');
    stats.forEach((key, value) {
      print('  - $key: $value');
    });
  }

  /// Run all tests
  static Future<void> runAllTests() async {
    print('🚀 UnityAid Recommendation System - Test Suite');
    print('=' * 50);
    
    testBasicRecommendation();
    testComponentScoring();
    await testServiceLayer();
    testStatistics();
    
    print('\n' + '=' * 50);
    print('✅ All tests completed!');
  }
}

// To run: 
// void main() async {
//   await RecommendationExamples.runAllTests();
// }

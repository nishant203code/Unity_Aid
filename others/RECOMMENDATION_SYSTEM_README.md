/// RECOMMENDATION SYSTEM DOCUMENTATION
/// ===================================
/// 
/// User-Item Collaborative Recommendation Engine for UnityAid
/// 
/// Overview:
/// --------
/// This recommendation system scores and ranks donation cases based on:
/// 1. User profile (demographics, behavior, interests)
/// 2. Item profile (case features, financial status, engagement)
/// 3. Weighted scoring algorithm combining multiple factors
///
/// Key Components:
/// ---------------
/// 1. user_profile_model.dart
///    - UserProfile: Demographic and behavioral data
///    - BehavioralFeatures: User engagement metrics
///
/// 2. item_profile_model.dart
///    - ItemProfile: Complete case feature set
///    - CoreFeatures: Case type and category
///    - TextFeatures: Title, description, embeddings
///    - LocationFeatures: Geographic information
///    - FinancialFeatures: Funding details
///    - EngagementFeatures: Popularity metrics
///    - PersonalCaseFeatures: Victim information
///    - DerivedFeatures: Calculated urgency/severity
///
/// 3. recommendation_engine.dart
///    - RecommendationEngine: Core scoring logic
///    - RecommendationScore: Score with breakdown
///
/// 4. recommendation_service.dart
///    - RecommendationService: High-level API
///    - Caching and filtering logic
///
/// Scoring Algorithm:
/// ------------------
/// Final Score = Σ(component_score × weight)
///
/// Components and Weights:
/// - Engagement Score (15%): CTR, popularity, trending
/// - Urgency Score (20%): Urgency and severity metrics
/// - Location Proximity (15%): Closeness to user's location
/// - Cause Category Match (20%): Alignment with user interests
/// - Financial Alignment (15%): Donation amount fit
/// - User Behavior Match (15%): History-based personalization
///
/// Usage Examples:
/// ---------------
/// 
/// Example 1: Basic Recommendation
/// --------------------------------
/// ```dart
/// final engine = RecommendationEngine();
/// 
/// // Create user and items
/// final user = UserProfile(
///   userId: 'user123',
///   age: 28,
///   gender: 'male',
///   location: 'Mumbai',
///   occupation: 'Engineer',
///   fundsDonated: 50000,
///   ngoTypesJoined: ['healthcare', 'education'],
///   behavioralFeatures: BehavioralFeatures(
///     itemsViewed: 45,
///     itemsClicked: 12,
///     purchaseHistory: ['case_001', 'case_002'],
///     ratingsGiven: {'case_001': 4.5, 'case_002': 4.0},
///     watchTimeSeconds: 3600,
///     sessionFrequency: 8,
///   ),
///   interests: ['healthcare', 'education'],
///   createdAtMs: DateTime.now().millisecondsSinceEpoch,
///   lastActivityMs: DateTime.now().millisecondsSinceEpoch,
/// );
/// 
/// // Get recommendations
/// final recommendations = engine.recommendItems(user, items, topN: 10);
/// 
/// // Print results
/// for (final rec in recommendations) {
///   print('${rec.itemId}: ${rec.score} - ${rec.reason}');
/// }
/// ```
///
/// Example 2: Using RecommendationService
/// ----------------------------------------
/// ```dart
/// final service = RecommendationService();
/// 
/// // Get trending recommendations
/// final trending = await service.getTrendingRecommendations(
///   user: user,
///   items: allItems,
///   topN: 5,
/// );
/// 
/// // Get local recommendations
/// final local = await service.getLocalRecommendations(
///   user: user,
///   items: allItems,
/// );
/// 
/// // Get personalized by user tier
/// final personalized = await service.getPersonalizedByTier(
///   user: user,
///   items: allItems,
///   topN: 10,
/// );
/// ```
///
/// Example 3: Filtering and Customization
/// ----------------------------------------
/// ```dart
/// // Get new items not viewed by user
/// final newRecs = await service.getNewRecommendations(
///   user: user,
///   items: items,
///   topN: 10,
/// );
/// 
/// // Get specific cause category
/// final healthcareRecs = await service.getSimilarCauseRecommendations(
///   user: user,
///   items: items,
///   causeCategory: 'healthcare',
///   topN: 5,
/// );
/// 
/// // Get urgent cases
/// final urgent = await service.getUrgentRecommendations(
///   user: user,
///   items: items,
///   topN: 5,
/// );
/// ```
///
/// Extended Features:
/// ------------------
/// 
/// 1. Diversity:
///    - Avoid recommending too many items from same cause
///    - Spread recommendations across locations
///    - Mix urgency levels for balanced recommendations
///
/// 2. Recency Boost:
///    - Recently updated items get score boost
///    - Critical items keep high scores
///
/// 3. Collaborative Filtering:
///    - Consider what similar users liked
///    - Boost scores for socially validated items
///
/// 4. Caching:
///    - Recommendations cached by user and item set
///    - Cache invalidation on user/item updates
///
/// Integration Points:
/// --------------------
/// 
/// Backend/Firestore:
/// - User profile data stored and synced
/// - Item features indexed for fast retrieval
/// - Interaction data logged for ML improvement
///
/// Frontend/UI:
/// - RecommendationService called on home/feed
/// - Results paginated and displayed
/// - User interactions tracked for feedback loop
///
/// ML/Analytics:
/// - Offline: Batch generate recommendations
/// - Real-time: Generate on-demand for active users
/// - A/B Testing: Compare algorithm versions
/// - Feedback: Track clicks/conversions for validation
///
/// Performance Optimization:
/// --------------------------
/// 
/// 1. Lazy Loading:
///    - Generate recommendations in batches
///    - Cache popular user-item pairs
///
/// 2. Feature Pre-computation:
///    - Calculate derived features offline
///    - Store embeddings in database
///
/// 3. Vectorization:
///    - Use text embeddings for semantic matching
///    - Enable similarity search
///
/// 4. Distributed Processing:
///    - Generate recommendations in background jobs
///    - Queue user requests for batch processing
///
/// Monitoring & Metrics:
/// ----------------------
/// 
/// Key metrics to track:
/// - Click-through rate (CTR) of recommendations
/// - Conversion rate (clicks to donations)
/// - Revenue per recommended item
/// - User satisfaction (ratings)
/// - Diversity metrics
/// - Cold start performance
///
/// Tuning Weights:
/// ----------------
/// 
/// Start with provided weights, then adjust based on:
/// - A/B test results
/// - User feedback
/// - Business objectives
/// - Metric performance
///
/// Example adjustment for high-engagement users:
/// ```dart
/// weights['engagement'] = 0.25;
/// weights['user_behavior_match'] = 0.20;
/// weights['urgency'] = 0.15;
/// ```
///
/// Future Enhancements:
/// --------------------
/// 
/// 1. Deep Learning:
///    - Neural collaborative filtering
///    - Transformer-based ranking
///
/// 2. Context-Aware:
///    - Time-of-day personalization
///    - Session-based recommendations
///
/// 3. Multi-Armed Bandit:
///    - Exploration vs exploitation
///    - Dynamic weight optimization
///
/// 4. Real-time Updates:
///    - Stream processing for engagement
///    - Live recommendation refresh
///
/// References:
/// -----------
/// - Collaborative Filtering: Koren et al.
/// - Matrix Factorization: Funk (Netflix Prize)
/// - Personalization: Amazon, Netflix approaches

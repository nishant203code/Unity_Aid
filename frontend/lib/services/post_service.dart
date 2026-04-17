import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post_model.dart';
import 'auth_service.dart';
import 'upload_service.dart';

/// Service for CRUD operations on the Firestore `posts` collection.
class PostService {
  static final _firestore = FirebaseFirestore.instance;
  static final _postsCollection = _firestore.collection('posts');

  // ─────────────────────────────────────────────
  //  CREATE
  // ─────────────────────────────────────────────

  /// Create a new post in Firestore with optional image uploads.
  ///
  /// 1. Uploads images via [UploadService]
  /// 2. Creates the post document in Firestore
  /// 3. Returns the created [Post] with its Firestore ID
  static Future<Post?> createPost({
    required String title,
    required String description,
    required String location,
    required double fundGoal,
    required String issueType,
    List<XFile> mediaFiles = const [],
    // Personal issue fields
    String? victimName,
    String? victimAge,
    String? victimGender,
    String? relation,
    String? victimBackground,
    // Social issue fields
    String? contactPerson,
    String? policeStation,
    String? socialIssueDetails,
  }) async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        debugPrint('PostService.createPost: not authenticated');
        return null;
      }

      // ── Upload images ──
      List<String> mediaUrls = [];
      if (mediaFiles.isNotEmpty) {
        final batchResult = await UploadService.uploadMultipleImages(
          files: mediaFiles,
          folder: 'posts',
        );
        mediaUrls = batchResult.urls;
        debugPrint('PostService: uploaded ${mediaUrls.length} images');
      }

      // ── Build post ──
      final post = Post(
        userName: user.displayName ?? 'Anonymous',
        profilePic: user.photoURL ?? '',
        location: location,
        mediaUrls: mediaUrls,
        caseTitle: title,
        caseId: '', // Will be set to doc ID
        description: description,
        raised: 0.0,
        goal: fundGoal,
        status: VerificationStatus.pending,
        createdBy: user.uid,
        creatorEmail: user.email ?? '',
        issueType: issueType,
        victimName: victimName,
        victimAge: victimAge,
        victimGender: victimGender,
        relation: relation,
        victimBackground: victimBackground,
        contactPerson: contactPerson,
        policeStation: policeStation,
        socialIssueDetails: socialIssueDetails,
      );

      // ── Write to Firestore ──
      final docRef = await _postsCollection.add(post.toFirestore());

      debugPrint('PostService: post created with ID ${docRef.id}');
      return Post(
        id: docRef.id,
        userName: post.userName,
        profilePic: post.profilePic,
        location: post.location,
        mediaUrls: post.mediaUrls,
        caseTitle: post.caseTitle,
        caseId: docRef.id,
        description: post.description,
        raised: post.raised,
        goal: post.goal,
        status: post.status,
        createdBy: post.createdBy,
        creatorEmail: post.creatorEmail,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('PostService.createPost error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  //  READ — Stream (real-time)
  // ─────────────────────────────────────────────

  /// Stream all posts, ordered by creation date (newest first).
  static Stream<List<Post>> getPostsStream() {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromJson(
                  doc.data(),
                  docId: doc.id,
                ))
            .toList());
  }

  // ─────────────────────────────────────────────
  //  READ — One-time fetch
  // ─────────────────────────────────────────────

  /// Fetch all posts once (not real-time).
  static Future<List<Post>> getPosts({int limit = 50}) async {
    try {
      final snapshot = await _postsCollection
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => Post.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      debugPrint('PostService.getPosts error: $e');
      return [];
    }
  }

  /// Fetch only verified/active posts.
  static Future<List<Post>> getVerifiedPosts({int limit = 50}) async {
    try {
      final snapshot = await _postsCollection
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => Post.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      debugPrint('PostService.getVerifiedPosts error: $e');
      return [];
    }
  }

  /// Fetch a single post by ID.
  static Future<Post?> getPostById(String postId) async {
    try {
      final doc = await _postsCollection.doc(postId).get();
      if (!doc.exists || doc.data() == null) return null;
      return Post.fromJson(doc.data()!, docId: doc.id);
    } catch (e) {
      debugPrint('PostService.getPostById error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  //  UPDATE
  // ─────────────────────────────────────────────

  /// Update the raised amount for a post (called after donation).
  static Future<void> updateRaisedAmount(String postId, double amount) async {
    try {
      await _postsCollection.doc(postId).update({
        'raised': FieldValue.increment(amount),
      });
    } catch (e) {
      debugPrint('PostService.updateRaisedAmount error: $e');
    }
  }
}

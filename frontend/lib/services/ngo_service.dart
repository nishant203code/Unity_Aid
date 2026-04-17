import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ngo_model.dart';
import 'auth_service.dart';

/// Service for NGO read/search and verification submission.
class NgoService {
  static final _firestore = FirebaseFirestore.instance;
  static final _ngosCollection = _firestore.collection('ngos');
  static final _verificationsCollection =
      _firestore.collection('ngo_verifications');

  // ─────────────────────────────────────────────
  //  SEARCH / READ
  // ─────────────────────────────────────────────

  /// Fetch all NGOs.
  static Future<List<NGO>> getNGOs({int limit = 50}) async {
    try {
      final snapshot = await _ngosCollection.limit(limit).get();
      return snapshot.docs
          .map((doc) => NGO.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('NgoService.getNGOs error: $e');
      return [];
    }
  }

  /// Search NGOs by name (case-insensitive prefix match).
  static Future<List<NGO>> searchNGOs({
    String? query,
    String? location,
    double? minMembers,
    double? minFollowers,
    int limit = 50,
  }) async {
    try {
      final snapshot = await _ngosCollection.limit(limit).get();

      // Client-side filtering (Firestore doesn't support case-insensitive search)
      var results = snapshot.docs
          .map((doc) => NGO.fromJson(doc.data()))
          .toList();

      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        results = results
            .where((ngo) => ngo.name.toLowerCase().contains(q))
            .toList();
      }

      if (location != null && location != 'Any') {
        results = results
            .where((ngo) => ngo.location == location)
            .toList();
      }

      if (minMembers != null && minMembers > 0) {
        results = results
            .where((ngo) => ngo.members >= minMembers)
            .toList();
      }

      if (minFollowers != null && minFollowers > 0) {
        results = results
            .where((ngo) => ngo.followers >= minFollowers)
            .toList();
      }

      return results;
    } catch (e) {
      debugPrint('NgoService.searchNGOs error: $e');
      return [];
    }
  }

  /// Stream all NGOs in real-time.
  static Stream<List<NGO>> getNGOsStream() {
    return _ngosCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => NGO.fromJson(doc.data())).toList());
  }

  // ─────────────────────────────────────────────
  //  VERIFICATION
  // ─────────────────────────────────────────────

  /// Submit an NGO verification request to Firestore.
  static Future<bool> submitVerification({
    required String ngoName,
    required String ownerName,
    required String darpanId,
    required String panNumber,
    required String gstin,
    required String mainAddress,
    required String branchAddress,
    required int peopleAssociated,
    required int casesHandled,
    required String caseHandlingType,
    required String bankAccountNumber,
    required String bankName,
    required String bankBranch,
    required String ifscCode,
    String? fcraId,
    bool isFcraRegistered = false,
  }) async {
    final user = AuthService.currentUser;
    if (user == null) {
      debugPrint('NgoService.submitVerification: not authenticated');
      return false;
    }

    try {
      await _verificationsCollection.add({
        'uid': user.uid,
        'ngoName': ngoName,
        'ownerName': ownerName,
        'darpanId': darpanId,
        'panNumber': panNumber,
        'gstin': gstin,
        'mainAddress': mainAddress,
        'branchAddress': branchAddress,
        'peopleAssociated': peopleAssociated,
        'casesHandled': casesHandled,
        'caseHandlingType': caseHandlingType,
        'bankAccountNumber': bankAccountNumber,
        'bankName': bankName,
        'bankBranch': bankBranch,
        'ifscCode': ifscCode,
        'isFcraRegistered': isFcraRegistered,
        if (fcraId != null) 'fcraId': fcraId,
        'status': 'pending',
        'submittedAt': FieldValue.serverTimestamp(),
        'email': user.email ?? '',
      });

      debugPrint('NgoService: verification submitted for $ngoName');
      return true;
    } catch (e) {
      debugPrint('NgoService.submitVerification error: $e');
      return false;
    }
  }
}

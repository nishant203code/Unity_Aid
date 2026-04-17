import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_case_model.dart';
import 'auth_service.dart';

/// Service for reading donation cases and recording donations.
class DonationService {
  static final _firestore = FirebaseFirestore.instance;
  static final _casesCollection = _firestore.collection('donation_cases');
  static final _donationsCollection = _firestore.collection('donations');

  // ─────────────────────────────────────────────
  //  READ — Donation Cases
  // ─────────────────────────────────────────────

  /// Fetch all donation cases, newest first.
  static Future<List<DonationCase>> getDonationCases({
    String? category,
    int limit = 50,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _casesCollection
          .orderBy('createdDate', descending: true)
          .limit(limit);

      if (category != null && category != 'All') {
        query = _casesCollection
            .where('category', isEqualTo: category)
            .orderBy('createdDate', descending: true)
            .limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => DonationCase.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      debugPrint('DonationService.getDonationCases error: $e');
      return [];
    }
  }

  /// Stream donation cases in real-time.
  static Stream<List<DonationCase>> getDonationCasesStream({
    String? category,
  }) {
    Query<Map<String, dynamic>> query =
        _casesCollection.orderBy('createdDate', descending: true);

    if (category != null && category != 'All') {
      query = _casesCollection
          .where('category', isEqualTo: category)
          .orderBy('createdDate', descending: true);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => DonationCase.fromJson(doc.data(), docId: doc.id))
        .toList());
  }

  /// Fetch a single donation case by ID.
  static Future<DonationCase?> getCaseById(String caseId) async {
    try {
      final doc = await _casesCollection.doc(caseId).get();
      if (!doc.exists || doc.data() == null) return null;
      return DonationCase.fromJson(doc.data()!, docId: doc.id);
    } catch (e) {
      debugPrint('DonationService.getCaseById error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  //  STATS
  // ─────────────────────────────────────────────

  /// Get aggregate donation stats for the current user.
  static Future<Map<String, dynamic>> getDonationStats() async {
    final user = AuthService.currentUser;
    if (user == null) {
      return {'totalDonated': 0.0, 'donationCount': 0};
    }

    try {
      final snapshot = await _donationsCollection
          .where('donorUid', isEqualTo: user.uid)
          .get();

      double total = 0;
      for (final doc in snapshot.docs) {
        total += (doc.data()['amount'] as num?)?.toDouble() ?? 0;
      }

      return {
        'totalDonated': total,
        'donationCount': snapshot.docs.length,
      };
    } catch (e) {
      debugPrint('DonationService.getDonationStats error: $e');
      return {'totalDonated': 0.0, 'donationCount': 0};
    }
  }

  // ─────────────────────────────────────────────
  //  RECORD DONATION
  // ─────────────────────────────────────────────

  /// Record a completed donation.
  /// Updates the case's raised amount and creates a donation record.
  static Future<bool> recordDonation({
    required String caseId,
    required double amount,
    required String paymentId,
    String? caseTitle,
  }) async {
    final user = AuthService.currentUser;
    if (user == null) return false;

    try {
      // Create donation record
      await _donationsCollection.add({
        'caseId': caseId,
        'caseTitle': caseTitle ?? '',
        'amount': amount,
        'paymentId': paymentId,
        'donorUid': user.uid,
        'donorName': user.displayName ?? 'Anonymous',
        'donorEmail': user.email ?? '',
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update case raised amount
      await _casesCollection.doc(caseId).update({
        'raisedAmount': FieldValue.increment(amount),
        'supportersCount': FieldValue.increment(1),
      });

      // Update user's total donated
      await _firestore.collection('users').doc(user.uid).update({
        'totalDonated': FieldValue.increment(amount),
      });

      debugPrint('DonationService: recorded donation of $amount for case $caseId');
      return true;
    } catch (e) {
      debugPrint('DonationService.recordDonation error: $e');
      return false;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _usersCollection = _firestore.collection('users');

  /// Check if a user profile document exists in Firestore
  static Future<bool> profileExists(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    return doc.exists;
  }

  /// Get user profile from Firestore
  static Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromJson(doc.data()!);
  }

  /// Save user profile to Firestore (creates or overwrites)
  static Future<void> saveUserProfile(String uid, UserModel user) async {
    await _usersCollection.doc(uid).set(user.toJson());
  }

  /// Update specific fields of user profile
  static Future<void> updateUserProfile(
      String uid, Map<String, dynamic> fields) async {
    await _usersCollection.doc(uid).update(fields);
  }

  /// Get just the role field from the user profile ('user' or 'ngo')
  static Future<String> getUserRole(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return 'user';
    return (doc.data()!['role'] as String?) ?? 'user';
  }
}

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ FIX: Added scopes (email + profile) and the Web client ID from
  //    google-services.json → oauth_client → client_type 3.
  //    Without serverClientId the idToken comes back null on Android,
  //    which makes signInWithCredential fail silently.
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '725657890800-q577hecm4ta9j2vr53ee9s3e9pai7sh9.apps.googleusercontent.com',
  );

  /// Get the currently logged-in user (null if not logged in)
  static User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes (logged in / logged out)
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─────────────────────────────────────────────
  //  EMAIL + PASSWORD
  // ─────────────────────────────────────────────

  /// Sign in with email & password
  static Future<UserCredential> signInWithEmail(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Create a new account with email & password
  static Future<UserCredential> signUpWithEmail(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Send password reset email
  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ─────────────────────────────────────────────
  //  GOOGLE SIGN-IN (v6 API) — FIXED
  // ─────────────────────────────────────────────

  /// Returns a [UserCredential] on success, `null` if user cancelled.
  /// Throws [FirebaseAuthException] for errors the UI should display.
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1️⃣ Show the Google sign-in popup
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User tapped the back / cancel button
      if (googleUser == null) {
        debugPrint('[AuthService] Google Sign-In: user cancelled.');
        return null;
      }

      // 2️⃣ Obtain auth tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // ✅ FIX: Validate that tokens were actually returned.
      //    When serverClientId is wrong or the SHA-1 doesn't match,
      //    idToken silently comes back null.
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        debugPrint(
            '[AuthService] Google Sign-In: tokens are null — check '
            'serverClientId and SHA-1 fingerprint in Firebase console.');
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Google token was empty. Please try again.',
        );
      }

      // 3️⃣ Build Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4️⃣ Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      debugPrint(
          '[AuthService] Google Sign-In success: ${userCredential.user?.email}');
      return userCredential;

    } on FirebaseAuthException catch (e) {
      // ✅ FIX: Propagate Firebase-specific errors so the UI can show
      //    the right message (token expired, account-exists, etc.)
      debugPrint('[AuthService] Google Sign-In FirebaseAuthException: '
          'code=${e.code}, message=${e.message}');
      rethrow;
    } catch (e) {
      // ✅ FIX: Catch platform / network errors and log them for debugging.
      //    Check for common Google Sign-In error strings.
      final errorStr = e.toString().toLowerCase();

      if (errorStr.contains('sign_in_canceled') ||
          errorStr.contains('canceled') ||
          errorStr.contains('cancelled')) {
        debugPrint('[AuthService] Google Sign-In: user cancelled (exception).');
        return null; // User cancelled — not an error
      }

      if (errorStr.contains('network_error') ||
          errorStr.contains('network')) {
        debugPrint('[AuthService] Google Sign-In: network error.');
        throw FirebaseAuthException(
          code: 'network-request-failed',
          message: 'Network error. Check your internet connection.',
        );
      }

      debugPrint('[AuthService] Google Sign-In unexpected error: $e');
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Google Sign-In failed. Please try again.',
      );
    }
  }

  // ─────────────────────────────────────────────
  //  PHONE OTP
  // ─────────────────────────────────────────────

  static Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    required Function(PhoneAuthCredential credential) onAutoVerified,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        onAutoVerified(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Phone verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout
      },
    );
  }

  /// Verify the OTP code entered by user
  static Future<UserCredential> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    return await _auth.signInWithCredential(credential);
  }

  // ─────────────────────────────────────────────
  //  SIGN OUT
  // ─────────────────────────────────────────────

  /// Sign out from all providers
  static Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      // Ignore if user didn't sign in with Google
    }
    await _auth.signOut();
  }

  // ─────────────────────────────────────────────
  //  ERROR MESSAGE HELPER
  // ─────────────────────────────────────────────

  static String getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak (min 8 characters)';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please try again';
      case 'session-expired':
        return 'OTP has expired. Please request a new one';
      // ✅ NEW: Google Sign-In specific error codes
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection';
      case 'google-sign-in-failed':
        return 'Google Sign-In failed. Please try again';
      case 'credential-already-in-use':
        return 'This Google account is already linked to another user';
      case 'user-disabled':
        return 'This account has been disabled. Contact support';
      case 'expired-action-code':
        return 'Token has expired. Please try signing in again';
      default:
        return 'Something went wrong. Please try again';
    }
  }
}

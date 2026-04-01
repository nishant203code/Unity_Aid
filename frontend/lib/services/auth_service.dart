import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

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
  //  GOOGLE SIGN-IN (v6 API)
  // ─────────────────────────────────────────────

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User cancelled the sign-in
      if (googleUser == null) return null;

      // Get the auth tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Log error for debugging
      print('Google Sign-In error: $e');
      return null;
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
        return 'Password is too weak (min 6 characters)';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please try again';
      case 'session-expired':
        return 'OTP has expired. Please request a new one';
      default:
        return 'Something went wrong. Please try again';
    }
  }
}

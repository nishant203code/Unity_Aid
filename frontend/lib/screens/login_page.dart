import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../widgets/digilocker_button.dart';
import '../widgets/auth_widgets.dart';
import 'signup/signup_page.dart';
import 'ngo_verification_page.dart';
import 'complete_profile_screen.dart';
import 'user_home/user_home_page.dart';
import 'ngo_home/ngo_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  int selectedRole = 0;
  bool isLoading = false;

  // ✅ FIX: Cooldown to prevent rapid repeat login attempts
  DateTime? _lastLoginAttempt;
  static const _loginCooldown = Duration(seconds: 3);

  // ✅ FIX: Email format regex
  static final _emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // ✅ FIX 1: Validate email format before submitting
    if (email.isEmpty) {
      _showError('Please enter your email address.');
      return;
    }
    if (!_emailRegex.hasMatch(email)) {
      _showError('Please enter a valid email address (e.g. name@example.com).');
      return;
    }

    // ✅ FIX 2: Password must be non-empty and at least 8 characters
    if (password.isEmpty) {
      _showError('Please enter your password.');
      return;
    }
    if (password.length < 8) {
      _showError('Password must be at least 8 characters.');
      return;
    }

    // ✅ FIX 3: Cooldown — block rapid repeat submissions
    final now = DateTime.now();
    if (_lastLoginAttempt != null &&
        now.difference(_lastLoginAttempt!) < _loginCooldown) {
      final remaining =
          _loginCooldown.inSeconds -
          now.difference(_lastLoginAttempt!).inSeconds;
      _showError('Please wait $remaining seconds before trying again.');
      return;
    }
    _lastLoginAttempt = now;

    setState(() => isLoading = true);
    try {
      await AuthService.signInWithEmail(email, password);

      // ✅ FIX 4: Verify the session/auth token was actually set
      final user = AuthService.currentUser;
      if (user == null) {
        _showError('Login succeeded but session was not created. Please try again.');
        return;
      }

      if (!mounted) return;
      await _navigateAfterAuth(isNGO: selectedRole == 1);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthService.getErrorMessage(e.code)),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Helper to show a warning-style snackbar for validation errors
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> handleGoogleSignIn() async {
    setState(() => isLoading = true);
    try {
      final result = await AuthService.signInWithGoogle();
      if (result == null) {
        // User cancelled — just reset loading, no error
        if (mounted) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google Sign-In was cancelled.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      if (!mounted) return;
      await _navigateAfterAuth(isNGO: selectedRole == 1);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthService.getErrorMessage(e.code)),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _navigateAfterAuth({required bool isNGO}) async {
    final user = AuthService.currentUser;
    if (user == null) return;
    try {
      final hasProfile = await UserService.profileExists(user.uid);
      if (!mounted) return;
      if (hasProfile) {
        // Read role from Firestore — this is the source of truth
        final role = await UserService.getUserRole(user.uid);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => role == 'ngo' ? const NGOHomePage() : const UserHomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompleteProfileScreen(isNGO: isNGO),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Firestore error - go to profile completion as fallback
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(isNGO: isNGO),
        ),
      );
    }
  }

  Future<void> handleDigiLockerLogin() async {
    setState(() => isLoading = true);
    // DigiLocker OAuth - coming soon
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('DigiLocker integration coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.shade700,
                  Colors.red.shade900,
                  Colors.purple.shade900,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.volunteer_activism,
                      color: Colors.white, size: 80),
                  const SizedBox(height: 12),
                  const Text(
                    "UnityAid",
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  AuthGlassCard(
                    child: Column(
                      children: [
                        RoleSelector(
                          selectedRole: selectedRole,
                          onChanged: (val) =>
                              setState(() => selectedRole = val),
                        ),
                        const SizedBox(height: 25),
                        AuthTextField(
                          controller: emailController,
                          label: "Email",
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: passwordController,
                          label: "Password",
                          icon: Icons.lock,
                          isPassword: true,
                          obscurePassword: obscurePassword,
                          onToggleVisibility: () => setState(
                              () => obscurePassword = !obscurePassword),
                        ),
                        const SizedBox(height: 30),
                        AuthButton(
                          isLoading: isLoading,
                          text: "Login",
                          onPressed: handleLogin,
                        ),
                        const SizedBox(height: 20),

                        /// Google Sign-In — shown for both User and NGO
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white30)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("OR",
                                  style: TextStyle(color: Colors.white70)),
                            ),
                            Expanded(child: Divider(color: Colors.white30)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Google Sign-In Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: isLoading ? null : handleGoogleSignIn,
                            icon: Image.network(
                              'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                              height: 24,
                              width: 24,
                              errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24),
                            ),
                            label: const Text(
                              'Continue with Google',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// DigiLocker — only for User
                        if (selectedRole == 0) ...[
                          DigiLockerButton(
                            onTap: () {
                              handleDigiLockerLogin();
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                        selectedRole == 0
                            ? AuthFooterLink(
                                text: "Don't have an account?",
                                actionText: "Sign Up",
                                onTap: () => Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        pageBuilder: (_, animation, __) =>
                                            const SignupPage(),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          final offsetAnimation = Tween(
                                            begin: const Offset(
                                                1.0, 0.0), // slide from right
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut,
                                            ),
                                          );

                                          return FadeTransition(
                                            opacity: animation,
                                            child: SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    ))
                            : AuthFooterLink(
                                text: "New NGO?",
                                actionText: "Get Verified",
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const NgoVerificationPage()),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

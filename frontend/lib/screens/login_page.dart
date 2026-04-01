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

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await AuthService.signInWithEmail(email, password);
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

  Future<void> handleGoogleSignIn() async {
    setState(() => isLoading = true);
    try {
      final result = await AuthService.signInWithGoogle();
      if (result == null) {
        if (mounted) setState(() => isLoading = false);
        return; // User cancelled
      }
      if (!mounted) return;
      await _navigateAfterAuth(isNGO: selectedRole == 1);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e'), backgroundColor: Colors.red),
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

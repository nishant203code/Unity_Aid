import 'package:flutter/material.dart';
import '../widgets/digilocker_button.dart';
import '../widgets/auth_widgets.dart';
import 'signup/signup_page.dart';
import 'ngo_verification_page.dart';
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
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            selectedRole == 0 ? const UserHomePage() : const NGOHomePage(),
      ),
    );
  }

  Future<void> handleDigiLockerLogin() async {
    setState(() => isLoading = true);

    /// FUTURE:
    /// Redirect to DigiLocker OAuth

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const UserHomePage(),
      ),
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

                        /// Show ONLY for User
                        if (selectedRole == 0) ...[
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
                          const SizedBox(height: 20),
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

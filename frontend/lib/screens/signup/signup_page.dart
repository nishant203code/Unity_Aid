import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/signup/signup_fields.dart';
import '../../widgets/signup/password_strength.dart';
import '../../widgets/signup/step_indicator.dart';
import '../../services/auth_service.dart';
import '../complete_profile_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PageController pageController = PageController();
  int currentStep = 0;
  bool isLoading = false;

  // Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final aadharController = TextEditingController();
  final motherTongueController = TextEditingController();
  final fatherController = TextEditingController();
  final occupationController = TextEditingController();
  final passwordController = TextEditingController();
  // ✅ NEW: Confirm password controller
  final confirmPasswordController = TextEditingController();

  String? gender;
  String? category;

  // ✅ Email regex for validation
  static final _emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    contactController.dispose();
    emailController.dispose();
    aadharController.dispose();
    motherTongueController.dispose();
    fatherController.dispose();
    occupationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose();
    super.dispose();
  }

  /// ✅ FIX: Validate Step 1 fields before allowing navigation to Step 2
  void nextStep() {
    if (currentStep == 0) {
      // Validate Step 1 fields: name, email, password, confirm password
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (name.isEmpty) {
        _showError('Please enter your full name.');
        return;
      }
      if (email.isEmpty) {
        _showError('Please enter your email address.');
        return;
      }
      if (!_emailRegex.hasMatch(email)) {
        _showError('Please enter a valid email address.');
        return;
      }
      if (password.isEmpty) {
        _showError('Please enter a password.');
        return;
      }
      if (password.length < 8) {
        _showError('Password must be at least 8 characters.');
        return;
      }
      if (confirmPassword.isEmpty) {
        _showError('Please re-enter your password.');
        return;
      }
      if (password != confirmPassword) {
        _showError('Passwords do not match.');
        return;
      }
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void prevStep() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// ✅ FIX: Full validation before signup submission
  Future<void> handleSignup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Re-validate critical fields even at the final step
    if (name.isEmpty) {
      _showError('Name is required. Please go back to Step 1.');
      return;
    }
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      _showError('A valid email is required. Please go back to Step 1.');
      return;
    }
    if (password.isEmpty || password.length < 8) {
      _showError('Password must be at least 8 characters. Go back to Step 1.');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match. Please go back to Step 1.');
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService.signUpWithEmail(email, password);

      if (!mounted) return;

      // ✅ Show success message before navigating
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Complete your profile.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to profile completion screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CompleteProfileScreen(),
        ),
      );
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
          content: Text('Signup failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Helper to show error snackbar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Gradient
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        StepIndicator(currentStep: currentStep),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: PageView(
                            controller: pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() => currentStep = index);
                            },
                            children: [
                              /// STEP 1
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    signupField(nameController, "Full Name",
                                        Icons.person),
                                    phoneField(contactController),
                                    otpField(
                                        emailController, "Email", Icons.email),
                                    // ✅ UPDATED: Pass confirmPasswordController
                                    PasswordStrengthField(
                                      passwordController,
                                      confirmController:
                                          confirmPasswordController,
                                    ),
                                    const SizedBox(height: 18),
                                    nextButton(nextStep),
                                  ],
                                ),
                              ),

                              /// STEP 2
                              Column(
                                children: [
                                  aadharField(aadharController),
                                  genderDropdown((val) => gender = val),
                                  categoryDropdown((val) => category = val),
                                  stepNavButtons(prevStep, nextStep),
                                ],
                              ),

                              /// STEP 3
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    signupField(addressController, "Address",
                                        Icons.home),
                                    signupField(motherTongueController,
                                        "Mother Tongue", Icons.language),
                                    signupField(
                                        fatherController,
                                        "Father / Husband Name (Optional)",
                                        Icons.family_restroom,
                                        optional: true),
                                    signupField(occupationController,
                                        "Occupation", Icons.work),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: prevStep,
                                          child: const Text("Back"),
                                        ),
                                        ElevatedButton(
                                          onPressed:
                                              isLoading ? null : handleSignup,
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Text("Sign Up"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

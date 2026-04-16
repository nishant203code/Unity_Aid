import 'dart:ui';
import 'package:flutter/material.dart';
import '../../widgets/signup/signup_fields.dart';
import '../../widgets/signup/password_strength.dart';
import '../../widgets/signup/step_indicator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final PageController pageController = PageController();
  int currentStep = 0;

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

  String? gender;
  String? category;
  DateTime? dateOfBirth;

  void nextStep() {
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
    pageController.dispose();
    super.dispose();
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
                      color: Colors.white.withOpacity(0.15),
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
                                    PasswordStrengthField(passwordController),
                                    nextButton(nextStep),
                                  ],
                                ),
                              ),

                              /// STEP 2
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    aadharField(aadharController),
                                    genderDropdown((val) => setState(() => gender = val)),
                                    categoryDropdown((val) => setState(() => category = val)),
                                    dateOfBirthField(
                                      context,
                                      dateOfBirth,
                                      (date) => setState(() => dateOfBirth = date),
                                    ),
                                    stepNavButtons(prevStep, nextStep),
                                  ],
                                ),
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
                                          onPressed: () {
                                            // Validate age before allowing signup
                                            if (dateOfBirth == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please select your date of birth'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            // Check if user is at least 18
                                            if (!isUserAtLeast18(dateOfBirth)) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'You must be at least 18 years old to register'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            // Proceed with signup
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Sign Up"),
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

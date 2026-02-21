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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          SizedBox.expand(
            child: Image.asset(
              "assets/images/bgu.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Container(color: Colors.black.withOpacity(0.55)),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.transparent),
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
                                        submitButton(context),
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

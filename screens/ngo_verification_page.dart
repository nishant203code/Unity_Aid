import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NgoVerificationPage extends StatefulWidget {
  const NgoVerificationPage({super.key});

  @override
  State<NgoVerificationPage> createState() => _NgoVerificationPageState();
}

class _NgoVerificationPageState extends State<NgoVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final registrationIdController = TextEditingController();
  final ownerController = TextEditingController();
  final panController = TextEditingController();
  final accountController = TextEditingController();
  final ifscController = TextEditingController();
  final bankController = TextEditingController();

  String? fcraStatus;

  //-----------------------------------------
  /// GLASS INPUT STYLE (same as signup)
  //-----------------------------------------

  InputDecoration inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.greenAccent),
      ),
    );
  }

  //-----------------------------------------
  /// TEXT FIELD
  //-----------------------------------------

  Widget buildField(
      TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboard = TextInputType.text,
      List<TextInputFormatter>? formatters}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: formatters,
        style: const TextStyle(color: Colors.white),
        validator: (value) =>
            value == null || value.isEmpty ? "Required field" : null,
        decoration: inputStyle(hint, icon),
      ),
    );
  }

  //-----------------------------------------
  /// SUBMIT BUTTON
  //-----------------------------------------

  Widget submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate() && fcraStatus != null) {
            // TODO:
            // send NGO data to database

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("NGO Verification Submitted"),
              ),
            );
          }
        },
        child: const Text(
          "Submit for Verification",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  //-----------------------------------------
  /// UI
  //-----------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          SizedBox.expand(
            child: Image.asset(
              "assets/images/bg2.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Dark overlay
          Container(
            color: Colors.black.withOpacity(0.55),
          ),

          /// Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.transparent),
          ),

          //-----------------------------------------
          /// GLASS CARD
          //-----------------------------------------

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 26),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),

                      //-----------------------------------------
                      /// FORM
                      //-----------------------------------------

                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "NGO Verification",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Provide authentic details for approval",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 28),

                            buildField(nameController, "NGO Name", Icons.badge),

                            //-----------------------------------------
                            /// FCRA Dropdown
                            //-----------------------------------------

                            Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: DropdownButtonFormField<String>(
                                dropdownColor: Colors.grey[900],
                                style: const TextStyle(color: Colors.white),
                                decoration: inputStyle(
                                    "Registered on FCRA?", Icons.verified),
                                items: ["Yes", "No"]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e,
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    fcraStatus = val;
                                  });
                                },
                                validator: (_) => fcraStatus == null
                                    ? "Required field"
                                    : null,
                              ),
                            ),

                            buildField(
                                registrationIdController,
                                "Registration ID (DARPAN)",
                                Icons.confirmation_number),

                            buildField(ownerController,
                                "Owner / Institute Name", Icons.person),

                            //-----------------------------------------
                            /// PAN
                            //-----------------------------------------
                            buildField(
                              panController,
                              "PAN Number",
                              Icons.credit_card,
                              formatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp("[A-Z0-9]"),
                                ),
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                            buildField(
                              accountController,
                              "Bank Account Number",
                              Icons.account_balance,
                              keyboard: TextInputType.number,
                            ),
                            buildField(ifscController, "IFSC Code", Icons.code),
                            buildField(
                                bankController, "Bank Name", Icons.apartment),
                            const SizedBox(height: 10),
                            submitButton(),
                          ],
                        ),
                      ),
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

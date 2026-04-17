import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/ngo_service.dart';

enum _CaseHandling { social, individual, both }

class NgoVerificationPage extends StatefulWidget {
  const NgoVerificationPage({super.key});

  @override
  State<NgoVerificationPage> createState() => _NgoVerificationPageState();
}

class _NgoVerificationPageState extends State<NgoVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ownerController = TextEditingController();
  final darpanController = TextEditingController();
  final fcraIdController = TextEditingController();
  final panController = TextEditingController();
  final gstinController = TextEditingController();
  final addressController = TextEditingController();
  final branchAddressController = TextEditingController();
  final peopleAssociatedController = TextEditingController();
  final casesHandledController = TextEditingController();
  final accountController = TextEditingController();
  final bankController = TextEditingController();
  final bankBranchController = TextEditingController();
  final ifscController = TextEditingController();

  bool isFcraRegistered = false;
  _CaseHandling caseHandling = _CaseHandling.social;

  @override
  void dispose() {
    nameController.dispose();
    ownerController.dispose();
    darpanController.dispose();
    fcraIdController.dispose();
    panController.dispose();
    gstinController.dispose();
    addressController.dispose();
    branchAddressController.dispose();
    peopleAssociatedController.dispose();
    casesHandledController.dispose();
    accountController.dispose();
    bankController.dispose();
    bankBranchController.dispose();
    ifscController.dispose();
    super.dispose();
  }

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

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  //-----------------------------------------
  /// TEXT FIELD
  //-----------------------------------------

  Widget buildField(
      TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboard = TextInputType.text,
      List<TextInputFormatter>? formatters,
      bool requiredField = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        inputFormatters: formatters,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (!requiredField) {
            return null;
          }
          return value == null || value.isEmpty ? "Required field" : null;
        },
        decoration: inputStyle(hint, icon),
      ),
    );
  }

  Widget buildNumberField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool optional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (optional) {
            if (value == null || value.isEmpty) {
              return null;
            }
          }
          if (value == null || value.isEmpty) {
            return "Required field";
          }
          if (int.tryParse(value) == null) {
            return "Enter a valid number";
          }
          return null;
        },
        decoration: inputStyle(hint, icon),
      ),
    );
  }

  Widget buildPanField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: panController,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
          LengthLimitingTextInputFormatter(10),
        ],
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required field';
          }
          if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
            return 'Enter a valid PAN number';
          }
          return null;
        },
        decoration: inputStyle('PAN Number', Icons.credit_card),
      ),
    );
  }

  Widget buildGstinField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: gstinController,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
          LengthLimitingTextInputFormatter(15),
        ],
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required field';
          }
          return null;
        },
        decoration: inputStyle('GSTIN', Icons.receipt_long),
      ),
    );
  }

  Widget buildFcraField() {
    if (!isFcraRegistered) {
      return const SizedBox.shrink();
    }

    return buildField(
      fcraIdController,
      'FCRA ID',
      Icons.verified,
      requiredField: false,
    );
  }

  Widget buildCaseHandlingSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: DropdownButtonFormField<_CaseHandling>(
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white),
        decoration: inputStyle('Field / Cases handled', Icons.category),
        value: caseHandling,
        items: const [
          DropdownMenuItem(
            value: _CaseHandling.social,
            child: Text('Handle social cases', style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: _CaseHandling.individual,
            child: Text('Handle individual cases', style: TextStyle(color: Colors.white)),
          ),
          DropdownMenuItem(
            value: _CaseHandling.both,
            child: Text('Handle both', style: TextStyle(color: Colors.white)),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            caseHandling = value;
          });
        },
      ),
    );
  }

  Widget buildFcraToggle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Registered under FCRA?',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: const Text(
          'If yes, FCRA ID becomes optional for the form flow',
          style: TextStyle(color: Colors.white70),
        ),
        value: isFcraRegistered,
        activeColor: Colors.greenAccent,
        onChanged: (value) {
          setState(() {
            isFcraRegistered = value;
          });
        },
      ),
    );
  }

  //-----------------------------------------
  /// SUBMIT BUTTON
  //-----------------------------------------

  bool _isSubmitting = false;

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
        onPressed: _isSubmitting ? null : () async {
          if (!_formKey.currentState!.validate()) return;

          setState(() => _isSubmitting = true);

          final success = await NgoService.submitVerification(
            ngoName: nameController.text.trim(),
            ownerName: ownerController.text.trim(),
            darpanId: darpanController.text.trim(),
            panNumber: panController.text.trim(),
            gstin: gstinController.text.trim(),
            mainAddress: addressController.text.trim(),
            branchAddress: branchAddressController.text.trim(),
            peopleAssociated: int.tryParse(peopleAssociatedController.text.trim()) ?? 0,
            casesHandled: int.tryParse(casesHandledController.text.trim()) ?? 0,
            caseHandlingType: caseHandling.name,
            bankAccountNumber: accountController.text.trim(),
            bankName: bankController.text.trim(),
            bankBranch: bankBranchController.text.trim(),
            ifscCode: ifscController.text.trim(),
            fcraId: isFcraRegistered ? fcraIdController.text.trim() : null,
            isFcraRegistered: isFcraRegistered,
          );

          if (!mounted) return;
          setState(() => _isSubmitting = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'NGO Verification Submitted Successfully!'
                    : 'Failed to submit. Please try again.',
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );

          if (success) {
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) Navigator.pop(context);
            });
          }
        },
        child: _isSubmitting
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
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

                            buildSectionTitle('Organization Details'),
                            buildField(nameController, "NGO Name", Icons.badge),
                            buildCaseHandlingSelector(),
                            buildFcraToggle(),
                            buildFcraField(),
                            buildField(
                              darpanController,
                              "DARPAN ID",
                              Icons.confirmation_number,
                            ),
                            buildField(ownerController,
                                "Owner", Icons.person),
                            buildPanField(),
                            buildGstinField(),
                            buildField(
                              addressController,
                              "Address",
                              Icons.home,
                              keyboard: TextInputType.streetAddress,
                            ),
                            buildField(
                              branchAddressController,
                              "Branch Address",
                              Icons.location_on,
                              keyboard: TextInputType.streetAddress,
                            ),
                            buildNumberField(
                              peopleAssociatedController,
                              "Number of People Associated",
                              Icons.groups,
                            ),
                            buildNumberField(
                              casesHandledController,
                              "Cases Handled",
                              Icons.assignment,
                            ),

                            buildSectionTitle('Bank Details'),
                            buildField(
                              accountController,
                              "Bank Account Number",
                              Icons.account_balance,
                              keyboard: TextInputType.number,
                            ),
                            buildField(bankController, "Bank Name", Icons.apartment),
                            buildField(
                              bankBranchController,
                              "Bank Branch",
                              Icons.domain,
                            ),
                            buildField(ifscController, "IFSC Code", Icons.code),
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

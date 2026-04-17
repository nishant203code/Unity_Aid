import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/ngo_service.dart';
import '../models/user_model.dart';
import '../models/ngo_model.dart';
import 'ngo_home/ngo_home_page.dart';
import 'login_page.dart';

/// Multi-step profile creation screen for NGO accounts.
///
/// When a new NGO user signs up or logs in for the first time,
/// this screen collects both personal info AND full NGO organisation
/// details, then saves:
///   • `users/{uid}`  — personal profile with role='ngo'
///   • `ngos/{id}`    — public NGO profile visible in Search
class CompleteNGOProfileScreen extends StatefulWidget {
  const CompleteNGOProfileScreen({super.key});

  @override
  State<CompleteNGOProfileScreen> createState() =>
      _CompleteNGOProfileScreenState();
}

class _CompleteNGOProfileScreenState extends State<CompleteNGOProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSaving = false;

  // ─── Step 1: Personal Info ───
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedGender = 'Male';
  final _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  // ─── Step 2: Organisation Details ───
  final _ngoNameController = TextEditingController();
  final _ngoDescriptionController = TextEditingController();
  final _ngoLocationController = TextEditingController();
  final _missionController = TextEditingController();
  final _visionController = TextEditingController();
  final _targetCommunitiesController = TextEditingController();
  final _projectTypesController = TextEditingController();
  final _ownerNameController = TextEditingController();

  // ─── Step 3: Legal & Registration ───
  final _registrationNumberController = TextEditingController();
  final _darpanNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  final _fcraNumberController = TextEditingController();
  final _tanNumberController = TextEditingController();
  String _selectedLegalStatus = 'Trust';
  final _legalStatusOptions = [
    'Trust',
    'Society',
    'Section 8 Company',
    'Cooperative',
    'Other',
  ];

  // ─── Step 4: Contact & Banking ───
  final _websiteController = TextEditingController();
  final _ngoEmailController = TextEditingController();
  final _ngoPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _facebookController = TextEditingController();
  final _twitterController = TextEditingController();
  final _instagramController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillFromFirebase();
  }

  void _prefillFromFirebase() {
    final user = AuthService.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _ownerNameController.text = user.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ngoNameController.dispose();
    _ngoDescriptionController.dispose();
    _ngoLocationController.dispose();
    _missionController.dispose();
    _visionController.dispose();
    _targetCommunitiesController.dispose();
    _projectTypesController.dispose();
    _ownerNameController.dispose();
    _registrationNumberController.dispose();
    _darpanNumberController.dispose();
    _panNumberController.dispose();
    _fcraNumberController.dispose();
    _tanNumberController.dispose();
    _websiteController.dispose();
    _ngoEmailController.dispose();
    _ngoPhoneController.dispose();
    _addressController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _ifscController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════
  //  SAVE LOGIC
  // ═══════════════════════════════════════════════

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final firebaseUser = AuthService.currentUser!;

      // ── 1. Save user profile ──
      final userModel = UserModel(
        id: firebaseUser.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender,
        profilePictureUrl: firebaseUser.photoURL,
        isVerified: firebaseUser.emailVerified,
        totalDonated: 0.0,
        address: _addressController.text.trim(),
        occupation: 'NGO Admin',
        category: 'NGO',
        role: 'ngo',
        joinedNGOIds: [],
        joinedDate: DateTime.now(),
      );

      await UserService.saveUserProfile(firebaseUser.uid, userModel);

      // ── 2. Parse comma-separated fields into lists ──
      List<String> parseList(String raw) {
        if (raw.trim().isEmpty) return [];
        return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }

      // ── 3. Build social media map ──
      final socialMedia = <String, String>{};
      if (_facebookController.text.trim().isNotEmpty) {
        socialMedia['facebook'] = _facebookController.text.trim();
      }
      if (_twitterController.text.trim().isNotEmpty) {
        socialMedia['twitter'] = _twitterController.text.trim();
      }
      if (_instagramController.text.trim().isNotEmpty) {
        socialMedia['instagram'] = _instagramController.text.trim();
      }

      // ── 4. Save NGO profile ──
      final ngo = NGO(
        name: _ngoNameController.text.trim(),
        description: _ngoDescriptionController.text.trim(),
        location: _ngoLocationController.text.trim(),
        latitude: 0.0, // Can be updated later via a map picker
        longitude: 0.0,
        logoUrl: firebaseUser.photoURL ?? '',
        members: 1,
        followers: 0,
        ownerName: _ownerNameController.text.trim(),
        mission: _missionController.text.trim().isEmpty
            ? null
            : _missionController.text.trim(),
        vision: _visionController.text.trim().isEmpty
            ? null
            : _visionController.text.trim(),
        targetCommunities: parseList(_targetCommunitiesController.text),
        projectTypes: parseList(_projectTypesController.text),
        registrationNumber: _registrationNumberController.text.trim().isEmpty
            ? null
            : _registrationNumberController.text.trim(),
        darpanNumber: _darpanNumberController.text.trim().isEmpty
            ? null
            : _darpanNumberController.text.trim(),
        panNumber: _panNumberController.text.trim().isEmpty
            ? null
            : _panNumberController.text.trim(),
        fcraNumber: _fcraNumberController.text.trim().isEmpty
            ? null
            : _fcraNumberController.text.trim(),
        tanNumber: _tanNumberController.text.trim().isEmpty
            ? null
            : _tanNumberController.text.trim(),
        legalStatus: _selectedLegalStatus,
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        email: _ngoEmailController.text.trim().isEmpty
            ? null
            : _ngoEmailController.text.trim(),
        phone: _ngoPhoneController.text.trim().isEmpty
            ? null
            : _ngoPhoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        bankName: _bankNameController.text.trim().isEmpty
            ? null
            : _bankNameController.text.trim(),
        bankAccountNumber: _bankAccountController.text.trim().isEmpty
            ? null
            : _bankAccountController.text.trim(),
        ifscCode: _ifscController.text.trim().isEmpty
            ? null
            : _ifscController.text.trim(),
        socialMedia: socialMedia.isEmpty ? null : socialMedia,
        rating: 0.0,
      );

      final ngoDocId = await NgoService.createNGO(ngo);
      if (ngoDocId == null) throw Exception('Failed to create NGO profile');

      // Link the NGO to the user's joinedNGOIds
      await UserService.updateUserProfile(firebaseUser.uid, {
        'joinedNGOIds': [ngoDocId],
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('NGO profile created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const NGOHomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _cancelAndLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Sign In?'),
        content: const Text(
            'Are you sure you want to cancel profile creation? You will be signed out.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await AuthService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  // ═══════════════════════════════════════════════
  //  STEP NAVIGATION
  // ═══════════════════════════════════════════════

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // ═══════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_currentStep > 0) {
          _prevStep();
        } else {
          await _cancelAndLogout();
        }
      },
      child: Scaffold(
        body: Container(
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
          child: SafeArea(
            child: Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: _currentStep > 0
                              ? _prevStep
                              : _cancelAndLogout,
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white24,
                              backgroundImage:
                                  AuthService.currentUser?.photoURL != null
                                      ? NetworkImage(
                                          AuthService.currentUser!.photoURL!)
                                      : null,
                              child: AuthService.currentUser?.photoURL == null
                                  ? const Icon(Icons.business,
                                      size: 35, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Setup NGO Profile",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _stepSubtitle(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Step Indicators ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: List.generate(4, (i) {
                      final isActive = i <= _currentStep;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isActive
                                ? Colors.greenAccent
                                : Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Step ${_currentStep + 1} of 4',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Form Body ──
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(22),
                        child: _buildCurrentStep(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _stepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Your personal information';
      case 1:
        return 'Tell us about your organisation';
      case 2:
        return 'Legal & registration details';
      case 3:
        return 'Contact, social & banking';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return const SizedBox.shrink();
    }
  }

  // ═══════════════════════════════════════════════
  //  STEP 1 — Personal Info
  // ═══════════════════════════════════════════════

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Personal Information'),
        const SizedBox(height: 12),
        _buildField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person,
          validator: _required('name'),
        ),
        const SizedBox(height: 14),
        _buildDropdown(
          label: 'Gender',
          icon: Icons.wc,
          value: _selectedGender,
          items: _genderOptions,
          onChanged: (v) => setState(() => _selectedGender = v!),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          readOnly: AuthService.currentUser?.email != null,
          validator: _required('email'),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: _required('phone number'),
        ),
        const SizedBox(height: 28),
        _nextButton(),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  STEP 2 — Organisation Details
  // ═══════════════════════════════════════════════

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Organisation Details'),
        const SizedBox(height: 12),
        _buildField(
          controller: _ngoNameController,
          label: 'NGO / Organisation Name',
          icon: Icons.business,
          validator: _required('NGO name'),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _ownerNameController,
          label: 'Founder / Owner Name',
          icon: Icons.person_outline,
          validator: _required('owner name'),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _ngoDescriptionController,
          label: 'Description / About',
          icon: Icons.description,
          maxLines: 3,
          validator: _required('description'),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _ngoLocationController,
          label: 'City / Location',
          icon: Icons.location_city,
          validator: _required('location'),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _missionController,
          label: 'Mission Statement (Optional)',
          icon: Icons.flag,
          maxLines: 2,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _visionController,
          label: 'Vision Statement (Optional)',
          icon: Icons.visibility,
          maxLines: 2,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _targetCommunitiesController,
          label: 'Target Communities (comma separated)',
          icon: Icons.groups,
          hintText: 'e.g. Urban Slums, Tribal, Rural',
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _projectTypesController,
          label: 'Project Types (comma separated)',
          icon: Icons.category,
          hintText: 'e.g. Education, Healthcare, Environment',
        ),
        const SizedBox(height: 28),
        _navButtons(),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  STEP 3 — Legal & Registration
  // ═══════════════════════════════════════════════

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Legal & Registration'),
        const SizedBox(height: 4),
        Text(
          'All fields are optional — fill in what you have.',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Legal Status',
          icon: Icons.gavel,
          value: _selectedLegalStatus,
          items: _legalStatusOptions,
          onChanged: (v) => setState(() => _selectedLegalStatus = v!),
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _registrationNumberController,
          label: 'Registration Number',
          icon: Icons.confirmation_number,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _darpanNumberController,
          label: 'NGO Darpan ID',
          icon: Icons.badge,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _panNumberController,
          label: 'PAN Number',
          icon: Icons.credit_card,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _fcraNumberController,
          label: 'FCRA Number (if applicable)',
          icon: Icons.verified,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _tanNumberController,
          label: 'TAN Number',
          icon: Icons.receipt_long,
        ),
        const SizedBox(height: 28),
        _navButtons(),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  STEP 4 — Contact & Banking
  // ═══════════════════════════════════════════════

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Contact Information'),
        const SizedBox(height: 12),
        _buildField(
          controller: _websiteController,
          label: 'Website',
          icon: Icons.language,
          keyboardType: TextInputType.url,
          hintText: 'https://...',
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _ngoEmailController,
          label: 'Contact Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _ngoPhoneController,
          label: 'Contact Phone',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _addressController,
          label: 'Physical Address',
          icon: Icons.location_on,
          maxLines: 2,
        ),
        const SizedBox(height: 22),

        _sectionTitle('Social Media (Optional)'),
        const SizedBox(height: 12),
        _buildField(
          controller: _facebookController,
          label: 'Facebook URL',
          icon: Icons.facebook,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _twitterController,
          label: 'Twitter / X URL',
          icon: Icons.alternate_email,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _instagramController,
          label: 'Instagram URL',
          icon: Icons.camera_alt_outlined,
        ),
        const SizedBox(height: 22),

        _sectionTitle('Banking Details (Optional)'),
        const SizedBox(height: 12),
        _buildField(
          controller: _bankNameController,
          label: 'Bank Name',
          icon: Icons.account_balance,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _bankAccountController,
          label: 'Account Number',
          icon: Icons.numbers,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        _buildField(
          controller: _ifscController,
          label: 'IFSC Code',
          icon: Icons.code,
        ),
        const SizedBox(height: 28),

        // ── Submit ──
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Create NGO Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════════

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.red.shade800,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    String? hintText,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: validator,
      inputFormatters: formatters,
      style: const TextStyle(color: Colors.black, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.red.shade700, size: 22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      style: const TextStyle(color: Colors.black, fontSize: 15),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.red.shade700, size: 22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
      items: items
          .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black))))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _nextButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _nextStep,
        icon: const Icon(Icons.arrow_forward, color: Colors.white),
        label: const Text(
          'Continue',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
        ),
      ),
    );
  }

  Widget _navButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _prevStep,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Back'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _nextStep,
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: const Text(
              'Continue',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
            ),
          ),
        ),
      ],
    );
  }

  String? Function(String?) _required(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your $fieldName';
      }
      return null;
    };
  }
}

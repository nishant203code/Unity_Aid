import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'user_home/user_home_page.dart';
import 'ngo_home/ngo_home_page.dart';
import 'login_page.dart';

class CompleteProfileScreen extends StatefulWidget {
  final bool isNGO;
  const CompleteProfileScreen({super.key, this.isNGO = false});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedCategory = 'Regular Supporter';
  bool _isSaving = false;

  final _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final _categoryOptions = [
    'Regular Supporter',
    'Premium Donor',
    'Individual Donor',
    'Corporate Donor',
    'Volunteer',
  ];

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
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _occupationController.dispose();
    _motherNameController.dispose();
    _fatherNameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final firebaseUser = AuthService.currentUser!;
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
        motherName: _motherNameController.text.trim().isEmpty
            ? null
            : _motherNameController.text.trim(),
        fatherName: _fatherNameController.text.trim().isEmpty
            ? null
            : _fatherNameController.text.trim(),
        occupation: _occupationController.text.trim(),
        category: _selectedCategory,
        role: widget.isNGO ? 'ngo' : 'user',
        joinedNGOIds: [],
        joinedDate: DateTime.now(),
      );

      await UserService.saveUserProfile(firebaseUser.uid, userModel);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                widget.isNGO ? const NGOHomePage() : const UserHomePage(),
          ),
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
            child: const Text('Yes, Cancel',
                style: TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _cancelAndLogout();
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
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: _cancelAndLogout,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AuthService.currentUser?.photoURL != null
                                ? NetworkImage(AuthService.currentUser!.photoURL!)
                                : null,
                            child: AuthService.currentUser?.photoURL == null
                                ? const Icon(Icons.person,
                                    size: 40, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Complete Your Profile",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tell us a bit about yourself",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Form card
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Personal Information"),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _nameController,
                            label: "Full Name",
                            icon: Icons.person,
                            validator: _required('name'),
                          ),
                          const SizedBox(height: 14),
                          _buildDropdown(
                            label: "Gender",
                            icon: Icons.wc,
                            value: _selectedGender,
                            items: _genderOptions,
                            onChanged: (v) =>
                                setState(() => _selectedGender = v!),
                          ),
                          const SizedBox(height: 14),
                          _buildField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: AuthService.currentUser?.email != null,
                            validator: _required('email'),
                          ),
                          const SizedBox(height: 14),
                          _buildField(
                            controller: _phoneController,
                            label: "Phone Number",
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: _required('phone number'),
                          ),
                          const SizedBox(height: 14),
                          _buildField(
                            controller: _occupationController,
                            label: "Occupation",
                            icon: Icons.work,
                            validator: _required('occupation'),
                          ),
                          const SizedBox(height: 14),
                          _buildDropdown(
                            label: "Category",
                            icon: Icons.category,
                            value: _selectedCategory,
                            items: _categoryOptions,
                            onChanged: (v) =>
                                setState(() => _selectedCategory = v!),
                          ),
                          const SizedBox(height: 24),

                          _sectionTitle("Family Information (Optional)"),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _motherNameController,
                            label: "Mother's Name",
                            icon: Icons.family_restroom,
                          ),
                          const SizedBox(height: 14),
                          _buildField(
                            controller: _fatherNameController,
                            label: "Father's Name",
                            icon: Icons.family_restroom,
                          ),
                          const SizedBox(height: 24),

                          _sectionTitle("Address"),
                          const SizedBox(height: 12),
                          _buildField(
                            controller: _addressController,
                            label: "Complete Address",
                            icon: Icons.location_on,
                            maxLines: 3,
                            validator: _required('address'),
                          ),
                          const SizedBox(height: 30),

                          // Save button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
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
                                      "Save & Continue",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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

  // ── Helpers ──

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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: validator,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.red.shade700),
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
      value: value,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.red.shade700),
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
      ),
      items: items
          .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black))))
          .toList(),
      onChanged: onChanged,
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

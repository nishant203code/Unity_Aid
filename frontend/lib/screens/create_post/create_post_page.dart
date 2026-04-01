import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/theme/input_decoration.dart';
import '../../services/auth_service.dart';
import 'widgets/image_picker_section.dart';
import 'widgets/post_submit_button.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final fundGoalController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Case Title
              TextFormField(
                controller: titleController,
                decoration: AppInputDecoration.style("Case Title"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              /// Case Description
              TextFormField(
                controller: descriptionController,
                maxLines: 6,
                decoration: AppInputDecoration.style("Case Description"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),

              /// Location
              TextFormField(
                controller: locationController,
                decoration: AppInputDecoration.style("Case Location"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Location is required' : null,
              ),
              const SizedBox(height: 16),

              /// Fund Goal
              TextFormField(
                controller: fundGoalController,
                keyboardType: TextInputType.number,
                decoration: AppInputDecoration.style("Fund Goal (₹)"),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Fund goal is required';
                  if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              /// Image Picker
              const ImagePickerSection(),

              const SizedBox(height: 32),

              /// Submit Button
              PostSubmitButton(
                isLoading: _isSubmitting,
                onTap: _isSubmitting ? null : _handlePostSubmit,
              ),
              const SizedBox(height: 128),
              const SizedBox(height: 32),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePostSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = AuthService.currentUser;
      if (user == null) {
        throw Exception('Not authenticated. Please log in again.');
      }

      final postData = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'location': locationController.text.trim(),
        'fundGoal': double.parse(fundGoalController.text.trim()),
        'createdBy': user.uid,
        'creatorEmail': user.email ?? '',
        'creatorName': user.displayName ?? '',
        'raised': 0.0,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'mediaUrls': <String>[],
      };

      await FirebaseFirestore.instance.collection('posts').add(postData);

      if (!mounted) return;

      // Clear form
      titleController.clear();
      descriptionController.clear();
      locationController.clear();
      fundGoalController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error posting: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

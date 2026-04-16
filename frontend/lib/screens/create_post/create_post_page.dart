import 'package:flutter/material.dart';

import '../../widgets/theme/app_colors.dart';
import '../../widgets/theme/input_decoration.dart';
import 'widgets/image_picker_section.dart';
import 'widgets/post_submit_button.dart';
import 'widgets/deepfake_upload_dialog.dart';
import '../../services/deepfake_detection_service.dart';

enum _IssueType { personal, social }

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController fundGoalController = TextEditingController();
  final TextEditingController victimNameController = TextEditingController();
  final TextEditingController victimAgeController = TextEditingController();
  final TextEditingController victimGenderController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController victimNumberController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController victimBackgroundController = TextEditingController();
  final TextEditingController otherVictimDetailsController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController policeStationController = TextEditingController();
  final TextEditingController socialIssueDetailsController = TextEditingController();

  final GlobalKey<ImagePickerSectionState> _imagePickerKey =
      GlobalKey<ImagePickerSectionState>();

  _IssueType _issueType = _IssueType.personal;
  bool _isSubmitting = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    fundGoalController.dispose();
    victimNameController.dispose();
    victimAgeController.dispose();
    victimGenderController.dispose();
    relationController.dispose();
    victimNumberController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    victimBackgroundController.dispose();
    otherVictimDetailsController.dispose();
    contactPersonController.dispose();
    policeStationController.dispose();
    socialIssueDetailsController.dispose();
    super.dispose();
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: AppInputDecoration.style(label),
    );
  }

  Widget _buildIssueToggle() {
    return _sectionCard(
      'Issue Type',
      [
        RadioListTile<_IssueType>(
          contentPadding: EdgeInsets.zero,
          value: _IssueType.personal,
          groupValue: _issueType,
          activeColor: AppColors.primary,
          title: const Text('Individual / Personal issue'),
          subtitle: const Text('Case involving a specific victim or family'),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _issueType = value;
            });
          },
        ),
        RadioListTile<_IssueType>(
          contentPadding: EdgeInsets.zero,
          value: _IssueType.social,
          groupValue: _issueType,
          activeColor: AppColors.primary,
          title: const Text('Social issue'),
          subtitle: const Text('Broader community or public concern'),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _issueType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPersonalIssueFields() {
    return _sectionCard(
      'Personal Issue Details',
      [
        _field(victimNameController, 'Victim Name'),
        const SizedBox(height: 14),
        _field(victimAgeController, 'Victim Age', keyboardType: TextInputType.number),
        const SizedBox(height: 14),
        _field(victimGenderController, 'Victim Gender'),
        const SizedBox(height: 14),
        _field(relationController, 'Your Relation with Victim'),
        const SizedBox(height: 14),
        _field(
          victimNumberController,
          'Victim Number (Optional)',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _field(fatherNameController, 'Victim Father Name (Optional)'),
        const SizedBox(height: 14),
        _field(motherNameController, 'Victim Mother Name (Optional)'),
        const SizedBox(height: 14),
        _field(
          victimBackgroundController,
          'Victim Background',
          maxLines: 4,
        ),
        const SizedBox(height: 14),
        _field(
          otherVictimDetailsController,
          'Any Other Details About the Victim (Optional)',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSocialIssueFields() {
    return _sectionCard(
      'Social Issue Details',
      [
        _field(contactPersonController, 'Contact Person'),
        const SizedBox(height: 14),
        _field(policeStationController, 'Nearby Police Station'),
        const SizedBox(height: 14),
        _field(
          socialIssueDetailsController,
          'Any Other Details Available',
          maxLines: 4,
        ),
      ],
    );
  }

  /// Handle post submission with deepfake detection
  Future<void> _handlePostSubmit() async {
    if (_isSubmitting) return;

    // Get all media files
    final allMedia = _imagePickerKey.currentState?.getAllMedia() ?? [];

    // Check for video or image files that need deepfake detection
    final detectableFiles = allMedia.where((file) {
      final fileType = DeepfakeDetectionService.getFileType(file.path);
      return fileType == 'video' || fileType == 'image';
    }).toList();

    if (detectableFiles.isNotEmpty) {
      // Show upload dialog for first detectable file
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DeepfakeUploadDialog(
          mediaFilePath: detectableFiles.first.path,
          onDetectionComplete: (isAccepted, response) {
            if (isAccepted) {
              _submitPost(allMedia);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Post rejected: ${response.message}',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      );
    } else {
      // No detectable media, submit directly
      _submitPost(allMedia);
    }
  }

  /// Submit post data
  void _submitPost(List<dynamic> media) {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    // TODO: Validate form fields
    // TODO: Upload media files to storage
    // TODO: Create post in Firestore

    debugPrint('Post Submitted');
    debugPrint('Title: ${titleController.text}');
    debugPrint('Description: ${descriptionController.text}');
    debugPrint('Location: ${locationController.text}');
    debugPrint('Fund Goal: ${fundGoalController.text}');
    debugPrint('Issue Type: $_issueType');
    debugPrint('Media Files: ${media.length}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() => _isSubmitting = false);

    // Navigate back after delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              'Case Details',
              [
                _field(titleController, 'Case Title'),
                const SizedBox(height: 14),
                _field(
                  descriptionController,
                  'Case Description',
                  maxLines: 6,
                ),
                const SizedBox(height: 14),
                _field(locationController, 'Case Location'),
                const SizedBox(height: 14),
                _field(
                  fundGoalController,
                  'Funds Goal',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildIssueToggle(),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _issueType == _IssueType.personal
                  ? _buildPersonalIssueFields()
                  : _buildSocialIssueFields(),
            ),
            const SizedBox(height: 16),
            ImagePickerSection(key: _imagePickerKey),
            const SizedBox(height: 32),
            PostSubmitButton(
              onTap: _isSubmitting ? null : _handlePostSubmit,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

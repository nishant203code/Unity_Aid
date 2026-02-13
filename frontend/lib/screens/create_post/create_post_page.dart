import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import '../../widgets/theme/input_decoration.dart';
import 'widgets/image_picker_section.dart';
import 'widgets/post_submit_button.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final fundGoalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Post",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Case Title
            TextFormField(
              controller: titleController,
              decoration: AppInputDecoration.style("Case Title"),
            ),
            const SizedBox(height: 16),

            /// Case Description
            TextFormField(
              controller: descriptionController,
              maxLines: 6,
              decoration: AppInputDecoration.style("Case Description"),
            ),
            const SizedBox(height: 16),

            /// Location
            TextFormField(
              controller: locationController,
              decoration: AppInputDecoration.style("Case Location"),
            ),
            const SizedBox(height: 16),

            /// Fund Goal
            TextFormField(
              controller: fundGoalController,
              keyboardType: TextInputType.number,
              decoration: AppInputDecoration.style("Fund Goal (₹)"),
            ),
            const SizedBox(height: 24),

            /// Image Picker
            const ImagePickerSection(),

            const SizedBox(height: 32),

            /// Submit Button
            PostSubmitButton(
              onTap: () {
                // 🔥 Firebase logic later
                debugPrint("Post Submitted");
              },
            ),
            const SizedBox(height: 128),
            const SizedBox(height: 32),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

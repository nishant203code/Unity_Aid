import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../widgets/theme/app_colors.dart';
import '../../../services/deepfake_detection_service.dart';

class ImagePickerSection extends StatefulWidget {
  const ImagePickerSection({super.key});

  @override
  State<ImagePickerSection> createState() => ImagePickerSectionState();
}

class ImagePickerSectionState extends State<ImagePickerSection> {
  final List<XFile> _images = [];
  final List<XFile> _videos = [];
  final List<XFile> _audios = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => _images.addAll(images));
    }
  }

  Future<void> pickVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() => _videos.add(video));
    }
  }

  Future<void> pickAudio() async {
    final audio = await _picker.pickMedia();
    if (audio != null) {
      final fileType = DeepfakeDetectionService.getFileType(audio.path);
      if (fileType == 'audio') {
        setState(() => _audios.add(audio));
      } else {
        _showMessage('Please select an audio file');
      }
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /// Getter for all media files (for parent widget)
  List<XFile> getAllMedia() => [..._images, ..._videos, ..._audios];

  /// Get media file at index (for detection)
  XFile? getMediaAtIndex(int index) {
    final allMedia = getAllMedia();
    if (index < allMedia.length) {
      return allMedia[index];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final allMedia = getAllMedia();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attachments (Images, Videos, Audio)",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 12),

        /// Media Preview
        if (allMedia.isNotEmpty)
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allMedia.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final media = allMedia[index];
                final fileType =
                    DeepfakeDetectionService.getFileType(media.path);
                final isVideo = fileType == 'video';
                final isAudio = fileType == 'audio';

                return Stack(
                  children: [
                    /// THUMBNAIL
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey.shade200,
                        child: isAudio
                            ? const Center(
                                child: Icon(Icons.audio_file_outlined),
                              )
                            : isVideo
                                ? const Center(
                                    child: Icon(Icons.videocam_outlined),
                                  )
                                : Image.file(
                                    File(media.path),
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),

                    /// VIDEO/AUDIO BADGE
                    if (isVideo || isAudio)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isAudio ? 'AUDIO' : 'VIDEO',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    /// REMOVE BUTTON
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (index < _images.length) {
                              _images.removeAt(index);
                            } else if (index <
                                _images.length + _videos.length) {
                              _videos.removeAt(index - _images.length);
                            } else {
                              _audios.removeAt(
                                index - _images.length - _videos.length,
                              );
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

        const SizedBox(height: 12),

        /// Upload Buttons
        Row(
          children: [
            /// Image Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.image_outlined),
                label: const Text("Images"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            /// Video Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: pickVideo,
                icon: const Icon(Icons.videocam_outlined),
                label: const Text("Video"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            /// Audio Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: pickAudio,
                icon: const Icon(Icons.audio_file_outlined),
                label: const Text("Audio"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

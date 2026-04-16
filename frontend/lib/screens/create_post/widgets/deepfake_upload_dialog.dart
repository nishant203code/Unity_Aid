import 'dart:io';
import 'package:flutter/material.dart';
import '../../../services/deepfake_detection_service.dart';
import '../../../widgets/theme/app_colors.dart';

class DeepfakeUploadDialog extends StatefulWidget {
  final String mediaFilePath;
  final Function(bool isAccepted, DeepfakeDetectionResponse response)
      onDetectionComplete;

  const DeepfakeUploadDialog({
    super.key,
    required this.mediaFilePath,
    required this.onDetectionComplete,
  });

  @override
  State<DeepfakeUploadDialog> createState() => _DeepfakeUploadDialogState();
}

class _DeepfakeUploadDialogState extends State<DeepfakeUploadDialog> {
  int uploadedBytes = 0;
  int totalBytes = 0;
  bool isDetecting = false;
  String status = 'Uploading...';
  late DeepfakeDetectionResponse? detectionResult;

  @override
  void initState() {
    super.initState();
    detectionResult = null;
    _startDetection();
  }

  Future<void> _startDetection() async {
    try {
      // Get file
      final file = File(widget.mediaFilePath);

      // Start detection with progress tracking
      final result = await DeepfakeDetectionService.detectDeepfake(
        mediaFile: file,
        onProgress: (bytes, total) {
          setState(() {
            uploadedBytes = bytes;
            totalBytes = total;
            status =
                'Uploading... ${(bytes / total * 100).toStringAsFixed(1)}%';
          });
        },
      );

      if (mounted) {
        setState(() {
          isDetecting = true;
          status = 'Analyzing media...';
          detectionResult = result;
        });

        // Simulate analysis time
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          setState(() {
            status = result.status == 'accepted'
                ? '✓ Post Accepted'
                : '✗ Post Rejected';
          });

          // Wait before closing
          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            widget.onDetectionComplete(
              result.status == 'accepted',
              result,
            );
            Navigator.of(context).pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          status = 'Error: ${e.toString()}';
        });

        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detection Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close error dialog
              Navigator.pop(context); // Close upload dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.mediaFilePath.split('/').last;
    final fileType =
        DeepfakeDetectionService.getFileType(widget.mediaFilePath);
    final fileIcon =
        DeepfakeDetectionService.getFileTypeIcon(widget.mediaFilePath);

    return WillPopScope(
      onWillPop: () async => false, // Prevent dismissing during upload
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                children: [
                  Icon(fileIcon, color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deepfake Detection',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Verifying $fileType authenticity',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// FILE INFO
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      fileIcon,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fileName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// UPLOAD PROGRESS
              if (totalBytes > 0 && !isDetecting)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Progress',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: uploadedBytes / totalBytes,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(uploadedBytes / (1024 * 1024)).toStringAsFixed(1)} MB / ${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

              /// DETECTION STATUS
              if (isDetecting)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: detectionResult?.status == 'accepted'
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            detectionResult?.status == 'accepted'
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: detectionResult?.status == 'accepted'
                                ? Colors.green
                                : Colors.red,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            detectionResult?.status == 'accepted'
                                ? 'Content Verified'
                                : 'Content Rejected',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: detectionResult?.status == 'accepted'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            detectionResult?.message ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (detectionResult?.confidence != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'Confidence: ${(detectionResult!.confidence * 100).toStringAsFixed(1)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                /// LOADING STATE
                Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              const SizedBox(height: 16),

              /// STATUS TEXT
              Text(
                status,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDetecting
                      ? (detectionResult?.status == 'accepted'
                          ? Colors.green
                          : Colors.red)
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

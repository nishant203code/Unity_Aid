import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
// Response model — matches BitMind API shape
// { "isAI": true, "confidence": 0.87, "similarity": 0.0, "objectKey": "..." }
// ──────────────────────────────────────────────
class DeepfakeDetectionResponse {
  final bool isAI;
  final double confidence;
  final double similarity;
  final String objectKey;

  /// Derived fields for UI
  bool get isGenerated => isAI;
  String get status => isAI ? 'rejected' : 'accepted';
  String get message => isAI
      ? 'Content detected as AI-generated (${(confidence * 100).toStringAsFixed(1)}% confidence). Post rejected.'
      : 'Content verified as authentic (${(confidence * 100).toStringAsFixed(1)}% confidence). Post accepted.';

  DeepfakeDetectionResponse({
    required this.isAI,
    required this.confidence,
    required this.similarity,
    required this.objectKey,
  });

  factory DeepfakeDetectionResponse.fromJson(Map<String, dynamic> json) {
    return DeepfakeDetectionResponse(
      isAI: json['isAI'] ?? false,
      confidence: (json['confidence'] ?? 0).toDouble(),
      similarity: (json['similarity'] ?? 0).toDouble(),
      objectKey: json['objectKey'] ?? '',
    );
  }
}

// ──────────────────────────────────────────────
// Service
// Docs: https://docs.bitmind.ai/api-reference/api
// Image endpoint: POST https://api.bitmind.ai/detect-image  (field: "image")
// Video endpoint: POST https://api.bitmind.ai/detect-video  (field: "video")
// ──────────────────────────────────────────────
class DeepfakeDetectionService {
  static const String _baseUrl = 'https://api.bitmind.ai';
  static const String _apiKey =
      'bitmind-26af5a50-39c6-11f1-8162-b17d4257f44e:1bcd7beb';

  /// Creates an IOClient that bypasses SSL cert verification.
  /// Fixes HandshakeException on Android during development.
  /// TODO: Replace with cert pinning before production.
  static IOClient _createLenientClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }

  /// Upload and detect deepfake in a video or audio file.
  /// Picks the correct endpoint based on file type.
  static Future<DeepfakeDetectionResponse> detectDeepfake({
    required File mediaFile,
    required Function(int bytes, int total) onProgress,
  }) async {
    final fileType = getFileType(mediaFile.path);

    // Choose the correct endpoint + field name
    final String endpoint;
    final String fieldName;
    if (fileType == 'video') {
      endpoint = '$_baseUrl/detect-video';
      fieldName = 'video';
    } else if (fileType == 'image') {
      endpoint = '$_baseUrl/detect-image';
      fieldName = 'image';
    } else {
      // Audio — BitMind doesn't have a dedicated audio endpoint;
      // treat as video (mp4 containers) or throw descriptive error.
      throw Exception(
        'Audio-only detection is not supported by the BitMind API. '
        'Please upload a video or image file.',
      );
    }

    final client = _createLenientClient();
    try {
      final request = http.MultipartRequest('POST', Uri.parse(endpoint));
      request.headers['Authorization'] = 'Bearer $_apiKey';

      // Read file bytes into memory (avoids connection-abort from chunked streams)
      final fileBytes = await mediaFile.readAsBytes();
      final fileLength = fileBytes.length;

      // Report "reading" progress before upload starts
      onProgress(fileLength ~/ 2, fileLength);

      request.files.add(
        http.MultipartFile.fromBytes(
          fieldName, // "image" or "video" — as required by the API
          fileBytes,
          filename: mediaFile.path.split(RegExp(r'[\\/]')).last,
        ),
      );

      // Report upload complete
      onProgress(fileLength, fileLength);

      final streamResponse = await client.send(request);
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return DeepfakeDetectionResponse.fromJson(json);
      } else if (response.statusCode == 400) {
        throw Exception(
          'Invalid file format or request. Response: ${response.body}',
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Authentication failed. API key is invalid or expired.');
      } else if (response.statusCode == 404) {
        throw Exception(
          'API endpoint not found (404). Check API key permissions. '
          'Endpoint: $endpoint',
        );
      } else if (response.statusCode == 413) {
        throw Exception(
          'File too large. Direct uploads are limited to 10MB.',
        );
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please wait before trying again.');
      } else if (response.statusCode >= 500) {
        throw Exception(
          'Server error (${response.statusCode}). Please try again later.',
        );
      } else {
        throw Exception(
          'Detection failed (${response.statusCode}). Body: ${response.body}',
        );
      }
    } on SocketException {
      throw Exception('Network error. Please check your internet connection.');
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on HandshakeException catch (e) {
      throw Exception('SSL error: ${e.message}');
    } finally {
      client.close();
    }
  }

  /// Returns 'image', 'video', 'audio', or 'unknown'
  static String getFileType(String filePath) {
    final ext = filePath.toLowerCase().split('.').last;
    const imageExts = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'avif'];
    const videoExts = ['mp4', 'avi', 'mov', 'mkv', 'flv', 'wmv'];
    const audioExts = ['mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg'];

    if (imageExts.contains(ext)) return 'image';
    if (videoExts.contains(ext)) return 'video';
    if (audioExts.contains(ext)) return 'audio';
    return 'unknown';
  }

  /// True if the file type is supported by BitMind (image or video)
  static bool isValidMediaFile(String filePath) {
    final t = getFileType(filePath);
    return t == 'image' || t == 'video';
  }

  static IconData getFileTypeIcon(String filePath) {
    switch (getFileType(filePath)) {
      case 'image':
        return Icons.image;
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.audio_file;
      default:
        return Icons.file_present;
    }
  }
}

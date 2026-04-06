import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/upload_model.dart';
import 'auth_service.dart';

/// Result of a single upload operation.
class UploadResult {
  final bool success;
  final String? downloadUrl;
  final String? storagePath;
  final String? docId;
  final String? error;
  final UploadModel? upload;

  const UploadResult._({
    required this.success,
    this.downloadUrl,
    this.storagePath,
    this.docId,
    this.error,
    this.upload,
  });

  factory UploadResult.ok({
    required String downloadUrl,
    required String storagePath,
    required String docId,
    required UploadModel upload,
  }) =>
      UploadResult._(
        success: true,
        downloadUrl: downloadUrl,
        storagePath: storagePath,
        docId: docId,
        upload: upload,
      );

  factory UploadResult.fail(String error) =>
      UploadResult._(success: false, error: error);
}

/// Batch upload result.
class BatchUploadResult {
  final List<UploadResult> results;
  int get successCount => results.where((r) => r.success).length;
  int get failureCount => results.where((r) => !r.success).length;
  List<String> get urls =>
      results.where((r) => r.success).map((r) => r.downloadUrl!).toList();

  const BatchUploadResult(this.results);
}

/// Callback signature for upload progress.
/// [progress] is a value between 0.0 and 1.0.
typedef UploadProgressCallback = void Function(double progress);

// ═══════════════════════════════════════════════════════
//  UPLOAD SERVICE
// ═══════════════════════════════════════════════════════

class UploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _uploadsCollection =
      _firestore.collection('uploads');

  // ─────────────────────────────────────────────
  //  CONSTRAINTS
  // ─────────────────────────────────────────────

  /// Maximum file size: 5 MB
  static const int maxFileSize = 5 * 1024 * 1024;

  /// Allowed MIME types
  static const List<String> allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  ];

  /// Map file extension → MIME type
  static const Map<String, String> _extToMime = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
  };

  // ─────────────────────────────────────────────
  //  PICK IMAGES  (convenience wrappers)
  // ─────────────────────────────────────────────

  /// Pick a single image from gallery.
  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      return await ImagePicker().pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality ?? 85,
      );
    } catch (e) {
      debugPrint('UploadService.pickImage error: $e');
      return null;
    }
  }

  /// Pick multiple images from gallery.
  static Future<List<XFile>> pickMultipleImages({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      return await ImagePicker().pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality ?? 85,
      );
    } catch (e) {
      debugPrint('UploadService.pickMultipleImages error: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────────
  //  UPLOAD:  SINGLE IMAGE
  // ─────────────────────────────────────────────

  /// Upload a single image to Firebase Storage.
  ///
  /// [file]     – the picked file (XFile from image_picker).
  /// [folder]   – target folder: `'posts'` or `'cases'`.
  /// [onProgress] – optional callback with progress 0.0→1.0.
  ///
  /// Returns [UploadResult] with the download URL on success.
  static Future<UploadResult> uploadImage({
    required XFile file,
    required String folder,
    UploadProgressCallback? onProgress,
  }) async {
    try {
      // ── AUTH CHECK ──
      final user = AuthService.currentUser;
      if (user == null) {
        return UploadResult.fail('Not authenticated. Please sign in first.');
      }

      // ── VALIDATE ──
      final validationError = await _validateFile(file);
      if (validationError != null) {
        return UploadResult.fail(validationError);
      }

      // ── GENERATE NAME & PATH ──
      final originalName = _extractFileName(file.path);
      final ext = _extractExtension(file.path);
      final uniqueName = _generateFileName(user.uid, ext);
      final storagePath = 'uploads/$folder/$uniqueName';

      // ── UPLOAD TO STORAGE ──
      final ref = _storage.ref().child(storagePath);
      final metadata = SettableMetadata(
        contentType: _extToMime[ext] ?? 'image/jpeg',
        customMetadata: {
          'uploadedBy': user.uid,
          'originalName': originalName,
        },
      );

      UploadTask uploadTask;
      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        uploadTask = ref.putData(bytes, metadata);
      } else {
        uploadTask = ref.putFile(File(file.path), metadata);
      }

      // ── PROGRESS TRACKING ──
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snap) {
          if (snap.totalBytes > 0) {
            onProgress(snap.bytesTransferred / snap.totalBytes);
          }
        });
      }

      // ── AWAIT COMPLETION ──
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final totalBytes = snapshot.totalBytes;

      // ── SAVE METADATA TO FIRESTORE ──
      final docRef = _uploadsCollection.doc();
      final uploadModel = UploadModel(
        id: docRef.id,
        imageUrl: downloadUrl,
        fileName: uniqueName,
        originalName: originalName,
        fileSize: totalBytes,
        mimeType: _extToMime[ext] ?? 'image/jpeg',
        folder: folder,
        storagePath: storagePath,
        uploadedBy: user.uid,
        createdAt: DateTime.now(),
      );

      await docRef.set(uploadModel.toJson());

      return UploadResult.ok(
        downloadUrl: downloadUrl,
        storagePath: storagePath,
        docId: docRef.id,
        upload: uploadModel,
      );
    } on FirebaseException catch (e) {
      debugPrint('UploadService.uploadImage FirebaseException: ${e.message}');
      return UploadResult.fail('Upload failed: ${e.message}');
    } catch (e) {
      debugPrint('UploadService.uploadImage error: $e');
      return UploadResult.fail('Upload failed: $e');
    }
  }

  // ─────────────────────────────────────────────
  //  UPLOAD:  MULTIPLE IMAGES
  // ─────────────────────────────────────────────

  /// Upload multiple images in parallel.
  ///
  /// [files]  – list of XFile.
  /// [folder] – target folder.
  /// [onFileProgress] – called with (fileIndex, progress).
  ///
  /// Returns [BatchUploadResult] with individual results.
  static Future<BatchUploadResult> uploadMultipleImages({
    required List<XFile> files,
    required String folder,
    void Function(int fileIndex, double progress)? onFileProgress,
  }) async {
    if (files.isEmpty) {
      return const BatchUploadResult([]);
    }

    final futures = <Future<UploadResult>>[];

    for (int i = 0; i < files.length; i++) {
      futures.add(
        uploadImage(
          file: files[i],
          folder: folder,
          onProgress: onFileProgress != null
              ? (progress) => onFileProgress(i, progress)
              : null,
        ),
      );
    }

    final results = await Future.wait(futures);
    return BatchUploadResult(results);
  }

  // ─────────────────────────────────────────────
  //  DELETE
  // ─────────────────────────────────────────────

  /// Delete an upload from Storage AND its Firestore metadata.
  static Future<bool> deleteUpload(UploadModel upload) async {
    try {
      // Delete from Storage
      await _storage.ref().child(upload.storagePath).delete();

      // Delete Firestore metadata
      if (upload.id.isNotEmpty) {
        await _uploadsCollection.doc(upload.id).delete();
      }

      return true;
    } on FirebaseException catch (e) {
      debugPrint('UploadService.deleteUpload error: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('UploadService.deleteUpload error: $e');
      return false;
    }
  }

  /// Delete by storage path only (when you don't have the UploadModel).
  static Future<bool> deleteByPath(String storagePath) async {
    try {
      await _storage.ref().child(storagePath).delete();

      // Also try to clean up the Firestore metadata
      final query = await _uploadsCollection
          .where('storagePath', isEqualTo: storagePath)
          .limit(1)
          .get();
      for (final doc in query.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      debugPrint('UploadService.deleteByPath error: $e');
      return false;
    }
  }

  // ─────────────────────────────────────────────
  //  QUERY
  // ─────────────────────────────────────────────

  /// Get all uploads by the current user, newest first.
  static Future<List<UploadModel>> getMyUploads({int limit = 50}) async {
    final user = AuthService.currentUser;
    if (user == null) return [];

    try {
      final query = await _uploadsCollection
          .where('uploadedBy', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return UploadModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('UploadService.getMyUploads error: $e');
      return [];
    }
  }

  /// Get uploads for a specific folder (e.g. "posts", "cases").
  static Future<List<UploadModel>> getUploadsByFolder(
    String folder, {
    int limit = 50,
  }) async {
    final user = AuthService.currentUser;
    if (user == null) return [];

    try {
      final query = await _uploadsCollection
          .where('uploadedBy', isEqualTo: user.uid)
          .where('folder', isEqualTo: folder)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return UploadModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('UploadService.getUploadsByFolder error: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════
  //  PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════

  /// Validate file size and type. Returns error string, or null if valid.
  static Future<String?> _validateFile(XFile file) async {
    // ── SIZE CHECK ──
    final size = await file.length();
    if (size > maxFileSize) {
      final sizeMB = (size / (1024 * 1024)).toStringAsFixed(1);
      return 'File too large ($sizeMB MB). Maximum is 5 MB.';
    }
    if (size == 0) {
      return 'File is empty.';
    }

    // ── TYPE CHECK ──
    final ext = _extractExtension(file.path);
    final mime = _extToMime[ext];
    if (mime == null || !allowedMimeTypes.contains(mime)) {
      return 'Unsupported file type ".$ext". Allowed: JPG, PNG, GIF, WEBP.';
    }

    return null; // valid
  }

  /// Generate a unique, collision-free file name.
  /// Format: `<uid_prefix>_<timestamp>_<random>.<ext>`
  static String _generateFileName(String uid, String ext) {
    final uidPrefix = uid.substring(0, uid.length.clamp(0, 8));
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond.toString().padLeft(6, '0');
    return '${uidPrefix}_${timestamp}_$random.$ext';
  }

  /// Extract the file extension from a path, lowercase.
  static String _extractExtension(String path) {
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return 'jpg';
    return path.substring(dot + 1).toLowerCase();
  }

  /// Extract the original file name from a full path.
  static String _extractFileName(String path) {
    final separator = path.contains('\\') ? '\\' : '/';
    final parts = path.split(separator);
    return parts.last;
  }
}

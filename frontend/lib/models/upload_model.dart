import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a file upload stored in Firebase Storage + Firestore metadata.
class UploadModel {
  final String id;
  final String imageUrl;
  final String fileName;
  final String originalName;
  final int fileSize;
  final String mimeType;
  final String folder; // 'posts' | 'cases' | 'profiles'
  final String storagePath;
  final String uploadedBy;
  final DateTime createdAt;

  UploadModel({
    required this.id,
    required this.imageUrl,
    required this.fileName,
    required this.originalName,
    required this.fileSize,
    required this.mimeType,
    required this.folder,
    required this.storagePath,
    required this.uploadedBy,
    required this.createdAt,
  });

  // ─────────────────────────────────────────────
  //  JSON SERIALIZATION
  // ─────────────────────────────────────────────

  factory UploadModel.fromJson(Map<String, dynamic> json) {
    return UploadModel(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      originalName: json['originalName'] as String? ?? '',
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      mimeType: json['mimeType'] as String? ?? 'image/jpeg',
      folder: json['folder'] as String? ?? 'posts',
      storagePath: json['storagePath'] as String? ?? '',
      uploadedBy: json['uploadedBy'] as String? ?? '',
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'fileName': fileName,
      'originalName': originalName,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'folder': folder,
      'storagePath': storagePath,
      'uploadedBy': uploadedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ─────────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────────

  /// Readable file size string (e.g. "2.4 MB")
  String get readableFileSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Parse a Firestore Timestamp or ISO string safely
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  UploadModel copyWith({
    String? id,
    String? imageUrl,
    String? fileName,
    String? originalName,
    int? fileSize,
    String? mimeType,
    String? folder,
    String? storagePath,
    String? uploadedBy,
    DateTime? createdAt,
  }) {
    return UploadModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      fileName: fileName ?? this.fileName,
      originalName: originalName ?? this.originalName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      folder: folder ?? this.folder,
      storagePath: storagePath ?? this.storagePath,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? profilePictureUrl;
  final bool isVerified;
  final double totalDonated;
  final String address;
  final String? motherName;
  final String? fatherName;
  final String occupation;
  final String category; // e.g., "Individual Donor", "Regular Supporter", etc.
  final List<String> joinedNGOIds;
  final DateTime joinedDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.profilePictureUrl,
    this.isVerified = false,
    this.totalDonated = 0.0,
    required this.address,
    this.motherName,
    this.fatherName,
    required this.occupation,
    required this.category,
    this.joinedNGOIds = const [],
    required this.joinedDate,
  });

  // Factory constructor for creating from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      gender: json['gender'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      totalDonated: (json['totalDonated'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String,
      motherName: json['motherName'] as String?,
      fatherName: json['fatherName'] as String?,
      occupation: json['occupation'] as String,
      category: json['category'] as String,
      joinedNGOIds: (json['joinedNGOIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'] as String)
          : DateTime.now(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
      'isVerified': isVerified,
      'totalDonated': totalDonated,
      'address': address,
      'motherName': motherName,
      'fatherName': fatherName,
      'occupation': occupation,
      'category': category,
      'joinedNGOIds': joinedNGOIds,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  // CopyWith method for updating fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? profilePictureUrl,
    bool? isVerified,
    double? totalDonated,
    String? address,
    String? motherName,
    String? fatherName,
    String? occupation,
    String? category,
    List<String>? joinedNGOIds,
    DateTime? joinedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isVerified: isVerified ?? this.isVerified,
      totalDonated: totalDonated ?? this.totalDonated,
      address: address ?? this.address,
      motherName: motherName ?? this.motherName,
      fatherName: fatherName ?? this.fatherName,
      occupation: occupation ?? this.occupation,
      category: category ?? this.category,
      joinedNGOIds: joinedNGOIds ?? this.joinedNGOIds,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}

import '../../../features/auth/domain/entities/user_role.dart';
import '../../../features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.userName,
    super.fullName,
    super.phone,
    super.profilePic = const [],
    super.location,
    super.isAdmin = false,
    super.role = UserRole.seeker,
    super.companyName,
    super.industry,
    super.website,
    super.skills = const [],
    super.experience = const [],
    super.education = const [],
    super.bio = "",
    super.token = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'phone': phone,
      'profilePic': profilePic,
      'location': location,
      'isAdmin': isAdmin,
      'role': role.name,
      'companyName': companyName,
      'industry': industry,
      'website': website,
      'skills': skills,
      'experience': experience,
      'education': education,
      'bio': bio,
    };
  }

  factory UserModel.fromMap(dynamic map) {
    var profilePic = <String>[];
    if (map['profilePic'] != null) {
      if (map['profilePic'] is List) {
        profilePic = (map['profilePic'] as List)
            .map((p) => p is String ? p : (p['url'] as String? ?? ''))
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }

    final List<String> skills = [];
    if (map['skills'] != null) {
      for (final skill in map['skills']) {
        skills.add(skill);
      }
    }

    final List<Map<String, dynamic>> experience = [];
    if (map['experience'] is List) {
      for (final item in map['experience']) {
        if (item is Map) {
          experience.add(Map<String, dynamic>.from(item));
        }
      }
    }

    final List<Map<String, dynamic>> education = [];
    if (map['education'] is List) {
      for (final item in map['education']) {
        if (item is Map) {
          education.add(Map<String, dynamic>.from(item));
        }
      }
    }

    return UserModel(
      id: map['id'] ?? map['_id'] ?? '',
      email: map['email'] ?? '',
      userName: map['userName'] ?? '',
      fullName: map['fullName'],
      phone: map['phone'],
      profilePic: profilePic,
      location: map['location'],
      isAdmin: map['isAdmin'] ?? false,
      role: UserRole.fromString(map['role']),
      companyName: map['companyName'],
      industry: map['industry'],
      website: map['website'],
      skills: skills,
      experience: experience,
      education: education,
      bio: map['bio'],
      token: map['token'] ?? '',
    );
  }
}

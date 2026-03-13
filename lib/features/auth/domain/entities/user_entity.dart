import 'package:equatable/equatable.dart';
import 'user_role.dart';

/// Pure domain entity — no Flutter, no JSON.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String userName;
  final String? fullName;
  final String? phone;
  final List<String> profilePic;
  final String? location;
  final bool isAdmin;
  final UserRole role;

  // Company-only fields
  final String? companyName;
  final String? industry;
  final String? website;

  final List<String> skills;
  final String? bio;
  final String token;

  const UserEntity({
    required this.id,
    required this.email,
    required this.userName,
    this.fullName,
    this.phone,
    this.profilePic = const [],
    this.location,
    this.isAdmin = false,
    this.role = UserRole.seeker,
    this.companyName,
    this.industry,
    this.website,
    this.skills = const [],
    this.bio,
    this.token = '',
  });

  String get displayName =>
      companyName?.isNotEmpty == true ? companyName! : (fullName?.isNotEmpty == true ? fullName! : userName);

  String? get avatarUrl => profilePic.isNotEmpty ? profilePic.last : null;

  bool get isCompany => role == UserRole.company;
  bool get isSeeker => role == UserRole.seeker;
  bool get isAgent => isCompany; // Backward compatibility

  UserEntity copyWith({
    String? fullName,
    String? phone,
    String? location,
    List<String>? profilePic,
    List<String>? skills,
    UserRole? role,
    String? companyName,
    String? industry,
    String? website,
    String? bio,
    String? token,
  }) =>
      UserEntity(
        id: id,
        email: email,
        userName: userName,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        profilePic: profilePic ?? this.profilePic,
        location: location ?? this.location,
        isAdmin: isAdmin,
        role: role ?? this.role,
        companyName: companyName ?? this.companyName,
        industry: industry ?? this.industry,
        website: website ?? this.website,
        skills: skills ?? this.skills,
        bio: bio ?? this.bio,
        token: token ?? this.token,
      );

  @override
  List<Object?> get props => [
        id,
        email,
        userName,
        fullName,
        phone,
        profilePic,
        location,
        isAdmin,
        role,
        companyName,
        industry,
        website,
        skills,
        bio,
        token,
      ];
}


/// Pure domain entity — no Flutter, no JSON.
class UserEntity {
  final String id;
  final String email;
  final String userName;
  final String? fullName;
  final String? phone;
  final List<String> profilePic;
  final String? location;
  final bool isAdmin;
  final bool isAgent;
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
    this.isAgent = false,
    this.skills = const [],
    this.bio,
    this.token = '',
  });

  String get displayName => fullName?.isNotEmpty == true ? fullName! : userName;
  String? get avatarUrl => profilePic.isNotEmpty ? profilePic.last : null;

  UserEntity copyWith({
    String? fullName, String? phone, String? location,
    List<String>? profilePic, List<String>? skills,
    String? bio, String? token,
  }) => UserEntity(
    id: id, email: email, userName: userName,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    profilePic: profilePic ?? this.profilePic,
    location: location ?? this.location,
    isAdmin: isAdmin, isAgent: isAgent,
    skills: skills ?? this.skills,
    bio: bio ?? this.bio,
    token: token ?? this.token,
  );
}


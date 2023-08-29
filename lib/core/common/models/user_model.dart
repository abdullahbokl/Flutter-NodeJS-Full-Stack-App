import '../../utils/app_strings.dart';

class UserModel {
  final String email;
  final String userName;
  final String? fullName;
  final String? phone;
  final List<String> profilePic;
  final String? location;
  final bool? isAdmin;
  final bool? isAgent;
  final List<String> skills;
  final String? bio;

  UserModel({
    required this.email,
    required this.userName,
    this.fullName,
    this.phone,
    this.profilePic = const [],
    this.location,
    this.isAdmin = false,
    this.isAgent = false,
    this.skills = const [],
    this.bio = "",
  });

  // copy with
  factory UserModel.copyWith(
    UserModel user, {
    String? email,
    String? userName,
    String? fullName,
    String? phone,
    List<String>? profilePic,
    String? location,
    bool? isAdmin,
    bool? isAgent,
    List<String>? skills,
    String? bio,
  }) {
    return UserModel(
      email: email ?? user.email,
      userName: userName ?? user.userName,
      fullName: fullName ?? user.fullName,
      phone: phone ?? user.phone,
      profilePic: profilePic ?? user.profilePic,
      location: location ?? user.location,
      isAdmin: isAdmin ?? user.isAdmin,
      isAgent: isAgent ?? user.isAgent,
      skills: skills ?? user.skills,
      bio: bio ?? user.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppStrings.userEmail: email,
      AppStrings.userUserName: userName,
      AppStrings.userFullName: fullName,
      AppStrings.userPhone: phone,
      AppStrings.userProfilePic: profilePic,
      AppStrings.userLocation: location,
      AppStrings.userIsAdmin: isAdmin,
      AppStrings.userIsAgent: isAgent,
      AppStrings.userSkills: skills,
      AppStrings.userBio: bio,
    };
  }

  factory UserModel.fromMap(dynamic map) {
    final List<String> profilePic = [];
    for (final pic in map[AppStrings.userProfilePic]) {
      // final newImage = ImageModel.fromMap(pic);
      profilePic.add(pic['url']);
    }

    final List<String> skills = [];
    for (final skill in map[AppStrings.userSkills]) {
      skills.add(skill);
    }

    return UserModel(
      email: map[AppStrings.userEmail],
      userName: map[AppStrings.userUserName],
      fullName: map[AppStrings.userFullName],
      phone: map[AppStrings.userPhone],
      profilePic: profilePic,
      location: map[AppStrings.userLocation],
      isAdmin: map[AppStrings.userIsAdmin],
      isAgent: map[AppStrings.userIsAgent],
      skills: skills,
      bio: map[AppStrings.userBio],
    );
  }
}

enum UserRole {
  seeker,
  company,
  admin;

  static UserRole fromString(String? value) {
    if (value == null) return UserRole.seeker;
    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => UserRole.seeker,
    );
  }
}

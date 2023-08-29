class AppStrings {
  // API
  static const String apiBaseUrl = 'http://10.0.2.2:7000/api';
  static const String apiLoginUrl = "$apiBaseUrl/login";
  static const String apiRegisterUrl = "$apiBaseUrl/register";
  static const String apiUsersUrl = "$apiBaseUrl/users";
  static const String apiJobs = "$apiBaseUrl/jobs";
  static const String apiSearch = "$apiBaseUrl/jobs/search";
  static const String apiProfileUrl = "$apiBaseUrl/users";
  static const String apiBookmarkUrl = "$apiBaseUrl/bookmarks";
  static const String apiUploadImageUrl = "$apiBaseUrl/images";

  // shared preferences
  static const String prefsIsFirstTime = 'isFirstTime';
  static const String prefsIsLogin = 'isLogin';

  // user
  static const String userToken = 'token';
  static const String userId = 'id';
  static const String userPassword = 'password';
  static const String userEmail = 'email';
  static const String userUserName = 'userName';
  static const String userFullName = 'fullName';
  static const String userPhone = 'phone';
  static const String userLocation = 'location';
  static const String userSkills = 'skills';
  static const String userProfilePic = 'profilePic';
  static const String userIsAdmin = 'isAdmin';
  static const String userIsAgent = 'isAgent';
  static const String userBio = 'bio';

  // image Model
  static const String imageModelUrl = 'url';
  static const String imageModelUploadedAt = 'uploadedAt';
}

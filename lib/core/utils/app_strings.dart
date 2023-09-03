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
  static const String userBookmarks = 'bookmarks';

// job
  static const String jobId = 'id';
  static const String jobTitle = 'title';
  static const String jobDescription = 'description';
  static const String jobLocation = 'location';
  static const String jobSalary = 'salary';
  static const String jobCompany = 'company';
  static const String jobPeriod = 'period';
  static const String jobContract = 'contract';
  static const String jobRequirements = 'requirements';
  static const String jobImageUrl = 'imageUrl';
  static const String jobAgentId = 'agentId';

  // bookmark
  static const String bookmarkJobId = 'jobId';
  static const String bookmarkCreatedAt = 'createdAt';

  // image Model
  static const String imageModelUrl = 'url';
  static const String imageModelUploadedAt = 'uploadedAt';

  // Hero Tags
  static const String heroTagAvatarImage = 'avatarImage';
}

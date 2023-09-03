import '../../../../../core/common/models/user_model.dart';
import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/logger.dart';
import '../../../../../core/utils/app_strings.dart';
import 'user_repo.dart';

class UserRepoImpl implements UserRepo {
  final ApiServices _apiServices;

  UserRepoImpl(this._apiServices);

  @override
  Future<List<UserModel>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getUser({required String id}) async {
    try {
      final user = await _apiServices.get(
        endPoint: "${AppStrings.apiUsersUrl}/$id",
      );
      return user;
    } catch (e) {
      _getUserLogger("Error getting user: $e");
      rethrow;
    }
  }

  @override
  Future<dynamic> updateUser({
    required Map<String, dynamic> newUserData,
  }) async {
    try {
      final user = await _apiServices.put(
        endPoint: AppStrings.apiUsersUrl,
        data: newUserData,
      );

      _updateProfileLogger("User profile updated successfully");
      return user;
    } catch (e) {
      _updateProfileLogger("Error updating profile: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteUser({required String id}) {
    // TODO: implement deleteProfile
    throw UnimplementedError();
  }

  void _updateProfileLogger(String event) {
    Logger.logEvent(
        className: "UserRepoImpl", event: event, methodName: "updateProfile");
  }

  void _getUserLogger(String event) {
    Logger.logEvent(
        className: "UserRepoImpl", event: event, methodName: "getUser");
  }
}

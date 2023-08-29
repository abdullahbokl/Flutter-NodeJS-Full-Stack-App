import '../../../../../core/common/models/user_model.dart';

abstract class UserRepo {
  Future<dynamic> updateUser({required Map<String, dynamic> newUserData});

  Future<void> deleteUser({required String id});

  Future<dynamic> getUser({required String id});

  Future<List<UserModel>> getAllUsers();
}

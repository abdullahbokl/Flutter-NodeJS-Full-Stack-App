import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';

import '../../data/repositories/auth_repo/auth_repo_impl.dart';
import '../../data/models/login_model.dart';
import '../../data/models/register_model.dart';
import '../../../../core/common/models/user_model.dart';
import '../entities/user_entity.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRepoImpl _legacy;
  AuthRepositoryImpl(this._legacy);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) =>
      _exec(() async {
        final data = await _legacy.login(
            loginModel: LoginModel(email: email, password: password));
        return UserModel.fromMap(data['data']);
      });

  @override
  Future<Either<Failure, UserEntity>> loginWithUsername(
          String userName, String password) =>
      _exec(() async {
        final data = await _legacy.login(
            loginModel: LoginModel(userName: userName, password: password));
        return UserModel.fromMap(data['data']);
      });

  @override
  Future<Either<Failure, UserEntity>> register(
    String userName,
    String email,
    String password, {
    UserRole role = UserRole.seeker,
    String? companyName,
  }) =>
      _exec(() async {
        final data = await _legacy.register(
          registerModel: RegisterModel(
            userName: userName,
            email: email,
            password: password,
            role: role.name,
            companyName: companyName,
          ),
        );
        return UserModel.fromMap(data['data']);
      });

  @override
  Future<Either<Failure, void>> logout() => _exec(() async {
        await _legacy.logout();
      });

  Future<Either<Failure, T>> _exec<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } catch (e) {
      return Left(mapToFailure(e));
    }
  }
}


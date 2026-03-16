import 'package:fpdart/fpdart.dart';

import '../../../../../core/common/models/user_model.dart';
import '../../../../../core/errors/error_mapper.dart';
import '../../../../../core/errors/failures.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../auth_repo/auth_repo_impl.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/user_role.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRepoImpl _legacy;

  AuthRepositoryImpl(this._legacy);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) {
    return _exec(() async {
      final data = await _legacy.login(
        loginModel: LoginModel(email: email, password: password),
      );
      return UserModel.fromMap(data['data']);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithUsername(
    String userName,
    String password,
  ) {
    return _exec(() async {
      final data = await _legacy.login(
        loginModel: LoginModel(userName: userName, password: password),
      );
      return UserModel.fromMap(data['data']);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String userName,
    String email,
    String password, {
    UserRole role = UserRole.seeker,
    String? companyName,
  }) {
    return _exec(() async {
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
  }

  @override
  Future<Either<Failure, void>> logout() {
    return _exec(() async {
      await _legacy.logout();
    });
  }

  Future<Either<Failure, T>> _exec<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

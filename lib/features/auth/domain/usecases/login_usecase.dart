import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String? email;
  final String? userName;
  final String password;

  const LoginParams({
    this.email,
    this.userName,
    required this.password,
  }) : assert(email != null || userName != null);
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    if (params.userName != null) {
      return _repository.loginWithUsername(params.userName!, params.password);
    }
    return _repository.login(params.email!, params.password);
  }
}


import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

import '../entities/user_role.dart';

class RegisterParams {
  final String userName;
  final String email;
  final String password;
  final UserRole role;
  final String? companyName;

  const RegisterParams({
    required this.userName,
    required this.email,
    required this.password,
    this.role = UserRole.seeker,
    this.companyName,
  });
}

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return _repository.register(
      params.userName,
      params.email,
      params.password,
      role: params.role,
      companyName: params.companyName,
    );
  }
}


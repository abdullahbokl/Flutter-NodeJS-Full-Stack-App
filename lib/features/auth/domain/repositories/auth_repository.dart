import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../entities/user_role.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> loginWithUsername(
      String userName, String password);
  Future<Either<Failure, UserEntity>> register(
    String userName,
    String email,
    String password, {
    UserRole role = UserRole.seeker,
    String? companyName,
  });
  Future<Either<Failure, void>> logout();
}


import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> loginWithUsername(String userName, String password);
  Future<Either<Failure, UserEntity>> register(String userName, String email, String password);
  Future<Either<Failure, void>> logout();
}


import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

/// Base use-case interface with a single [call] method.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use when a use-case needs no parameters.
class NoParams {
  const NoParams();
}


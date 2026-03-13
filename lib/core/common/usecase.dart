import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

/// Base use-case interface with a single [call] method.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use when a use-case needs no parameters.
class NoParams {
  const NoParams();
}


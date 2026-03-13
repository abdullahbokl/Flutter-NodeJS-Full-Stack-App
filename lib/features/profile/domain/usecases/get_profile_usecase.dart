import 'package:fpdart/fpdart.dart';

import '../../../../core/common/models/user_model.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/data/repositories/user_repo/user_repo.dart';

class GetProfileUseCase implements UseCase<UserModel, NoParams> {
  final UserRepo _repository;

  const GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserModel>> call(NoParams params) async {
    try {
      final raw = await _repository.getUser(id: 'me');
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      return Right(UserModel.fromMap(data));
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}


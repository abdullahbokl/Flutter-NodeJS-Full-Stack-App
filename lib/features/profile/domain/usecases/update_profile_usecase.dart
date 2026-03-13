import 'package:fpdart/fpdart.dart';

import '../../../../core/common/models/user_model.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/data/repositories/user_repo/user_repo.dart';

class UpdateProfileParams {
  final Map<String, dynamic> updates;

  const UpdateProfileParams(this.updates);
}

class UpdateProfileUseCase implements UseCase<UserModel, UpdateProfileParams> {
  final UserRepo _repository;

  const UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserModel>> call(UpdateProfileParams params) async {
    try {
      final raw = await _repository.updateUser(newUserData: params.updates);
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      return Right(UserModel.fromMap(data));
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}


import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/chat_model.dart';
import '../../data/repositories/chat_repo.dart';

class GetChatsUseCase implements UseCase<List<ChatModel>, NoParams> {
  final ChatRepo _repository;

  const GetChatsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatModel>>> call(NoParams params) async {
    try {
      final chats = await _repository.getAllChats();
      return Right(chats);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}


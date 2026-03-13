import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/chat_model.dart';
import '../../data/repositories/chat_repo.dart';

class CreateOrGetChatParams {
  final String receiverId;

  const CreateOrGetChatParams(this.receiverId);
}

class CreateOrGetChatUseCase
    implements UseCase<ChatModel, CreateOrGetChatParams> {
  final ChatRepo _repository;

  const CreateOrGetChatUseCase(this._repository);

  @override
  Future<Either<Failure, ChatModel>> call(CreateOrGetChatParams params) async {
    try {
      final chat = await _repository.createChat(params.receiverId);
      return Right(chat);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}


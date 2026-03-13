import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repo.dart';

class GetMessagesParams {
  final String chatId;

  const GetMessagesParams(this.chatId);
}

class GetMessagesUseCase implements UseCase<List<MessageModel>, GetMessagesParams> {
  final ChatRepo _repository;

  const GetMessagesUseCase(this._repository);

  @override
  Future<Either<Failure, List<MessageModel>>> call(GetMessagesParams params) async {
    try {
      final messages = await _repository.getMessages(params.chatId);
      return Right(messages);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}


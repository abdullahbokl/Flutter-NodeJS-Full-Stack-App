import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repo.dart';

class SendMessageParams {
  final String chatId;
  final String content;
  final String receiverId;

  const SendMessageParams({
    required this.chatId,
    required this.content,
    required this.receiverId,
  });
}

class SendMessageUseCase implements UseCase<MessageModel, SendMessageParams> {
  final ChatRepo _repository;

  const SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, MessageModel>> call(SendMessageParams params) async {
    try {
      final message = await _repository.sendMessage(
        chatId: params.chatId,
        content: params.content,
        receiverId: params.receiverId,
      );
      return Right(message);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}


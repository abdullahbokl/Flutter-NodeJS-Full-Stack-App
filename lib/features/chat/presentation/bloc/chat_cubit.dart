import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/chat_model.dart';
import '../../domain/usecases/create_or_get_chat_usecase.dart';
import '../../domain/usecases/get_chats_usecase.dart';

class ChatCubit extends Cubit<BaseState<List<ChatModel>>> {
  final GetChatsUseCase _getChats;
  final CreateOrGetChatUseCase _createOrGetChat;

  ChatCubit({
    required GetChatsUseCase getChats,
    required CreateOrGetChatUseCase createOrGetChat,
  })  : _getChats = getChats,
        _createOrGetChat = createOrGetChat,
        super(const InitialState());

  Future<void> loadChats() async {
    emit(const LoadingState());
    final result = await _getChats(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (chats) => emit(chats.isEmpty ? const EmptyState() : SuccessState(chats)),
    );
  }

  Future<ChatModel?> createOrGetChat(String receiverId, {String? jobId}) async {
    final result = await _createOrGetChat(
      CreateOrGetChatParams(receiverId, jobId: jobId),
    );
    return result.fold((_) => null, (chat) => chat);
  }
}


import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/chat_model.dart';
import '../../domain/usecases/create_or_get_chat_usecase.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import 'chat_sync_service.dart';

class ChatCubit extends Cubit<BaseState<List<ChatModel>>> {
  final GetChatsUseCase _getChats;
  final CreateOrGetChatUseCase _createOrGetChat;
  late final StreamSubscription<ChatSyncEvent> _syncSubscription;

  ChatCubit({
    required GetChatsUseCase getChats,
    required CreateOrGetChatUseCase createOrGetChat,
    required ChatSyncService chatSyncService,
  })  : _getChats = getChats,
        _createOrGetChat = createOrGetChat,
        super(const InitialState()) {
    _syncSubscription = chatSyncService.stream.listen(_handleChatSync);
  }

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

  void _handleChatSync(ChatSyncEvent event) {
    if (state is! SuccessState<List<ChatModel>>) return;
    final chats = List<ChatModel>.from(
      (state as SuccessState<List<ChatModel>>).data,
    );
    final index = chats.indexWhere((chat) => chat.id == event.chatId);
    if (index == -1) return;
    final current = chats[index];
    chats[index] = ChatModel(
      id: current.id,
      chatName: current.chatName,
      isGroupChat: current.isGroupChat,
      jobId: current.jobId,
      users: current.users,
      latestMessage: event.message,
      groupAdmin: current.groupAdmin,
    );
    chats.sort((a, b) {
      final aTime = a.latestMessage?.createdAt ?? '';
      final bTime = b.latestMessage?.createdAt ?? '';
      return bTime.compareTo(aTime);
    });
    emit(SuccessState(chats));
  }

  @override
  Future<void> close() async {
    await _syncSubscription.cancel();
    return super.close();
  }
}

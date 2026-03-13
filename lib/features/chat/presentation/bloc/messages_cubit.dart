import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../../core/common/base_state.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/app_session.dart';
import '../../data/models/message_model.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_sync_service.dart';

/// Extends SuccessState to carry a transient send-error without wiping the list.
class MessagesSendError extends SuccessState<List<MessageModel>> {
  final String errorMessage;
  const MessagesSendError(super.data, this.errorMessage);
}

class MessagesCubit extends Cubit<BaseState<List<MessageModel>>> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final ChatSyncService _chatSyncService;

  MessagesCubit({
    required GetMessagesUseCase getMessages,
    required SendMessageUseCase sendMessageUseCase,
    required ChatSyncService chatSyncService,
  })  : _getMessagesUseCase = getMessages,
        _sendMessageUseCase = sendMessageUseCase,
        _chatSyncService = chatSyncService,
        super(const InitialState());

  io.Socket? _socket;
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  Future<void> loadMessages(String chatId) async {
    emit(const LoadingState());
    final result = await _getMessagesUseCase(GetMessagesParams(chatId));
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (messages) =>
          emit(messages.isEmpty ? const EmptyState() : SuccessState(messages)),
    );
  }

  Future<void> sendMessage(String chatId, String receiverId, String content) async {
    final result = await _sendMessageUseCase(
      SendMessageParams(
        chatId: chatId,
        content: content,
        receiverId: receiverId,
      ),
    );
    result.fold(
      (failure) {
        // Preserve the existing list but surface the error to the listener
        final msgs = state is SuccessState<List<MessageModel>>
            ? (state as SuccessState<List<MessageModel>>).data
            : <MessageModel>[];
        emit(MessagesSendError(msgs, failure.message));
      },
      (message) {
        _appendMessage(message);
        _chatSyncService.publish(ChatSyncEvent(chatId: chatId, message: message));
        _socket?.emit('new-message', {
          ...message.toMap(),
          'chat': {'id': chatId},
        });
      },
    );
  }

  void connectSocket(String chatId) {
    _socket?.disconnect();
    _socket = io.io(
      AppConfig.instance.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': AppSession.token})
          .build(),
    );
    _socket!
      ..off('message-received')
      ..off('typing')
      ..off('stop-typing');
    _socket!.connect();
    _socket!.onConnect((_) {
      _socket!.emit('join-chat', chatId);
      _socket!.on('message-received', (data) {
        final msg = MessageModel.fromMap(Map<String, dynamic>.from(data));
        _appendMessage(msg);
        _chatSyncService.publish(ChatSyncEvent(chatId: chatId, message: msg));
      });
      _socket!.on('typing', (_) {
        _isTyping = true;
        // Re-wrap current data so Bloc sees a new state object and rebuilds.
        _reemit();
      });
      _socket!.on('stop-typing', (_) {
        _isTyping = false;
        _reemit();
      });
    });
  }

  void emitTyping(String chatId) => _socket?.emit('typing', {'chatId': chatId});

  void emitStopTyping(String chatId) =>
      _socket?.emit('stop-typing', {'chatId': chatId});

  void _appendMessage(MessageModel msg) {
    final prev = state is SuccessState<List<MessageModel>>
        ? List<MessageModel>.from((state as SuccessState<List<MessageModel>>).data)
        : <MessageModel>[];
    prev.add(msg);
    emit(SuccessState(prev));
  }

  /// Re-emits a fresh state object so Bloc rebuilds for typing indicators.
  void _reemit() {
    if (state is SuccessState<List<MessageModel>>) {
      final data = (state as SuccessState<List<MessageModel>>).data;
      emit(SuccessState(List<MessageModel>.from(data)));
    } else {
      // If not in success state yet, a no-op — typing indicator will show on next message load.
    }
  }

  @override
  Future<void> close() {
    _isTyping = false;
    _socket?.disconnect();
    return super.close();
  }
}

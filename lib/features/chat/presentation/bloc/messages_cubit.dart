import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../../core/common/base_state.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/utils/app_strings.dart';
import '../../data/models/message_model.dart';

class MessagesCubit extends Cubit<BaseState<List<MessageModel>>> {
  MessagesCubit() : super(const InitialState());

  io.Socket? _socket;
  String? _currentChatId;
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  Future<void> loadMessages(String chatId) async {
    _currentChatId = chatId;
    emit(const LoadingState());
    try {
      final raw = await getIt<ApiServices>().get(
          endPoint: '${AppStrings.apiMessagesUrl}/$chatId');
      final list = _parse(raw);
      emit(list.isEmpty ? const EmptyState() : SuccessState(list));
    } catch (e) {
      emit(ErrorState(mapToFailure(e).message));
    }
  }

  Future<void> sendMessage(String chatId, String receiverId, String content) async {
    try {
      final raw = await getIt<ApiServices>().post(
        endPoint: AppStrings.apiMessagesUrl,
        data: {'content': content, 'chatId': chatId, 'receiverId': receiverId},
      );
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      final message = MessageModel.fromMap(Map<String, dynamic>.from(data));
      _appendMessage(message);
      _socket?.emit('new-message', raw is Map ? raw['data'] : raw);
    } catch (e) {
      // message failed — surface error without clearing list
    }
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
    _socket!.connect();
    _socket!.onConnect((_) {
      _socket!.emit('join-chat', chatId);
      _socket!.on('message-received', (data) {
        final msg = MessageModel.fromMap(Map<String, dynamic>.from(data));
        _appendMessage(msg);
      });
      _socket!.on('typing', (_) {
        _isTyping = true;
        emit(state); // rebuild to show typing dots
      });
      _socket!.on('stop-typing', (_) {
        _isTyping = false;
        emit(state);
      });
    });
  }

  void emitTyping(String chatId) => _socket?.emit('typing', chatId);
  void emitStopTyping(String chatId) => _socket?.emit('stop-typing', chatId);

  void _appendMessage(MessageModel msg) {
    final prev = state is SuccessState<List<MessageModel>>
        ? List<MessageModel>.from((state as SuccessState<List<MessageModel>>).data)
        : <MessageModel>[];
    prev.add(msg);
    emit(SuccessState(prev));
  }

  static List<MessageModel> _parse(dynamic raw) {
    final list = raw is Map ? raw['data'] : raw;
    if (list is! List) return [];
    return list.map((e) => MessageModel.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<void> close() {
    _socket?.disconnect();
    return super.close();
  }
}


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_strings.dart';
import '../../data/models/chat_model.dart';

class ChatCubit extends Cubit<BaseState<List<ChatModel>>> {
  ChatCubit() : super(const InitialState());

  Future<void> loadChats() async {
    emit(const LoadingState());
    try {
      final raw = await getIt<ApiServices>().get(endPoint: AppStrings.apiChatsUrl);
      final list = _parse(raw);
      emit(list.isEmpty ? const EmptyState() : SuccessState(list));
    } catch (e) {
      emit(ErrorState(mapToFailure(e).message));
    }
  }

  Future<ChatModel?> createOrGetChat(String receiverId) async {
    try {
      final raw = await getIt<ApiServices>().post(
        endPoint: AppStrings.apiChatsUrl,
        data: {'userId': receiverId},
      );
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      return ChatModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      return null;
    }
  }

  static List<ChatModel> _parse(dynamic raw) {
    final list = raw is Map ? raw['data'] : raw;
    if (list is! List) return [];
    return list.map((e) => ChatModel.fromMap(Map<String, dynamic>.from(e))).toList();
  }
}


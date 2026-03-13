import 'package:equatable/equatable.dart';

import '../../../../core/common/models/user_model.dart';

class MessageEntity extends Equatable {
  final String id;
  final UserModel sender;
  final String content;
  final String? receiver;
  final List<UserModel> readBy;
  final String createdAt;

  const MessageEntity({
    required this.id,
    required this.sender,
    required this.content,
    this.receiver,
    this.readBy = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        sender,
        content,
        receiver,
        readBy,
        createdAt,
      ];
}

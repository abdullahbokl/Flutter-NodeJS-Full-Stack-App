import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/widgets/premium_ui.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../bloc/messages_cubit.dart';

class MessageInputRow extends StatefulWidget {
  final TextEditingController controller;
  final String chatId;
  final VoidCallback onSend;

  const MessageInputRow({
    super.key,
    required this.controller,
    required this.chatId,
    required this.onSend,
  });

  @override
  State<MessageInputRow> createState() => _MessageInputRowState();
}

class _MessageInputRowState extends State<MessageInputRow> {
  bool _hasText = false;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      final hasText = widget.controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        if (hasText) {
          context.read<MessagesCubit>().emitTyping(widget.chatId);
        } else {
          context.read<MessagesCubit>().emitStopTyping(widget.chatId);
        }
      }
      setState(() => _hasText = hasText);
    };
    widget.controller.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => widget.onSend(),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.7),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 48,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _hasText ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: IconButton(
                    onPressed: _hasText ? widget.onSend : null,
                    tooltip: 'Send message',
                    icon: Icon(
                      Icons.send_rounded,
                      color: _hasText ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_hasText) {
      context.read<MessagesCubit>().emitStopTyping(widget.chatId);
    }
    widget.controller.removeListener(_listener);
    super.dispose();
  }
}

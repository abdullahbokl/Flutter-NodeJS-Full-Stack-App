import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../base_state.dart';
import 'empty_state_widget.dart';
import 'error_state_widget.dart';
import 'premium_ui.dart';

/// Maps [BaseState<T>] to the appropriate UI automatically.
class BlocStateWidget<T> extends StatelessWidget {
  final BaseState<T> state;
  final Widget Function(T data) onSuccess;
  final VoidCallback? onRetry;
  final String emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final Widget? loadingWidget;

  const BlocStateWidget({
    super.key,
    required this.state,
    required this.onSuccess,
    this.onRetry,
    this.emptyTitle = 'Nothing here yet',
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      InitialState<T>() || LoadingState<T>() => loadingWidget ??
          const Center(
            child: SizedBox(
              width: 180,
              child: GlassPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 12),
                    Text('Loading...'),
                  ],
                ),
              ),
            ),
          ),
      SuccessState<T>(data: final data) => onSuccess(data),
      EmptyState<T>() => EmptyStateWidget(
          title: emptyTitle,
          subtitle: emptySubtitle,
          icon: emptyIcon,
          actionLabel: onRetry != null ? 'Refresh' : null,
          onAction: onRetry),
      ErrorState<T>(message: final msg) =>
          ErrorStateWidget(message: msg, onRetry: onRetry),
    };
  }
}

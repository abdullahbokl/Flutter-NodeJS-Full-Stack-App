import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import 'app_colors.dart';

class AppSnackBars {
  static void showError(BuildContext context, String message) =>
      _show(context, message, AppColors.error, Icons.error_outline_rounded);

  static void showSuccess(BuildContext context, String message) =>
      _show(context, message, AppColors.success, Icons.check_circle_outline_rounded);

  static void showInfo(BuildContext context, String message,
      {String? actionLabel, VoidCallback? onAction}) {
    final sm = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      backgroundColor: AppColors.info,
      content: Row(children: [
        const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 14))),
      ]),
      action: actionLabel != null
          ? SnackBarAction(label: actionLabel, textColor: Colors.white, onPressed: onAction ?? () {})
          : null,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(sm);
  }

  static void _show(BuildContext ctx, String msg, Color color, IconData icon) {
    ScaffoldMessenger.of(ctx)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        backgroundColor: color,
        content: Row(children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(msg,
              style: const TextStyle(color: Colors.white, fontSize: 14))),
        ]),
        duration: const Duration(seconds: 3),
      ));
  }
}



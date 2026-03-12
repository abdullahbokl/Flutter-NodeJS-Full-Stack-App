import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  static void showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: title,
      titleTextStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      desc: message,
      descTextStyle: const TextStyle(fontSize: 14),
      btnCancelText: cancelLabel,
      btnOkText: confirmLabel,
      btnCancelOnPress: onCancel ?? () {},
      btnOkOnPress: onConfirm ?? () {},
    ).show();
  }

  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onDismiss,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: onDismiss ?? () {},
    ).show();
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }
}


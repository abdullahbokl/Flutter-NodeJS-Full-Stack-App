import 'package:flutter/material.dart';

class Logger {
  static void log(String message) {
    debugPrint(message);
  }

  static void logEvent({
    required String className,
    required String event,
    String? methodName,
  }) {
    debugPrint(
      'Provider: $className, Message: $event, Method: $methodName',
    );
  }
}

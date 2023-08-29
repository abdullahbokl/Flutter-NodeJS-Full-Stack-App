import 'package:flutter/material.dart';

import 'custom_error_widget.dart';

class ErrorWidgetClass extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorWidgetClass(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      errorMessage: errorDetails.exceptionAsString(),
    );
  }
}

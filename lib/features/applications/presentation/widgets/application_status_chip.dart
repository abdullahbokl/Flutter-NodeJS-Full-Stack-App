import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../domain/entities/application_status.dart';

class ApplicationStatusChip extends StatelessWidget {
  final String status;

  const ApplicationStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = ApplicationStatus.normalize(status);
    Color color;
    switch (normalized) {
      case ApplicationStatus.accepted:
        color = Colors.green;
        break;
      case ApplicationStatus.rejected:
        color = Colors.red;
        break;
      case ApplicationStatus.interview:
        color = Colors.deepPurple;
        break;
      case ApplicationStatus.underReview:
        color = Colors.orange;
        break;
      case ApplicationStatus.applied:
      default:
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        ApplicationStatus.label(normalized),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

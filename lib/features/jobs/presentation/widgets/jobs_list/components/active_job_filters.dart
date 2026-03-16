import 'package:flutter/material.dart';

import '../../../../../../core/common/widgets/status_badge.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/job_filter_params.dart';

class ActiveJobFilters extends StatelessWidget {
  final JobFilterParams filters;

  const ActiveJobFilters({
    super.key,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (filters.location?.trim().isNotEmpty == true)
          StatusBadge(
            label: filters.location!.trim(),
            variant: BadgeVariant.info,
          ),
        if (filters.contract?.trim().isNotEmpty == true)
          StatusBadge.contract(filters.contract!.trim()),
        if (filters.minSalary?.trim().isNotEmpty == true)
          StatusBadge(
            label: 'Min \$${filters.minSalary!.trim()}',
            variant: BadgeVariant.neutral,
          ),
        if (filters.maxSalary?.trim().isNotEmpty == true)
          StatusBadge(
            label: 'Max \$${filters.maxSalary!.trim()}',
            variant: BadgeVariant.neutral,
          ),
      ],
    );
  }
}

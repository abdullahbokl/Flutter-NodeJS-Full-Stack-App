import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/premium_ui.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../domain/entities/job_filter_params.dart';
import 'components/active_job_filters.dart';
import 'components/jobs_filter_button.dart';

class JobsBrowseHeader extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocusSearch;
  final JobFilterParams filters;
  final ValueChanged<String> onChanged;
  final Future<void> Function() onClear;
  final Future<void> Function() onFilterTap;
  final VoidCallback onBack;

  const JobsBrowseHeader({
    super.key,
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.autofocusSearch,
    required this.filters,
    required this.onChanged,
    required this.onClear,
    required this.onFilterTap,
    required this.onBack,
  });

  bool get hasActiveFilters =>
      (filters.location?.trim().isNotEmpty == true) ||
      (filters.contract?.trim().isNotEmpty == true) ||
      (filters.minSalary?.trim().isNotEmpty == true) ||
      (filters.maxSalary?.trim().isNotEmpty == true);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: title,
          leadingAction: PageHeaderAction.icon(
            onPressed: onBack,
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
          ),
          density: PageHeaderDensity.compact,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GlassPanel(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: autofocusSearch,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: onClear,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        borderSide: BorderSide.none,
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            JobsFilterButton(
              hasActiveFilters: hasActiveFilters,
              onTap: onFilterTap,
            ),
          ],
        ),
        if (hasActiveFilters) ...[
          const SizedBox(height: AppSpacing.md),
          ActiveJobFilters(filters: filters),
        ],
      ],
    );
  }
}

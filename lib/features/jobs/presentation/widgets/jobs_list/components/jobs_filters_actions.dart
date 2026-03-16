import 'package:flutter/material.dart';

import '../../../../domain/entities/job_filter_params.dart';

class JobsFiltersActions extends StatelessWidget {
  final JobFilterParams filters;
  final VoidCallback onReset;
  final ValueChanged<JobFilterParams> onApply;

  const JobsFiltersActions({
    super.key,
    required this.filters,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onReset,
          child: const Text('Reset'),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => onApply(filters),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

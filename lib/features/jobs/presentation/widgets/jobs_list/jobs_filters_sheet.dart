import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/job_filter_params.dart';
import 'components/jobs_filters_actions.dart';

class JobsFiltersSheet extends StatefulWidget {
  final JobFilterParams initialFilters;

  const JobsFiltersSheet({
    super.key,
    required this.initialFilters,
  });

  @override
  State<JobsFiltersSheet> createState() => _JobsFiltersSheetState();
}

class _JobsFiltersSheetState extends State<JobsFiltersSheet> {
  late final TextEditingController _locationController;
  late final TextEditingController _minSalaryController;
  late final TextEditingController _maxSalaryController;
  late String _contract;

  @override
  void initState() {
    super.initState();
    _locationController =
        TextEditingController(text: widget.initialFilters.location ?? '');
    _minSalaryController =
        TextEditingController(text: widget.initialFilters.minSalary ?? '');
    _maxSalaryController =
        TextEditingController(text: widget.initialFilters.maxSalary ?? '');
    _contract = widget.initialFilters.contract ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Jobs',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _contract.isEmpty ? null : _contract,
            items: const [
              DropdownMenuItem(value: 'full-time', child: Text('Full time')),
              DropdownMenuItem(value: 'part-time', child: Text('Part time')),
              DropdownMenuItem(value: 'contract', child: Text('Contract')),
            ],
            onChanged: (value) => setState(() => _contract = value ?? ''),
            decoration: const InputDecoration(labelText: 'Contract Type'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minSalaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Min Salary'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _maxSalaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Max Salary'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          JobsFiltersActions(
            filters: _buildFilters(),
            onReset: () => Navigator.of(context).pop(const JobFilterParams()),
            onApply: (filters) => Navigator.of(context).pop(filters),
          ),
        ],
      ),
    );
  }

  JobFilterParams _buildFilters() {
    return widget.initialFilters.copyWith(
      location: _locationController.text.trim(),
      contract: _contract,
      minSalary: _minSalaryController.text.trim(),
      maxSalary: _maxSalaryController.text.trim(),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    super.dispose();
  }
}

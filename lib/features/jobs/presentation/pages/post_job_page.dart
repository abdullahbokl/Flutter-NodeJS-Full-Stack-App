import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../bloc/post_job_cubit.dart';

class PostJobPage extends StatefulWidget {
  final JobEntity? job;

  const PostJobPage({super.key, this.job});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _companyController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _contractNotifier = ValueNotifier<String>('full-time');

  bool get _isEditing => widget.job != null;

  @override
  void initState() {
    super.initState();
    final job = widget.job;
    if (job == null) return;
    _titleController.text = job.title;
    _descriptionController.text = job.description;
    _locationController.text = job.location;
    _salaryController.text = job.salary;
    _companyController.text = job.company;
    _requirementsController.text = job.requirements.join(', ');
    _contractNotifier.value = _normalizeContract(job.contract);
  }

  String _normalizeContract(String value) {
    return switch (value.trim().toLowerCase()) {
      'full-time' || 'full time' || 'permanent' => 'full-time',
      'part-time' || 'part time' => 'part-time',
      'contract' => 'contract',
      _ => 'full-time',
    };
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _companyController.dispose();
    _requirementsController.dispose();
    _contractNotifier.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final payload = <String, dynamic>{
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'location': _locationController.text.trim(),
      'salary': _salaryController.text.trim(),
      'company': _companyController.text.trim(),
      'period': _contractNotifier.value,
      'contract': _contractNotifier.value,
      'requirements': _requirementsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    };

    context.read<PostJobCubit>().submitJob(payload, jobId: widget.job?.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostJobCubit, BaseState<JobEntity>>(
      listenWhen: (previous, current) =>
          current is SuccessState<JobEntity> ||
          current is ErrorState<JobEntity>,
      listener: (context, state) {
        if (state is SuccessState<JobEntity>) {
          context.go('/company/manage-jobs');
        } else if (state is ErrorState<JobEntity>) {
          AppSnackBars.showError(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Edit Job' : 'Post Job')),
        body: Form(
          key: _formKey,
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemBuilder: (context, index) => _buildFormItem(index),
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemCount: _formItemCount,
          ),
        ),
      ),
    );
  }

  static const int _formItemCount = 8;

  Widget _buildFormItem(int index) {
    return switch (index) {
      0 => _RequiredJobField(
          controller: _titleController,
          label: 'Job title',
          errorMessage: 'Job title is required',
        ),
      1 => _RequiredJobField(
          controller: _companyController,
          label: 'Company',
          errorMessage: 'Company is required',
        ),
      2 => _RequiredJobField(
          controller: _locationController,
          label: 'Location',
          errorMessage: 'Location is required',
        ),
      3 => _RequiredJobField(
          controller: _salaryController,
          label: 'Salary',
          errorMessage: 'Salary is required',
        ),
      4 => _ContractTypeField(contractNotifier: _contractNotifier),
      5 => _RequiredJobField(
          controller: _descriptionController,
          label: 'Description',
          errorMessage: 'Description is required',
          maxLines: 4,
        ),
      6 => TextFormField(
          controller: _requirementsController,
          decoration: const InputDecoration(
            labelText: 'Requirements (comma separated)',
          ),
        ),
      7 => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: _PostJobSubmitButton(
            isEditing: _isEditing,
            onPressed: _submit,
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _RequiredJobField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String errorMessage;
  final int maxLines;

  const _RequiredJobField({
    required this.controller,
    required this.label,
    required this.errorMessage,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? errorMessage : null,
    );
  }
}

class _ContractTypeField extends StatelessWidget {
  final ValueNotifier<String> contractNotifier;

  const _ContractTypeField({
    required this.contractNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: contractNotifier,
      builder: (context, contract, _) => DropdownButtonFormField<String>(
        initialValue: contract,
        decoration: const InputDecoration(labelText: 'Contract type'),
        items: const [
          DropdownMenuItem(value: 'full-time', child: Text('Full time')),
          DropdownMenuItem(value: 'part-time', child: Text('Part time')),
          DropdownMenuItem(value: 'contract', child: Text('Contract')),
        ],
        onChanged: (value) {
          if (value != null) {
            contractNotifier.value = value;
          }
        },
      ),
    );
  }
}

class _PostJobSubmitButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onPressed;

  const _PostJobSubmitButton({
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PostJobCubit, BaseState<JobEntity>, bool>(
      selector: (state) => state is LoadingState<JobEntity>,
      builder: (context, isLoading) => ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.send_rounded),
        label: Text(
          isLoading
              ? (isEditing ? 'Saving...' : 'Posting...')
              : (isEditing ? 'Save Changes' : 'Post Job'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../bloc/post_job_cubit.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

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

  String _period = 'full-time';
  String _contract = 'permanent';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _companyController.dispose();
    _requirementsController.dispose();
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
      'period': _period,
      'contract': _contract,
      'requirements': _requirementsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    };

    context.read<PostJobCubit>().submitJob(payload);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostJobCubit, BaseState<JobEntity>>(
      listener: (context, state) {
        if (state is SuccessState<JobEntity>) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job posted successfully')),
          );
          context.go('/company/manage-jobs');
        } else if (state is ErrorState<JobEntity>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoadingState<JobEntity>;

        return Scaffold(
          appBar: AppBar(title: const Text('Post Job')),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Job title'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Job title is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(labelText: 'Company'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Company is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Location is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _salaryController,
                  decoration: const InputDecoration(labelText: 'Salary'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Salary is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  initialValue: _period,
                  decoration: const InputDecoration(labelText: 'Work period'),
                  items: const [
                    DropdownMenuItem(value: 'full-time', child: Text('Full-time')),
                    DropdownMenuItem(value: 'part-time', child: Text('Part-time')),
                    DropdownMenuItem(value: 'internship', child: Text('Internship')),
                  ],
                  onChanged: (v) => setState(() => _period = v ?? _period),
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  initialValue: _contract,
                  decoration: const InputDecoration(labelText: 'Contract type'),
                  items: const [
                    DropdownMenuItem(value: 'permanent', child: Text('Permanent')),
                    DropdownMenuItem(value: 'temporary', child: Text('Temporary')),
                    DropdownMenuItem(value: 'freelance', child: Text('Freelance')),
                  ],
                  onChanged: (v) => setState(() => _contract = v ?? _contract),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _requirementsController,
                  decoration: const InputDecoration(
                    labelText: 'Requirements (comma separated)',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : _submit,
                  icon: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(isLoading ? 'Posting...' : 'Post Job'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



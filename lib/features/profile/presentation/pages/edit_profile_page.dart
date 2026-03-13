import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/user_model.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_text_field.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../bloc/profile_cubit.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EditProfileView();
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final _bio = TextEditingController();
  final _companyName = TextEditingController();
  final _industry = TextEditingController();
  final _website = TextEditingController();
  final _experience = TextEditingController();
  final _education = TextEditingController();
  final List<TextEditingController> _skills = [];

  File? _pickedImage;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final state = context.read<ProfileCubit>().state;
      if (state is SuccessState<UserModel>) {
        _loadFromUser(state.data);
      }
      _initialized = true;
    }
  }

  void _loadFromUser(UserModel user) {
    _fullName.text = user.fullName ?? '';
    _phone.text = user.phone ?? '';
    _location.text = user.location ?? '';
    _bio.text = user.bio ?? '';
    _companyName.text = user.companyName ?? '';
    _industry.text = user.industry ?? '';
    _website.text = user.website ?? '';
    _experience.text = user.experience
        .map((item) => _stringValue(item['title']) ?? _stringValue(item['company']) ?? '')
        .where((item) => item.isNotEmpty)
        .join('\n');
    _education.text = user.education
        .map((item) => _stringValue(item['school']) ?? _stringValue(item['degree']) ?? '')
        .where((item) => item.isNotEmpty)
        .join('\n');
    _skills.clear();
    if (user.skills.isEmpty) {
      _skills.add(TextEditingController());
    } else {
      for (final s in user.skills) {
        _skills.add(TextEditingController(text: s));
      }
    }
  }

  String? _stringValue(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null && mounted) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _save(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;

    final updates = <String, dynamic>{
      'fullName': _fullName.text.trim(),
      'phone': _phone.text.trim(),
      'location': _location.text.trim(),
      'bio': _bio.text.trim(),
      'companyName': _companyName.text.trim(),
      'industry': _industry.text.trim(),
      'website': _website.text.trim(),
      'skills': _skills.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList(),
      'experience': _experience.text
          .split('\n')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .map((item) => {'title': item})
          .toList(),
      'education': _education.text
          .split('\n')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .map((item) => {'school': item})
          .toList(),
    };

    await ctx.read<ProfileCubit>().updateProfile(updates);
    if (ctx.mounted) {
      final state = ctx.read<ProfileCubit>().state;
      if (state is SuccessState<UserModel>) {
        AppSnackBars.showSuccess(ctx, 'Profile updated!');
        ctx.pop();
      } else if (state is ErrorState<UserModel>) {
        AppSnackBars.showError(ctx, state.message);
      }
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _location.dispose();
    _bio.dispose();
    _companyName.dispose();
    _industry.dispose();
    _website.dispose();
    _experience.dispose();
    _education.dispose();
    for (final c in _skills) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<ProfileCubit, BaseState<UserModel>>(
        builder: (ctx, state) {
          final isUpdating = state is LoadingState<UserModel>;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // avatar
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _pickedImage != null
                              ? CircleAvatar(
                                  radius: 44,
                                  backgroundImage: FileImage(_pickedImage!),
                                )
                              : AppAvatar(
                                  radius: 44,
                                  imageUrl: state is SuccessState<UserModel>
                                      ? state.data.profilePic.lastOrNull
                                      : null,
                                  fallbackInitials: _fullName.text,
                                ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Personal details
                    AppTextField(
                      label: 'Full Name',
                      controller: _fullName,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Phone',
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Location',
                      controller: _location,
                      prefixIcon: Icons.location_on_outlined,
                      validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                     AppTextField(
                      label: 'Bio',
                      controller: _bio,
                      prefixIcon: Icons.info_outline_rounded,
                      maxLines: 3,
                      validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                    ),
                    if (state is SuccessState<UserModel> && state.data.isCompany) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Company Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Company Name',
                        controller: _companyName,
                        prefixIcon: Icons.business_rounded,
                        validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Industry',
                        controller: _industry,
                        prefixIcon: Icons.category_outlined,
                        validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Website',
                        controller: _website,
                        prefixIcon: Icons.language_outlined,
                        hint: 'https://example.com',
                        validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    // Skills
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Skills', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SkillsList(controllers: _skills, onChanged: () => setState(() {})),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton.icon(
                      onPressed: () => setState(() => _skills.add(TextEditingController())),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Skill'),
                    ),
                    if (!(state is SuccessState<UserModel> && state.data.isCompany)) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        label: 'Experience',
                        hint: 'One role or milestone per line',
                        controller: _experience,
                        prefixIcon: Icons.work_history_outlined,
                        maxLines: 4,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Education',
                        hint: 'One school or degree per line',
                        controller: _education,
                        prefixIcon: Icons.school_outlined,
                        maxLines: 4,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: 'Save Changes',
                      onTap: () => _save(ctx),
                      isLoading: isUpdating,
                      icon: Icons.check_rounded,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SkillsList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onChanged;
  const _SkillsList({required this.controllers, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controllers.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (ctx, i) => Row(
        children: [
          Expanded(
            child: AppTextField(
              label: 'Skill ${i + 1}',
              controller: controllers[i],
              prefixIcon: Icons.star_outline_rounded,
              validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
            ),
          ),
          if (controllers.length > 1) ...[
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded),
              color: Colors.red,
              onPressed: () {
                controllers[i].dispose();
                controllers.removeAt(i);
                onChanged();
              },
            ),
          ],
        ],
      ),
    );
  }
}

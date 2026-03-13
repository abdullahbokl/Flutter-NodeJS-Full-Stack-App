import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_text_field.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/register_cubit.dart';

import '../../domain/entities/user_role.dart';

class RegisterPage extends StatelessWidget {
  final UserRole role;
  const RegisterPage({super.key, this.role = UserRole.seeker});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: _RegisterView(role: role),
    );
  }
}

class _RegisterView extends StatefulWidget {
  final UserRole role;
  const _RegisterView({required this.role});
  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _companyName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, BaseState<UserEntity>>(
      listener: (ctx, state) {
        if (state is ErrorState<UserEntity>) {
          AppSnackBars.showError(ctx, state.message);
        } else if (state is SuccessState<UserEntity>) {
          if (state.data.isCompany) {
            ctx.go('/company/dashboard');
          } else {
            ctx.go('/home');
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: -60,
                left: -80,
                child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withValues(alpha: 0.10)))),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                            widget.role == UserRole.company
                                ? 'Register\nCompany 🏢'
                                : 'Create\nAccount ✨',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w800, height: 1.2))
                        .animate()
                        .fadeIn()
                        .slideX(begin: -0.2),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                            widget.role == UserRole.company
                                ? 'Start hiring top talent today'
                                : 'Join thousands of job seekers today',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary))
                        .animate()
                        .fadeIn(delay: 100.ms),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: Form(
                        key: _form,
                        child: Column(children: [
                          if (widget.role == UserRole.company) ...[
                            AppTextField(
                              label: 'Company Name',
                              hint: 'Acme Corp',
                              controller: _companyName,
                              prefixIcon: Icons.business_outlined,
                              validator: (v) => (v?.length ?? 0) >= 2
                                  ? null
                                  : 'Enter company name',
                            ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          AppTextField(
                            label: 'Username',
                            hint: 'johndoe',
                            controller: _username,
                            prefixIcon: Icons.badge_outlined,
                            validator: (v) => (v?.length ?? 0) >= 3
                                ? null
                                : 'Min 3 characters',
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Email',
                            hint: 'you@example.com',
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (v) => v?.contains('@') == true
                                ? null
                                : 'Enter a valid email',
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: _password,
                            obscureText: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: (v) => (v?.length ?? 0) >= 6
                                ? null
                                : 'Min 6 characters',
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                          const SizedBox(height: AppSpacing.lg),
                          BlocBuilder<RegisterCubit, BaseState<UserEntity>>(
                            builder: (ctx, state) => AppButton(
                              label: 'Create Account',
                              isLoading: state is LoadingState,
                              onTap: () {
                                if (_form.currentState?.validate() == true) {
                                  FocusScope.of(ctx).unfocus();
                                  ctx.read<RegisterCubit>().register(
                                        _username.text.trim(),
                                        _email.text.trim(),
                                        _password.text,
                                        role: widget.role,
                                        companyName: widget.role == UserRole.company ? _companyName.text.trim() : null,
                                      );
                                }
                              },
                            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text('Sign In',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _companyName.dispose();
    super.dispose();
  }
}


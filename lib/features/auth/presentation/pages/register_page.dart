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
import '../../data/repositories/auth_repo/auth_repo_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_impl.dart';
import '../bloc/register_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(AuthRepositoryImpl(getIt<AuthRepoImpl>())),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();
  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, BaseState<UserEntity>>(
      listener: (ctx, state) {
        if (state is ErrorState<UserEntity>) {
          AppSnackBars.showError(ctx, state.message);
        } else if (state is SuccessState<UserEntity>) {
          ctx.go('/home');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(top: -60, left: -80,
              child: Container(width: 220, height: 220,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  color: AppColors.accent.withOpacity(0.10)))),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded)),
                    const SizedBox(height: AppSpacing.md),
                    Text('Create\nAccount ✨',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800, height: 1.2))
                        .animate().fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Join thousands of job seekers today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary))
                        .animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(
                          color: AppColors.accent.withOpacity(0.08),
                          blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Form(
                        key: _form,
                        child: Column(children: [
                          AppTextField(
                            label: 'Username',
                            hint: 'johndoe',
                            controller: _username,
                            prefixIcon: Icons.badge_outlined,
                            validator: (v) => (v?.length ?? 0) >= 3
                                ? null : 'Min 3 characters',
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Email',
                            hint: 'you@example.com',
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (v) => v?.contains('@') == true
                                ? null : 'Enter a valid email',
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: _password,
                            obscureText: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: (v) => (v?.length ?? 0) >= 6
                                ? null : 'Min 6 characters',
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                          const SizedBox(height: AppSpacing.lg),
                          BlocBuilder<RegisterCubit, BaseState<UserEntity>>(
                            builder: (ctx, state) => AppButton(
                              label: 'Create Account',
                              isLoading: state is LoadingState,
                              onTap: () {
                                if (_form.currentState?.validate() == true) {
                                  ctx.read<RegisterCubit>().register(
                                    _username.text.trim(),
                                    _email.text.trim(),
                                    _password.text,
                                  );
                                }
                              },
                            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text('Sign In',
                              style: TextStyle(color: AppColors.primary,
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
    super.dispose();
  }
}

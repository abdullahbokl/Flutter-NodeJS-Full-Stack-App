import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../bloc/login_cubit.dart';
import '../bloc/register_cubit.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_impl.dart';
import '../../../../core/config/app_setup.dart';
import '../../data/repositories/auth_repo/auth_repo_impl.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
          AuthRepositoryImpl(getIt<AuthRepoImpl>())),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();
  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, BaseState<UserEntity>>(
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
            // Background gradient blob
            Positioned(top: -80, right: -60,
              child: Container(width: 260, height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12)))),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    Text('Welcome\nBack 👋',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800, height: 1.2))
                        .animate().fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Sign in to find your perfect job',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary))
                        .animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: AppSpacing.xl),
                    _FormCard(form: _form, email: _email, password: _password),
                    const SizedBox(height: AppSpacing.md),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () => context.go('/register'),
                          child: const Text('Register',
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}

class _FormCard extends StatelessWidget {
  final GlobalKey<FormState> form;
  final TextEditingController email;
  final TextEditingController password;
  const _FormCard({required this.form, required this.email, required this.password});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.08),
              blurRadius: 20, offset: const Offset(0, 8))
        ],
      ),
      child: Form(
        key: form,
        child: Column(children: [
          AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (v) => v?.contains('@') == true ? null : 'Enter a valid email',
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Password',
            hint: '••••••••',
            controller: password,
            obscureText: true,
            prefixIcon: Icons.lock_outline_rounded,
            validator: (v) => (v?.length ?? 0) >= 6 ? null : 'Min 6 characters',
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
          const SizedBox(height: AppSpacing.lg),
          BlocBuilder<LoginCubit, BaseState<UserEntity>>(
            builder: (ctx, state) => AppButton(
              label: 'Sign In',
              isLoading: state is LoadingState,
              onTap: () {
                if (form.currentState?.validate() == true) {
                  ctx.read<LoginCubit>().login(email.text.trim(), password.text);
                }
              },
              icon: Icons.arrow_forward_rounded,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          ),
        ]),
      ),
    );
  }
}


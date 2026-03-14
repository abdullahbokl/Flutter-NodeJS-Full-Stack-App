import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_text_field.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
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
          ctx.go(state.data.isCompany ? '/company/dashboard' : '/home');
        }
      },
      child: PremiumScaffold(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 860;

                  final intro = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Premium hiring,\nwithout the clutter.',
                        style: Theme.of(context).textTheme.displayLarge,
                      ).animate().fadeIn().slideX(begin: -0.05),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Sign in to manage your hiring pipeline, discover roles faster, and keep every conversation in one polished workspace.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).animate().fadeIn(delay: 120.ms),
                      const SizedBox(height: AppSpacing.xl),
                      const GlassPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FeatureLine(icon: Icons.auto_awesome_rounded, text: 'Refined search and premium job cards'),
                            SizedBox(height: AppSpacing.sm),
                            _FeatureLine(icon: Icons.track_changes_rounded, text: 'Application tracking with clearer states'),
                            SizedBox(height: AppSpacing.sm),
                            _FeatureLine(icon: Icons.chat_bubble_outline_rounded, text: 'Faster candidate and recruiter conversations'),
                          ],
                        ),
                      ),
                    ],
                  );

                  final form = GlassPanel(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Use your existing account to continue.', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            label: 'Work Email',
                            hint: 'you@example.com',
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.mail_outline_rounded,
                            validator: (v) => v?.contains('@') == true ? null : 'Enter a valid email',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _password,
                            obscureText: true,
                            prefixIcon: Icons.lock_outline_rounded,
                            validator: (v) => (v?.length ?? 0) >= 6 ? null : 'Min 6 characters',
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(onPressed: () {}, child: const Text('Forgot password?')),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          BlocBuilder<LoginCubit, BaseState<UserEntity>>(
                            builder: (ctx, state) => AppButton(
                              label: 'Sign In',
                              icon: Icons.arrow_forward_rounded,
                              isLoading: state is LoadingState,
                              onTap: () {
                                if (_form.currentState?.validate() == true) {
                                  FocusScope.of(ctx).unfocus();
                                  ctx.read<LoginCubit>().login(_email.text.trim(), _password.text);
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                                child: Text('OR'),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const SocialAuthButtons(),
                          const SizedBox(height: AppSpacing.md),
                          Center(
                            child: TextButton(
                              onPressed: () => context.go('/register'),
                              child: const Text('Need an account? Create one'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);

                  if (wide) {
                    return Row(
                      children: [
                        Expanded(flex: 6, child: Padding(padding: const EdgeInsets.only(right: AppSpacing.xl), child: intro)),
                        Expanded(flex: 5, child: form),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      intro,
                      const SizedBox(height: AppSpacing.xl),
                      form,
                    ],
                  );
                },
              ),
            ),
          ),
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

class _FeatureLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

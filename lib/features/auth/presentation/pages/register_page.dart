import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/app_text_field.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';
import '../bloc/register_cubit.dart';

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
    final isCompany = widget.role == UserRole.company;

    return BlocListener<RegisterCubit, BaseState<UserEntity>>(
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

                  final intro = GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCompany ? 'Set up your hiring command center' : 'Create your next career move',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          isCompany
                              ? 'Launch openings, manage applicants, and keep hiring operations sharp.'
                              : 'Build a profile that feels premium from the very first impression.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ChecklistRow(
                                icon: isCompany ? Icons.dashboard_customize_outlined : Icons.person_search_outlined,
                                title: isCompany ? 'Post and manage roles faster' : 'Discover tailored opportunities',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              _ChecklistRow(
                                icon: Icons.verified_user_outlined,
                                title: isCompany ? 'Review applicants clearly' : 'Track every application state',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              _ChecklistRow(
                                icon: Icons.forum_outlined,
                                title: isCompany ? 'Message candidates directly' : 'Connect with recruiters in one place',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideX(begin: -0.04);

                  final form = GlassPanel(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  isCompany ? 'Company registration' : 'Create account',
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            isCompany
                                ? 'Start with the basics and keep your current business logic untouched.'
                                : 'Create your profile with the same backend flow, now with a stronger visual experience.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (isCompany) ...[
                            AppTextField(
                              label: 'Company Name',
                              hint: 'Acme Studio',
                              controller: _companyName,
                              prefixIcon: Icons.apartment_rounded,
                              validator: (v) => (v?.trim().length ?? 0) >= 2 ? null : 'Enter company name',
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          AppTextField(
                            label: 'Username',
                            hint: 'john_doe',
                            controller: _username,
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (v) => (v?.trim().length ?? 0) >= 3 ? null : 'Min 3 characters',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Email',
                            hint: 'you@example.com',
                            controller: _email,
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => v?.contains('@') == true ? null : 'Enter a valid email',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Password',
                            hint: 'Create a secure password',
                            controller: _password,
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: true,
                            validator: (v) => (v?.length ?? 0) >= 6 ? null : 'Min 6 characters',
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          BlocBuilder<RegisterCubit, BaseState<UserEntity>>(
                            builder: (ctx, state) => AppButton(
                              label: isCompany ? 'Create Company Account' : 'Create Account',
                              isLoading: state is LoadingState,
                              icon: Icons.arrow_forward_rounded,
                              onTap: () {
                                if (_form.currentState?.validate() == true) {
                                  FocusScope.of(ctx).unfocus();
                                  ctx.read<RegisterCubit>().register(
                                        _username.text.trim(),
                                        _email.text.trim(),
                                        _password.text,
                                        role: widget.role,
                                        companyName: isCompany ? _companyName.text.trim() : null,
                                      );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const SocialAuthButtons(),
                          const SizedBox(height: AppSpacing.md),
                          Center(
                            child: TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text('Already have an account? Sign in'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

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
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _companyName.dispose();
    super.dispose();
  }
}

class _ChecklistRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ChecklistRow({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

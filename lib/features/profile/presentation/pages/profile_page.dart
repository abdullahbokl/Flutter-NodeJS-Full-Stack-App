import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/user_model.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/app_chip.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../bloc/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: BlocBuilder<ProfileCubit, BaseState<UserModel>>(
        builder: (context, state) => BlocStateWidget<UserModel>(
          state: state,
          emptyTitle: 'Profile not found',
          onRetry: () => context.read<ProfileCubit>().loadProfile(),
          onSuccess: (user) => ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F7C78), Color(0xFF163047)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      ),
                    ),
                    AppAvatar(
                      imageUrl: user.profilePic.lastOrNull,
                      radius: 42,
                      fallbackInitials: user.fullName ?? user.userName,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      user.fullName ?? user.userName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.82)),
                    ),
                    if (user.isCompany) ...[
                      const SizedBox(height: AppSpacing.sm),
                      const AppChip(label: 'Company Account', isSelected: true),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PremiumSectionHeader(
                eyebrow: 'Profile',
                title: 'Your details',
                subtitle: 'Everything below still reads from the existing profile state.',
                actionLabel: 'Edit',
                onAction: () => context.push('/profile/edit'),
              ),
              const SizedBox(height: AppSpacing.md),
              _InfoCard(user: user),
              if (user.skills.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skills', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: user.skills.map((skill) => AppChip(label: skill, isSelected: true)).toList(),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Edit Profile',
                variant: AppButtonVariant.outline,
                icon: Icons.edit_outlined,
                onTap: () => context.push('/profile/edit'),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Logout',
                variant: AppButtonVariant.danger,
                icon: Icons.logout_rounded,
                onTap: () => AppDialogs.showConfirm(
                  context: context,
                  title: 'Logout',
                  message: 'Are you sure you want to logout?',
                  confirmLabel: 'Logout',
                  onConfirm: () {
                    context.read<ProfileCubit>().logout();
                    context.go('/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final UserModel user;

  const _InfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String)>[
      if (user.companyName?.isNotEmpty == true) ('Company', user.companyName!),
      if (user.industry?.isNotEmpty == true) ('Industry', user.industry!),
      if (user.website?.isNotEmpty == true) ('Website', user.website!),
      if (user.bio?.isNotEmpty == true) ('Bio', user.bio!),
      if (user.location?.isNotEmpty == true) ('Location', user.location!),
      if (user.phone?.isNotEmpty == true) ('Phone', user.phone!),
    ];

    return AppCard(
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 88,
                      child: Text(item.$1, style: Theme.of(context).textTheme.labelMedium),
                    ),
                    Expanded(child: Text(item.$2, style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/user_model.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_chip.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../bloc/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, BaseState<UserModel>>(
        builder: (ctx, state) => BlocStateWidget<UserModel>(
          state: state,
          emptyTitle: 'Profile not found',
          onRetry: () => ctx.read<ProfileCubit>().loadProfile(),
          onSuccess: (user) => _ProfileContent(user: user),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserModel user;
  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        SliverToBoxAdapter(child: _buildInfo(context)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => context.push('/profile/edit'),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            bottom: -36, left: 0, right: 0,
            child: Center(
              child: AppAvatar(
                imageUrl: user.profilePic.lastOrNull,
                radius: 44,
                fallbackInitials: user.fullName ?? user.userName,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xxl, AppSpacing.md, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(user.fullName ?? user.userName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700))
            .animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 4),
        Text(user.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14))
            .animate().fadeIn(delay: 150.ms),
        if (user.isCompany)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.business_rounded, size: 14, color: AppColors.accent),
                const SizedBox(width: 4),
                Text('Company Account', style: TextStyle(fontSize: 12,
                    color: AppColors.accent, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        _InfoCard(user: user),
        if (user.skills.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _SkillsCard(skills: user.skills),
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
      ]),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final UserModel user;
  const _InfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(children: [
        if (user.isCompany) ...[
          if (user.companyName?.isNotEmpty == true)
            _InfoRow(icon: Icons.business_rounded, label: 'Company: ${user.companyName!}'),
          if (user.industry?.isNotEmpty == true)
            _InfoRow(icon: Icons.category_outlined, label: 'Industry: ${user.industry!}'),
          if (user.website?.isNotEmpty == true)
            _InfoRow(icon: Icons.language_outlined, label: 'Website: ${user.website!}'),
          const Divider(),
        ],
        if (user.bio?.isNotEmpty == true) ...[
          _InfoRow(icon: Icons.info_outline_rounded, label: user.bio!),
          const Divider(),
        ],
        if (user.location?.isNotEmpty == true)
          _InfoRow(icon: Icons.location_on_outlined, label: user.location!),
        if (user.phone?.isNotEmpty == true)
          _InfoRow(icon: Icons.phone_outlined, label: user.phone!),
      ]),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary))),
      ]),
    );
  }
}

class _SkillsCard extends StatelessWidget {
  final List<String> skills;
  const _SkillsCard({required this.skills});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Skills', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm,
          children: skills.map((s) => AppChip(label: s, isSelected: true)).toList()),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/base_state.dart';
import '../../../common/bloc/theme_cubit.dart';
import '../../../common/models/user_model.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dialogs.dart';
import '../../../config/app_router.dart';
import '../../../utils/app_session.dart';
import '../../../../features/profile/presentation/bloc/profile_cubit.dart';
import '../app_avatar.dart';

class DrawerScreenBody extends StatelessWidget {
  const DrawerScreenBody({super.key});


  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).matchedLocation;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<ProfileCubit, BaseState<UserModel>>(
                builder: (context, state) {
                  final isCompany = AppSession.isCompany;
                  final navItems = [
                    if (isCompany)
                      const _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: '/company/dashboard')
                    else
                      const _NavItem(icon: Icons.home_rounded, label: 'Home', route: '/home'),
                    const _NavItem(icon: Icons.work_outline_rounded, label: 'Jobs', route: AppRouter.jobsListPage),
                    const _NavItem(icon: Icons.bookmark_rounded,    label: 'Bookmarks', route: '/bookmarks'),
                    if (!isCompany)
                      const _NavItem(
                        icon: Icons.work_history_rounded,
                        label: 'My Applications',
                        route: AppRouter.myApplicationsPage,
                      ),
                    const _NavItem(icon: Icons.chat_bubble_rounded, label: 'Messages',  route: '/chat'),
                    const _NavItem(icon: Icons.person_rounded,      label: 'Profile',   route: '/profile'),
                  ];

                  return Column(
                    children: navItems.map((item) {
                      final selected = current.startsWith(item.route);
                      return _NavTile(
                        item: item,
                        isSelected: selected,
                        onTap: () => context.go(item.route),
                      );
                    }).toList(),
                  );
                },
              ),
              const Spacer(),
              _DarkModeToggle(),
              const SizedBox(height: AppSpacing.md),
              _LogoutButton(),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, BaseState<UserModel>>(
      builder: (context, state) {
        final user = state is SuccessState<UserModel> ? state.data : null;
        return Row(children: [
          AppAvatar(imageUrl: user?.profilePic.lastOrNull, radius: 26,
              fallbackInitials: user?.fullName ?? user?.userName ?? 'U'),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user?.fullName ?? user?.userName ?? '—',
                style: const TextStyle(color: Colors.white, fontSize: 16,
                    fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(user?.email ?? '',
                style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
        ]);
      },
    );
  }
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavTile({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(item.icon,
            color: isSelected ? AppColors.lightPurple : AppColors.textSecondaryDark),
        title: Text(item.label,
            style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 15)),
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
      ),
    );
  }
}

class _DarkModeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return ListTile(
          dense: true,
          leading: const Icon(Icons.dark_mode_rounded, color: AppColors.textSecondaryDark),
          title: const Text('Dark Mode',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14)),
          trailing: Switch(
            value: mode == ThemeMode.dark,
            onChanged: (_) => context.read<ThemeCubit>().toggle(),
            activeThumbColor: AppColors.lightPurple,
          ),
        );
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.logout_rounded, color: AppColors.error),
      title: const Text('Logout',
          style: TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w600)),
      onTap: () => AppDialogs.showConfirm(
        context: context,
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        confirmLabel: 'Logout',
        onConfirm: () => context.go('/login'),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({required this.icon, required this.label, required this.route});
}

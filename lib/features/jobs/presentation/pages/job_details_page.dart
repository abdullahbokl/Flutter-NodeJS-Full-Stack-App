import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../applications/presentation/bloc/application_action_cubit.dart';
import '../../../bookmarks/presentation/bloc/bookmark_status_cubit.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';
import '../../domain/entities/job_entity.dart';
import '../widgets/job_details_body.dart';

class JobDetailsPage extends StatefulWidget {
  final JobEntity job;
  const JobDetailsPage({super.key, required this.job});

  static Widget page({required JobEntity job}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookmarkStatusCubit>(create: (_) => getIt<BookmarkStatusCubit>()),
        BlocProvider<ChatCubit>(create: (_) => getIt<ChatCubit>()),
        BlocProvider<ApplicationActionCubit>(create: (_) => getIt<ApplicationActionCubit>()),
      ],
      child: JobDetailsPage(job: job),
    );
  }

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final GlobalKey<JobDetailsBodyState> _bodyKey = GlobalKey<JobDetailsBodyState>();

  static const double _expandedHeight = 300;

  @override
  void initState() {
    super.initState();
    context.read<BookmarkStatusCubit>().check(widget.job.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: _expandedHeight,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    onTap: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      context.pop();
                    },
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: BlocConsumer<BookmarkStatusCubit, BookmarkStatusState>(
                      listenWhen: (prev, curr) => curr is BookmarkStatusToggled || curr is BookmarkStatusError,
                      listener: (context, state) {
                        if (state is BookmarkStatusToggled) {
                          AppSnackBars.showSuccess(context, state.message);
                        } else if (state is BookmarkStatusError) {
                          AppSnackBars.showError(context, state.message);
                        }
                      },
                      builder: (context, state) {
                        final isBookmarked = switch (state) {
                          BookmarkStatusLoaded s => s.isBookmarked,
                          BookmarkStatusToggled s => s.isBookmarked,
                          _ => false,
                        };

                        return AppCard(
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          onTap: () => context.read<BookmarkStatusCubit>().toggle(widget.job.id),
                          child: Icon(
                            isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final topPadding = MediaQuery.of(context).padding.top;
                    final collapsedTrigger = kToolbarHeight + topPadding + 40;
                    final isCollapsed = constraints.maxHeight <= collapsedTrigger;

                    return FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: isCollapsed ? 1 : 0,
                        child: Text(
                          widget.job.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 88, 24, 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppAvatar(
                                      radius: 26,
                                      imageUrl: widget.job.imageUrl,
                                      fallbackInitials: widget.job.company,
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.job.company,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.job.location,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Colors.white.withValues(alpha: 0.8),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Flexible(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: StatusBadge.contract(widget.job.contract),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  widget.job.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        height: 1.1,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(child: JobDetailsBody(key: _bodyKey, job: widget.job)),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          if (!AppSession.isCompany || widget.job.agentId == AppSession.userId)
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Compensation', style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 4),
                          Text('\$${widget.job.salary}', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        label: widget.job.agentId == AppSession.userId ? 'Edit Job' : 'Apply Now',
                        icon: Icons.arrow_forward_rounded,
                        onTap: () => _bodyKey.currentState?.handlePrimaryAction(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

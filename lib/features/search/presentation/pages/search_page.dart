import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../bloc/search_cubit.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();
  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _buildSearchBar(context),
          const Divider(height: 1),
          Expanded(child: _buildResults()),
        ]),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            autofocus: true,
            onChanged: (q) => context.read<SearchCubit>().search(q),
            decoration: InputDecoration(
              hintText: 'Search jobs, companies...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchCubit>().clear();
                        setState(() {});
                      })
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildResults() {
    return BlocBuilder<SearchCubit, BaseState<List<JobModel>>>(
      builder: (ctx, state) {
        if (state is InitialState) {
          return _EmptySearch();
        }
        return BlocStateWidget<List<JobModel>>(
          state: state,
          emptyTitle: 'No results found',
          emptySubtitle: 'Try different keywords',
          emptyIcon: Icons.search_off_rounded,
          onRetry: () => ctx.read<SearchCubit>().retry(),
          onSuccess: (jobs) => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _SearchResultTile(job: jobs[i])
                .animate().fadeIn(delay: Duration(milliseconds: 40 * i)),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }
}

class _SearchResultTile extends StatelessWidget {
  final JobModel job;
  const _SearchResultTile({required this.job});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => context.go('/jobs/${job.id}', extra: job),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          AppAvatar(radius: 24, imageUrl: job.imageUrl, fallbackInitials: job.company),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(job.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(job.company, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 2),
              Text(job.location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: AppSpacing.sm),
              StatusBadge.contract(job.contract),
            ]),
          ])),
          Text('\$${job.salary}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
        ]),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.search_rounded, size: 64, color: AppColors.primary.withOpacity(0.3)),
        const SizedBox(height: AppSpacing.md),
        const Text('Search for jobs', style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
      ]),
    );
  }
}

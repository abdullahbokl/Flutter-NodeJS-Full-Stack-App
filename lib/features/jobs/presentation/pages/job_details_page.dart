import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/job_entity.dart';
import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/custom_loader.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../bookmarks/presentation/bloc/bookmark_status_cubit.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';
import '../widgets/job_details_body.dart';
import '../../../../core/config/app_setup.dart';

class JobDetailsPage extends StatefulWidget {
  final JobEntity job;
  const JobDetailsPage({super.key, required this.job});

  /// Wraps the page with its required Bloc providers.
  static Widget page({required JobEntity job}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookmarkStatusCubit>(create: (_) => getIt<BookmarkStatusCubit>()),
        BlocProvider<ChatCubit>(create: (_) => getIt<ChatCubit>()),
      ],
      child: JobDetailsPage(job: job),
    );
  }

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Fire once per page instance — prevents spurious snackbars caused by
    // re-registering addPostFrameCallback on every build.
    context.read<BookmarkStatusCubit>().check(widget.job.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            context.pop();
          },
          child: const Icon(Icons.arrow_back_rounded),
        ),
        title: widget.job.title,
        actions: [
          BlocConsumer<BookmarkStatusCubit, BookmarkStatusState>(
            listenWhen: (prev, curr) =>
                curr is BookmarkStatusToggled || curr is BookmarkStatusError,
            listener: (context, state) {
              if (state is BookmarkStatusToggled) {
                AppSnackBars.showSuccess(context, state.message);
              } else if (state is BookmarkStatusError) {
                AppSnackBars.showError(context, state.message);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () =>
                      context.read<BookmarkStatusCubit>().toggle(widget.job.id),
                  child: _buildBookmarkIcon(state),
                ),
              );
            },
          ),
        ],
      ),
      body: JobDetailsBody(job: widget.job),
    );
  }

  Widget _buildBookmarkIcon(BookmarkStatusState state) {
    if (state is BookmarkStatusLoading) {
      return CustomLoader(color: AppColors.dark, size: 20.r);
    }

    final isBookmarked = switch (state) {
      BookmarkStatusLoaded s => s.isBookmarked,
      BookmarkStatusToggled s => s.isBookmarked,
      _ => false,
    };

    return Icon(
      isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
      color: AppColors.lightGreen,
    );
  }
}

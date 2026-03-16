import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/chat/data/models/chat_model.dart';
import '../../../../features/chat/presentation/pages/conversation_page.dart';
import '../../../../features/jobs/domain/entities/job_entity.dart';
import '../../../../features/jobs/presentation/bloc/post_job_cubit.dart';
import '../../../../features/jobs/presentation/pages/job_details_page.dart';
import '../../../../features/jobs/presentation/pages/post_job_page.dart';
import '../../service_locator.dart';
import '../app_route_helpers.dart';
import '../app_route_paths.dart';

List<RouteBase> buildDetailRoutes() {
  return [
    GoRoute(
      path: AppRouter.postJobPage,
      builder: (_, state) => BlocProvider<PostJobCubit>(
        create: (_) => serviceLocator<PostJobCubit>(),
        child: PostJobPage(job: routeExtraOrNull<JobEntity>(state)),
      ),
    ),
    GoRoute(
      path: AppRouter.jobDetailsPage,
      builder: (_, state) =>
          JobDetailsPage.page(job: routeExtraOrNull<JobEntity>(state)!),
    ),
    GoRoute(
      path: AppRouter.chatDetailPage,
      builder: (_, state) => ConversationPage(
        chat: routeExtraOrNull<ChatModel>(state),
      ),
    ),
  ];
}

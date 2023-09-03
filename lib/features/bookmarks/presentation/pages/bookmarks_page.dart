import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/back_home_button.dart';
import '../../../../core/common/widgets/vertical_list_shimmer.dart';
import '../../../../core/config/app_router.dart';
import '../../../home/presentation/widgets/home_job_vertical_card.dart';
import '../manager/bookmark_provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      context.read<BookMarkProvider>().getAllBookmarks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: const BackHomeButton(),
        title: 'Bookmarked Jobs',
      ),
      body: Consumer<BookMarkProvider>(
        builder: (context, bookMarkProvider, child) {
          return bookMarkProvider.isLoading
              ? const VerticalListShimmer()
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: bookMarkProvider.jobs.length,
                  itemBuilder: (context, index) {
                    return HomeJobVerticalCard(
                      job: bookMarkProvider.jobs[index],
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          AppRouter.jobDetailsPage,
                          arguments: bookMarkProvider.jobs[index],
                        ).then((value) {
                          context.read<BookMarkProvider>().getAllBookmarks();
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                );
        },
      ),
    );
  }
}

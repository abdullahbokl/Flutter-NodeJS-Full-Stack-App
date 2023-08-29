import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_constants.dart';
import '../../../jobs/presentation/manager/jobs_provider.dart';
import '../../../profile/presentation/manager/profile_provider.dart';

class HomeProvider extends ChangeNotifier {
  // methods
  loadData(BuildContext context) async {
    try {
      Provider.of<ProfileProvider>(context, listen: false).getUserProfile();
      Provider.of<JobsProvider>(context, listen: false).getAllJobs();
    } catch (e) {
      AppConstants.showAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        dialogTitle: "Error",
        message: e.toString(),
        titleColor: Colors.red,
      );
    }
  }
}

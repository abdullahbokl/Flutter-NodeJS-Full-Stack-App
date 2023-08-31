import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../jobs/presentation/manager/jobs_provider.dart';
import '../../../profile/presentation/manager/profile_provider.dart';

class HomeProvider extends ChangeNotifier {
  // variables
  bool _isLoading = false;

  // getters
  bool get isLoading => _isLoading;

  // setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // methods
  loadData(BuildContext context) async {
    _isLoading = true;
    // isolates
    await Provider.of<JobsProvider>(context, listen: false).getAllJobs();
    if (!context.mounted) return;
    await Provider.of<ProfileProvider>(context, listen: false).getUserProfile();
    _isLoading = false;
    notifyListeners();
  }
}

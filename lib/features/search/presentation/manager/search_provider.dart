import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

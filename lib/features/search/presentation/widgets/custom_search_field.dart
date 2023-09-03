import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_constants.dart';
import '../manager/search_provider.dart';
import 'custom_field.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return CustomField(
      hintText: 'Search for jobs',
      controller: searchProvider.searchController,
      suffixIcon: GestureDetector(
        onTap: () async {
          try {
            await searchProvider.searchJobs();
          } catch (e) {
            if (context.mounted) {
              AppConstants.showSnackBar(
                context: context,
                message: e.toString(),
              );
            }
          }
        },
        child: const Icon(AntDesign.search1),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../managers/drawer_provider.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<DrawerProvider>().currentIndex = 0;
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }
}

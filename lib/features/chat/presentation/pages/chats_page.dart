import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/back_home_button.dart';
import '../../../../core/common/widgets/vertical_list_shimmer.dart';
import '../manager/chat_provider.dart';
import '../widgets/chats_list_view.dart';
import '../widgets/no_chats_widget.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).getAllChats();
      Provider.of<ChatProvider>(context, listen: false).socketConnect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          appBar: customAppBar(
            title: "Chats",
            leading: const BackHomeButton(),
          ),
          body: Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.isLoading) {
                return const VerticalListShimmer();
              } else if (chatProvider.chats.isNotEmpty) {
                return const ChatsListView();
              } else {
                return const NoChatsWidget(message: 'No chats available');
              }
            },
          ),
        );
      },
    );
  }
}

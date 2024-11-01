import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/message/models/message.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/logo.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../theme/colors.dart';
import '../../user/models/user.dart';
import '../providers/messages_provider.dart';
import '../utils/message_utils.dart';
import 'message_screen.dart';
import 'messages_list_screen.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  List<String> tabs = ["People", "Match"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectContactToMessage() async {
    // User? user = await context.pushNamedTo(SelectContactScreen.route);
    // if (user != null) {
    //   if (!mounted) return;
    //   context.pushNamedTo(MessageScreen.route, args: {"userId": user.id});
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final allMessages = ref.read(messagesProvider);
    // final peopleMessages = getGroupedMessages(allMessages, isMatch: false);
    // final matchMessages = getGroupedMessages(allMessages, isMatch: true);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppAppBar(
          hideBackButton: true,
          leading: const Logo(),
          title: "Messages",
          trailing: AppIconButton(
            icon: EvaIcons.search,
            onPressed: () {},
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                dividerColor: transparent,
                tabs: List.generate(
                  tabs.length,
                  (index) {
                    final tab = tabs[index];
                    return Tab(text: tab);
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: List.generate(tabs.length, (index) {
                    return MessagesListScreen(isMatch: index == 1);
                  }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: selectContactToMessage,
          child: const Icon(EvaIcons.message_circle_outline),
        ),
      ),
    );
  }
}

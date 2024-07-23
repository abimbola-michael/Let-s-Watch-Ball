import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/contact/components/contact_item.dart';
import 'package:watchball/features/user/models/user.dart';
import 'package:watchball/features/watch/models/watch_invite.dart';
import 'package:watchball/features/invite/screens/invites_list_screen.dart';
import 'package:watchball/features/match/screens/matches_list_screen.dart';
import 'package:watchball/features/user/screens/users_screen.dart';
import 'package:watchball/features/user/mocks/users.dart';

import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/logo.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_search_bar.dart';
import '../../../theme/colors.dart';

class InvitesScreen extends StatefulWidget {
  const InvitesScreen({super.key});

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen> {
  List<WatchInvite> invites = [];
  List<WatchInvite> awaitingInvites = [];
  List<WatchInvite> missedInvites = [];

  List<String> tabs = [
    "All",
    "Awaiting",
    "Missed",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //invites = allInvites;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppAppBar(
          leading: const Logo(),
          title: "Invites",
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
                    return Tab(
                      text: tab,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: TabBarView(
                  children: List.generate(tabs.length, (index) {
                    return InvitesListScreen(
                        invites: index == 0
                            ? invites
                            : index == 1
                                ? awaitingInvites
                                : missedInvites,
                        isAwaiting: index == 1);
                  }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {},
          child: const Icon(EvaIcons.person_add_outline),
        ),
      ),
    );
  }
}

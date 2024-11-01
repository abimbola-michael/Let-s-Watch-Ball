import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:watchball/features/watch/screens/watchs_history_screen.dart';

import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/logo.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_search_bar.dart';
import '../../../theme/colors.dart';
import '../models/watch.dart';
import '../providers/search_watchs_provider.dart';
import 'invited_watchs_screen.dart';

class WatchsScreen extends ConsumerStatefulWidget {
  const WatchsScreen({super.key});

  @override
  ConsumerState<WatchsScreen> createState() => _WatchsScreenState();
}

class _WatchsScreenState extends ConsumerState<WatchsScreen> {
  List<Watch> watchs = [];
  List<Watch> awaitingWatchs = [];
  //List<Watch> missedWatchs = [];
//"Available"
  List<String> tabs = ["History", "Invited"];
  bool isSearch = false;
  final searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //watchs = allWatchs;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  void startSearch() {
    isSearch = true;
    setState(() {});
  }

  void updateSearch(String value) {
    ref
        .read(searchWatchProvider.notifier)
        .updateSearch(value.trim().toLowerCase());
  }

  void stopSearch() {
    ref.read(searchWatchProvider.notifier).updateSearch("");

    searchController.clear();
    isSearch = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSearch,
      onPopInvoked: (pop) {
        if (pop) return;
        if (isSearch) {
          stopSearch();
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: (isSearch
              ? AppSearchBar(
                  hint: "Search Watchs",
                  controller: searchController,
                  onChanged: updateSearch,
                  onCloseSearch: stopSearch,
                )
              : AppAppBar(
                  hideBackButton: true,
                  leading: const Logo(),
                  title: "Watchs",
                  trailing: AppIconButton(
                    icon: EvaIcons.search,
                    onPressed: startSearch,
                  ),
                )) as PreferredSizeWidget?,
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
                      //final tab = tabs[index];
                      if (index == 0) {
                        return const WatchHistoryScreen();
                      }
                      //if (index == 1) {
                      return const InvitedWatchsScreen();
                      // }
                      // return const AvailableWatchsScreen();
                      // return WatchsListScreen(
                      //     watchs: index == 0
                      //         ? watchs
                      //         : index == 1
                      //             ? awaitingWatchs
                      //             : missedWatchs,
                      //     isAwaiting: index == 1);
                    }),
                  ),
                ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton.small(
          //   onPressed: () {},
          //   child: const Icon(EvaIcons.person_add_outline),
          // ),
        ),
      ),
    );
  }
}

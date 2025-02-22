import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:watchball/features/watch/screens/watchs_history_screen.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/logo.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_search_bar.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import '../models/watch.dart';
import '../providers/invited_watchs_provider.dart';
import '../providers/search_watchs_provider.dart';
import '../providers/watchs_history_provider.dart';
import '../services/watch_service.dart';
import 'invited_watchs_screen.dart';
import 'stream_match_screen.dart';
import 'watch_request_screen.dart';

class WatchsScreen extends ConsumerStatefulWidget {
  const WatchsScreen({super.key});

  @override
  ConsumerState<WatchsScreen> createState() => _WatchsScreenState();
}

class _WatchsScreenState extends ConsumerState<WatchsScreen> {
  List<Watch> historyWatchs = [];
  List<Watch> invitedWatchs = [];
//"Available"
  List<String> tabs = ["History", "Invited"];
  bool isSearch = false;
  final searchController = TextEditingController();
  StreamSubscription? watchSub;
  bool loadingHistoryTop = false;
  bool loadingHistoryBottom = false;
  bool loadingInvitedWatchs = false;
  bool reachedHistoryTop = false;
  bool reachedHistoryBottom = false;
  int limit = 10;
  @override
  void initState() {
    super.initState();
    readLatestWatchHistory();
    readInvitedWatchs();
  }

  @override
  void dispose() {
    watchSub?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void readLatestWatchHistory() async {
    if (reachedHistoryTop) return;
    final watchsBox = Hive.box<String>("watchs");
    historyWatchs = watchsBox.values.map((e) => Watch.fromJson(e)).toList();
    historyWatchs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    ref.read(watchsHistoryProvider.notifier).setWatchs(historyWatchs);

    loadingHistoryTop = true;
    setState(() {});
    final newWatchs = await readWatchHistory(
        firstTime: historyWatchs.isEmpty ? null : historyWatchs.first.createdAt,
        dsc: true,
        limit: historyWatchs.isEmpty ? limit : null);
    await updateWatchsUsers(newWatchs);
    reachedHistoryTop = true;

    for (int i = 0; i < newWatchs.length; i++) {
      final watch = newWatchs[i];
      watchsBox.put(watch.id, watch.toJson());
    }
    historyWatchs.insertAll(0, newWatchs);
    ref.read(watchsHistoryProvider.notifier).setWatchs(historyWatchs);
    loadingHistoryTop = false;

    setState(() {});
  }

  void readMoreWatchHistory() async {
    if (reachedHistoryBottom) return;
    final watchsBox = Hive.box<String>("watchs");

    loadingHistoryBottom = true;
    setState(() {});
    final newWatchs = await readWatchHistory(
        lastTime: historyWatchs.isEmpty ? null : historyWatchs.last.createdAt,
        dsc: true,
        limit: historyWatchs.isEmpty ? limit : null);
    await updateWatchsUsers(newWatchs);
    reachedHistoryBottom = newWatchs.length < limit;

    loadingHistoryBottom = false;

    for (int i = 0; i < newWatchs.length; i++) {
      final watch = newWatchs[i];
      watchsBox.put(watch.id, watch.toJson());
    }
    historyWatchs.addAll(newWatchs);
    ref.read(watchsHistoryProvider.notifier).setWatchs(historyWatchs);

    setState(() {});
  }

  void readInvitedWatchs() async {
    loadingInvitedWatchs = true;
    setState(() {});
    watchSub = readWatchsStream([myId]).listen((watchChanges) async {
      Watch? lastAddedWatch;
      print("watchChanges = $watchChanges");
      for (int i = 0; i < watchChanges.length; i++) {
        final watchChange = watchChanges[i];
        final watch = watchChange.value;
        if (watchChange.added) {
          invitedWatchs.add(watch);
          await updateWatchUsers(watch);
          if (watch.creatorId != myId &&
              !watch.joinedWatchersIds.contains(myId)) {
            lastAddedWatch = watch;
          }
        } else if (watchChange.modified) {
          final index =
              invitedWatchs.indexWhere((element) => element.id == watch.id);
          if (invitedWatchs[index].watchersIds.length !=
              watch.watchersIds.length) {
            await updateWatchUsers(watch);
          }
          if (index != -1) {
            invitedWatchs[index] = watch;
          }
        } else {
          invitedWatchs.removeWhere((element) => element.id == watch.id);
        }
        ref.read(invitedWatchsProvider.notifier).setWatchs(invitedWatchs);
      }
      if (lastAddedWatch != null) {
        viewRequest(lastAddedWatch);
        print("lastAddedWatch = $lastAddedWatch");
      }

      loadingInvitedWatchs = false;
      setState(() {});
    });
  }

  void viewRequest(Watch watch) async {
    if (watch.joinedWatchersIds.contains(myId)) {
      await acceptOrJoinWatch(watch, myId, "audio");
      if (!mounted) return;
      context.pushNamedTo(StreamMatchScreen.route, args: {"watch": watch});
    } else {
      context.pushNamedTo(WatchRequestScreen.route, args: {"watch": watch});
    }
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
                        return WatchHistoryScreen(
                          loadingTop: loadingHistoryTop,
                          loadingBottom: loadingHistoryBottom,
                          onScrolledToBottom: readMoreWatchHistory,
                        );
                      }
                      //if (index == 1) {
                      return InvitedWatchsScreen(loading: loadingInvitedWatchs);
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

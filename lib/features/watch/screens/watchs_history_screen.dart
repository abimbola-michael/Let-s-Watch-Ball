import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/match/utils/match_utils.dart';
import 'package:watchball/features/watch/providers/watchs_history_provider.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/views/empty_list_view.dart';
import '../components/watch_item.dart';
import '../models/watch.dart';
import '../providers/search_watchs_provider.dart';
import 'watch_info_screen.dart';

class WatchHistoryScreen extends ConsumerStatefulWidget {
  final bool loadingTop;
  final bool loadingBottom;
  final VoidCallback onScrolledToBottom;
  const WatchHistoryScreen({
    super.key,
    required this.loadingTop,
    required this.loadingBottom,
    required this.onScrolledToBottom,
  });

  @override
  ConsumerState<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends ConsumerState<WatchHistoryScreen> {
  // List<Watch> watchs = [];
  //bool loading = false, reachedBottom = false, reachedTop = false;
  //int limit = 10;
  //late Box<String> watchsBox;
  @override
  void initState() {
    super.initState();
    //readLatestWatchHistory();
  }

  // void readLatestWatchHistory() async {
  //   watchsBox = Hive.box<String>("watchs");
  //   final savedWatchHistorys =
  //       watchsBox.values.map((e) => Watch.fromJson(e)).toList();
  //   savedWatchHistorys.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  //   loading = true;
  //   setState(() {});
  //   final newWatchs = await readWatchHistory(
  //       firstTime: savedWatchHistorys.isEmpty
  //           ? null
  //           : savedWatchHistorys.first.createdAt,
  //       dsc: true,
  //       limit: savedWatchHistorys.isEmpty ? limit : null);
  //   await updateWatchsUsers(newWatchs);
  //   reachedTop = true;

  //   loading = false;

  //   for (int i = 0; i < newWatchs.length; i++) {
  //     final watch = newWatchs[i];
  //     watchsBox.put(watch.id, watch.toJson());
  //   }
  //   watchs.addAll(newWatchs);
  //   watchs.addAll(savedWatchHistorys);
  //   ref.read(watchsHistoryProvider.notifier).setWatchs(watchs);

  //   setState(() {});
  // }

  // void readMoreWatchHistory() async {
  //   loading = true;
  //   setState(() {});
  //   final newWatchs = await readWatchHistory(
  //       lastTime: watchs.isEmpty ? null : watchs.last.createdAt,
  //       dsc: true,
  //       limit: limit);
  //   await updateWatchsUsers(newWatchs);

  //   reachedBottom = newWatchs.length < limit;

  //   loading = false;
  //   watchs.addAll(newWatchs);
  //   for (int i = 0; i < newWatchs.length; i++) {
  //     final watch = newWatchs[i];
  //     watchsBox.put(watch.id, watch.toJson());
  //   }
  //   ref.read(watchsHistoryProvider.notifier).setWatchs(watchs);

  //   setState(() {});
  // }

  void gotoWatchInfo(Watch watch) {
    context.pushNamedTo(WatchInfoScreen.route, args: {"watch": watch});
  }

  @override
  Widget build(BuildContext context) {
    List<Watch> watchs = ref.watch(watchsHistoryProvider);
    final searchText = ref.watch(searchWatchProvider);
    watchs = watchs.where((watch) {
      final match = getMatchInfo(watch.match);
      final namesString = watch.users.map((user) => user.username).join(" ");
      return match.homeName.toLowerCase().contains(searchText) ||
          match.awayName.toLowerCase().contains(searchText) ||
          match.league.toLowerCase().contains(searchText) ||
          namesString.contains(searchText);
    }).toList();

    return watchs.isEmpty
        ? widget.loadingTop
            ? const Center(child: CircularProgressIndicator())
            : const EmptyListView(message: "No watch")
        : ListView.builder(
            itemCount: watchs.length,
            itemBuilder: (context, index) {
              if (index == watchs.length - 1) {
                widget.onScrolledToBottom();
              }
              final watch = watchs[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.loadingTop) const CircularProgressIndicator(),
                  WatchItem(
                    watch: watch,
                    isHistory: true,
                    onPressed: () => gotoWatchInfo(watch),
                  ),
                  if (widget.loadingBottom) const CircularProgressIndicator(),
                ],
              );
            },
          );
  }
}

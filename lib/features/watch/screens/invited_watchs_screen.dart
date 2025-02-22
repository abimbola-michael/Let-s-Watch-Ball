import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/features/watch/providers/invited_watchs_provider.dart';
import 'package:watchball/features/watch/screens/stream_match_screen.dart';
import 'package:watchball/features/watch/screens/watch_request_screen.dart';
import 'package:watchball/shared/views/loading_overlay.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../../shared/views/empty_list_view.dart';
import '../../match/utils/match_utils.dart';
import '../providers/search_watchs_provider.dart';
import '../services/watch_service.dart';
import '../components/watch_item.dart';

class InvitedWatchsScreen extends ConsumerStatefulWidget {
  final bool loading;
  const InvitedWatchsScreen({
    super.key,
    required this.loading,
  });

  @override
  ConsumerState<InvitedWatchsScreen> createState() =>
      _InvitedWatchsScreenState();
}

class _InvitedWatchsScreenState extends ConsumerState<InvitedWatchsScreen> {
  // List<Watch> watchs = [];
  // bool loading = false;
  // StreamSubscription? watchSub;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //readInvitedWatchs();
  }

  @override
  void dispose() {
    // watchSub?.cancel();
    super.dispose();
  }

  // void readInvitedWatchs() async {
  //   loading = true;
  //   setState(() {});
  //   watchSub = readWatchsStream([myId]).listen((watchChanges) async {
  //     Watch? lastAddedWatch;
  //     print("watchChanges = $watchChanges");
  //     for (int i = 0; i < watchChanges.length; i++) {
  //       final watchChange = watchChanges[i];
  //       final watch = watchChange.value;
  //       if (watchChange.added) {
  //         watchs.add(watch);
  //         await updateWatchUsers(watch);
  //         if (watch.creatorId != myId &&
  //             !watch.joinedWatchersIds.contains(myId)) {
  //           lastAddedWatch = watch;
  //         }
  //       } else if (watchChange.modified) {
  //         final index = watchs.indexWhere((element) => element.id == watch.id);
  //         if (watchs[index].watchersIds.length != watch.watchersIds.length) {
  //           await updateWatchUsers(watch);
  //         }
  //         if (index != -1) {
  //           watchs[index] = watch;
  //         }
  //       } else {
  //         watchs.removeWhere((element) => element.id == watch.id);
  //       }
  //       ref.read(invitedWatchsProvider.notifier).setWatchs(watchs);
  //     }
  //     if (lastAddedWatch != null) {
  //       viewRequest(lastAddedWatch);
  //       print("lastAddedWatch = $lastAddedWatch");
  //     }

  //     if (loading) loading = false;
  //     setState(() {});
  //   });
  // }

  void viewRequest(Watch watch) async {
    if (watch.joinedWatchersIds.contains(myId)) {
      await acceptOrJoinWatch(watch, myId, "audio");
      if (!mounted) return;
      context.pushNamedTo(StreamMatchScreen.route, args: {"watch": watch});
    } else {
      context.pushNamedTo(WatchRequestScreen.route, args: {"watch": watch});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Watch> watchs = ref.watch(invitedWatchsProvider);
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
        ? widget.loading
            ? const Center(child: CircularProgressIndicator())
            : const EmptyListView(message: "No watch")
        : ListView.builder(
            itemCount: watchs.length,
            itemBuilder: (context, index) {
              final watch = watchs[index];
              return WatchItem(
                watch: watch,
                onPressed: () => viewRequest(watch),
              );
            },
          );
  }
}

import 'dart:async';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/match/screens/matches_screen.dart';
import 'package:watchball/features/watch/components/live_player.dart';
import 'package:watchball/features/watch/providers/watch_actionandmatch_provider.dart';
import 'package:watchball/features/watch/providers/watcher_provider.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/app_container.dart';
import '../../../shared/components/columnorrow.dart';
import '../../../theme/colors.dart';
import '../../match/components/live_match_item.dart';
import '../../match/providers/matches_provider.dart';
import '../models/watch.dart';
import 'watch_screen.dart';

class StreamMatchScreen extends ConsumerStatefulWidget {
  static const route = "/stream-match";
  const StreamMatchScreen({super.key});

  @override
  ConsumerState<StreamMatchScreen> createState() => _StreamMatchScreenState();
}

class _StreamMatchScreenState extends ConsumerState<StreamMatchScreen> {
  //match and watch;
  String matchId = "";
  String? streamLink;
  LiveMatch? match;
  Watch? watch;

  bool isFirstTime = true;
  //bool liked = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isFirstTime) {
      final matchId = context.args["matchId"] as String?;
      watch = context.args["watch"] as Watch?;
      this.matchId = matchId ?? watch?.matchId ?? "";
      //getStreamLink();
      isFirstTime = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void toggleMatchLike() {
  //   setState(() {
  //     liked = !liked;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final matches = ref.watch(matchesProvider);
    match = matches.where((element) => element.id == matchId).firstOrNull;

    final actionAndMatch = ref.watch(watchActionAndMatchProvider);
    if (actionAndMatch.match != null && match!.id != actionAndMatch.match!.id) {
      match = actionAndMatch.match!;
      matchId = match!.id;
      setState(() {});
    }
    return Scaffold(
      appBar: AppAppBar(
        title: match != null ? "${match!.homeName} vs ${match!.awayName}" : "",
        subtitle: match?.league,
      ),
      body: ColumnOrRow(
        column: context.isPortrait,
        children: [
          Flexible(
            flex: context.isPortrait ? 0 : 1,
            fit: context.isPortrait ? FlexFit.loose : FlexFit.tight,
            child: match == null ? Container() : LivePlayer(match: match!),
          ),
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, scroll) {
                return [
                  SliverAppBar(
                    expandedHeight: 100,
                    collapsedHeight: 100,
                    backgroundColor: transparent,
                    automaticallyImplyLeading: true,
                    title: Container(),
                    leading: Container(),
                    flexibleSpace: match == null
                        ? null
                        : LiveMatchItem(match: match!, isClickable: false),
                  )
                ];
              },
              body: match == null
                  ? Container()
                  : WatchScreen(match: match!, watch: watch),
            ),
          ),
        ],
      ),
    );
  }
}

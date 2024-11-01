import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:watchball/features/match/utils/match_utils.dart';
import 'package:watchball/shared/components/profile_photo.dart';
import 'package:watchball/shared/views/error_overlay.dart';
import 'package:watchball/shared/views/loading_overlay.dart';
//import 'package:video_player_win/video_player_win.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import '../models/watch.dart';
import '../../../firebase/firestore_methods.dart';
import '../../../utils/utils.dart';
import '../utils/utils.dart';
import 'stream_match_screen.dart';

class WatchRequestScreen extends StatefulWidget {
  static const route = "/watch-request";

  const WatchRequestScreen({super.key});

  @override
  State<WatchRequestScreen> createState() => _WatchRequestScreenState();
}

class _WatchRequestScreenState extends State<WatchRequestScreen> {
  //User? creatorUser;
  //   late List<Watcher> watchers;

  // List<Watcher> currentWatchers = [];
  // List<Watcher> requestedWatchers = [];
  // List<Watcher> invitedWatchers = [];

  final firestoreMethods = FirestoreMethods();
  bool loading = true;
  // late LiveMatch match;

  // String watchLink = "";
  // String? streamLink = "";
  bool isFirstTime = true;
  late Watch watch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //contactWatchers = allContacts;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (isFirstTime) {
      watch = context.args["watch"];
      updateWatchUsers(watch);
      isFirstTime = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void rejectWatch() async {
    setState(() {
      loading = true;
    });
    await rejectOrLeaveWatch(watch, null);
    if (!mounted) return;
    context.pop();
  }

  void acceptWatch() async {
    setState(() {
      loading = true;
    });
    await acceptOrJoinWatch(watch, myId, getCallMode(watch.watchers));
    if (!mounted) return;
    context.pushNamedAndPop(StreamMatchScreen.route, args: {"watch": watch});
  }

  void joinWatch() async {
    setState(() {
      loading = true;
    });
    await requestToJoinWatch(watch);
    if (!mounted) return;
    context.pushNamedAndPop(StreamMatchScreen.route, args: {"watch": watch});
  }

  void cancelJoinWatch() {
    context.pop();
  }

  String getInviteMessage() {
    final match = getMatchInfo(watch.match);

    return "${watch.creatorId == myId ? "You" : watch.creatorUser?.name ?? ""} invited ${watch.users.toStringWithCommaandAnd((user) => user.id == myId ? "you" : (user.username))} to watch ${match.homeName} vs ${match.awayName} match";
  }

  bool get amAWatcher => watch.watchersIds.contains(myId);

  @override
  Widget build(BuildContext context) {
    if (loading) return const LoadingOverlay();

    return Scaffold(
      body: Column(
        children: [
          ProfilePhoto(
              profilePhoto: watch.creatorUser?.photo ?? "",
              name: watch.creatorUser?.name ?? "",
              size: 80),
          const SizedBox(height: 10),
          Text(
            getInviteMessage(),
            style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: AppContainer(
        height: 95,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    bgColor: lightestTint,
                    title: amAWatcher ? "Decline" : "Cancel",
                    onPressed: amAWatcher ? rejectWatch : cancelJoinWatch,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AppButton(
                    title: amAWatcher ? "Accept" : "Join",
                    onPressed: amAWatcher ? acceptWatch : joinWatch,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

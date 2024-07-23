import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:watchball/shared/views/error_overlay.dart';
import 'package:watchball/shared/views/loading_overlay.dart';
//import 'package:video_player_win/video_player_win.dart';
import 'package:watchball/features/match/components/live_match_item.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_back_button.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/watch/components/watcher_heading.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/watch/models/watch_invite.dart';
import 'package:watchball/features/watch/models/watcher.dart';
import 'package:watchball/features/watch/screens/join_watch_screen.dart';
import 'package:watchball/features/watch/screens/invite_watchers_screen.dart';
import 'package:watchball/features/watch/screens/watchers_list_screen.dart';
import 'package:watchball/features/watch/services/live_stream_service.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/features/user/mocks/users.dart';

import '../../match/components/odds_item.dart';
import '../../user/models/user.dart';
import '../models/watch.dart';
import '../../../firebase/firestore_methods.dart';
import '../../user/services/user_service.dart';
import '../../../utils/utils.dart';

class WatchMatchRequestScreen extends StatefulWidget {
  static const route = "/watch-match-request";

  const WatchMatchRequestScreen({super.key});

  @override
  State<WatchMatchRequestScreen> createState() =>
      _WatchMatchRequestScreenState();
}

class _WatchMatchRequestScreenState extends State<WatchMatchRequestScreen> {
  // late FootballMatch match;

  late List<Watcher> watchers;
  User? creatorUser, inviterUser;
  List<Watcher> currentWatchers = [];
  List<Watcher> requestedWatchers = [];
  List<Watcher> invitedWatchers = [];

  final firestoreMethods = FirestoreMethods();
  bool loading = true;
  late LiveMatch match;
  Watch? watch;

  String watchLink = "";
  String? streamLink = "";
  bool isFirstTime = true;
  late WatchInvite invite;
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
      invite = context.args["invite"];
      updateWatch();
      // watch = context.args["watch"];
      // creatorUser = context.args["creatorUser"];
      // watchers = context.args["watchers"];

      // watchLink = "watchball.hms.com/${watch.id}";
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
    await rejectOrLeaveWatch(watch!, null);
    if (!mounted) return;
    context.pop();
  }

  void acceptWatch() async {
    setState(() {
      loading = true;
    });
    await acceptOrJoinWatch(watch!, myId);
    if (!mounted) return;
    context.pop(watch);
  }

  void updateWatch() async {
    watch = await getWatch(invite.watchId);
    if (watch != null) {
      match = watch!.match;
      streamLink = null;
      watchLink = "watchball.hms.com/${watch!.id}";

      for (int i = 0; i < watch!.watchers.length; i++) {
        final watcher = watch!.watchers[i];
        final user = await getUser(watcher.id);
        if (creatorUser == null && watcher.id == watch!.creatorId) {
          creatorUser = user;
        }
        if (inviterUser == null && watcher.id == invite.userId) {
          inviterUser = user;
        }
        watcher.user = user;
        watchers.add(watcher);
        if (watcher.status == "current") {
          currentWatchers.add(watcher);
        } else if (watcher.status == "invite") {
          invitedWatchers.add(watcher);
        } else {
          requestedWatchers.add(watcher);
        }
      }
    }
    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const LoadingOverlay();
    if (watch == null) {
      return const ErrorOverlay(message: "Watch not found");
    }
    return Scaffold(
      appBar: AppAppBar(
        title: "${match.homeName} vs ${match.awayName}",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 35,
                backgroundImage: inviterUser != null
                    ? CachedNetworkImageProvider(inviterUser!.photo)
                    : null,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                inviterUser?.name ?? "",
                style:
                    context.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                match.league,
                style: context.headlineSmall?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              LiveMatchItem(match: match),
              const SizedBox(
                height: 10,
              ),
              WatcherHeading(type: "current", size: currentWatchers.length),
              WatchersListScreen(
                isCreator: false,
                watchers: currentWatchers,
                view: "list",
                type: "current",
                onPressed: (userId) {},
                onRightPressed: (userId) {},
              ),
              WatcherHeading(type: "invited", size: invitedWatchers.length),
              WatchersListScreen(
                isCreator: false,
                watchers: invitedWatchers,
                view: "list",
                type: "invite",
                onPressed: (userId) {},
                onRightPressed: (userId) {},
              ),
            ],
          ),
        ),
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
                    title: "Decline",
                    onPressed: rejectWatch,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AppButton(
                    title: "Watch",
                    onPressed: acceptWatch,
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

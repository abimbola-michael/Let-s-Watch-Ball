import 'dart:async';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/match/utils/match_utils.dart';
import 'package:watchball/features/subscription/constants/constants.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/features/watch/components/watch_item.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/features/watch/screens/watchers_list_screen.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/views/empty_list_view.dart';
import 'package:watchball/shared/views/loading_overlay.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';
import 'package:watchball/utils/webrtc_utils.dart';

import '../../../shared/components/app_button.dart';
import '../../../shared/components/call_action_button.dart';
import '../../../shared/components/custom_gridview.dart';
import '../../../theme/colors.dart';
import '../../../utils/call_utils.dart';
import '../../subscription/screens/subscription_screen.dart';
import '../../subscription/services/services.dart';
import '../../user/models/user.dart';
import '../components/watcher_item.dart';
import '../models/action_and_match.dart';
import '../models/watcher.dart';
import '../providers/player_provider.dart';
import '../providers/watch_actionandmatch_provider.dart';
import '../services/watch_service.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'findorinvite_watchers_screen.dart';
import 'invite_watchers_screen.dart';

class WatchScreen extends ConsumerStatefulWidget {
  final Watch? watch;
  final LiveMatch match;

  const WatchScreen({super.key, this.watch, required this.match});

  @override
  ConsumerState<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen> {
  String matchName = "";
  Watcher? myWatcher;
  String watchId = "";
  Watch? watch;
  late LiveMatch match;
  String watchLink = "";
  int maxWatchers = 4;
  bool loading = false;
  bool calling = false;

  bool isGrid = true;

  StreamSubscription? watchersSub;
  StreamSubscription? watcherSub;

  int watchPosition = 0;
  //late WebRTCCallUtils webRTCCallUtils;
  late CallUtils callUtils;
  StreamSubscription? webRtcSetStateSub;
  //time
  int duration = 0, availableWatchDuration = 0;
  bool isSubscription = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    watch = widget.watch;
    match = widget.match;
    // webRTCCallUtils = WebRTCCallUtils();
    // webRtcSetStateSub = webRTCCallUtils.setStateStream?.listen((callback) {
    //   setState(callback);
    // });
    callUtils = CallUtils();
    webRtcSetStateSub = callUtils.setStateStream?.listen((callback) {
      setState(callback);
    });
    readWatchers();
  }

  @override
  void dispose() {
    watchersSub?.cancel();
    watcherSub?.cancel();
    timer?.cancel();
    //webRTCCallUtils.dispose();
    callUtils.dispose();
    webRtcSetStateSub?.cancel();
    super.dispose();
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  void startTimer() async {
    duration = MAX_WAIT_DURATION;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      watchPosition++;

      if (myWatcher != null) {
        // if still have some watch minute left
        if (myWatcher!.status == "current" && calling) {
          if (availableWatchDuration > 0) {
            availableWatchDuration--;
            // Hive.box<String>("details")
            //     .put("dailyLimit", availableWatchDuration.toString());
            // Hive.box<String>("details").put("dailyLimitDate", timeNow);
          } else {
            context.showSnackBar(
                "${isSubscription ? "Your subscription has expired." : "You have used up your ${MAX_DAILY_LIMIT / 60} mins daily limit"} Please subscribe to continue",
                true);
            await leaveWatch(false);
            gotoSubscription();
          }
        }
        //if passes the wating time
        else if ((myWatcher!.status == "request" || !calling)) {
          if (duration > 0) {
            duration--;
          } else {
            context.showSnackBar(
                myWatcher!.status == "request"
                    ? "Your watch request wasn't accepted"
                    : "Your watch invite wasn't accepted",
                true);
            leaveWatch(false);
          }
        }
      }
      if (!mounted) return;
      setState(() {});
    });
  }

  void seekToWatchPosition(int position) async {
    watchPosition = position;
    final playerController = ref.read(playerProvider);
    if (playerController.desktopPlayer != null) {
      playerController.desktopPlayer?.seek(Duration(seconds: watchPosition));
    } else if (playerController.vlcPlayerController != null) {
      await playerController.vlcPlayerController
          ?.seekTo(Duration(seconds: watchPosition));
    }
  }

  void updateCurrentWatchPosition() async {
    final playerController = ref.read(playerProvider);
    if (playerController.desktopPlayer != null) {
      watchPosition =
          playerController.desktopPlayer?.position.position?.inSeconds ?? 0;
      updateWatchPosition(watchId, watchPosition + 2);
    } else if (playerController.vlcPlayerController != null) {
      final position =
          await playerController.vlcPlayerController?.getPosition();
      watchPosition = position?.inSeconds ?? 0;
      updateWatchPosition(watchId, watchPosition + 2);
    }
  }

  void executeWatcherAction(Watcher watcher, String action) async {
    switch (action) {
      case "Mute":
      case "UnMute":
        final mute = action == "Mute";
        // webRTCCallUtils.togglePeerMute(watcher.id, mute);
        watcher.isAudioOn = !mute;
        setState(() {});
        break;

      case "Sync":
        final index =
            watch!.watchers.indexWhere((element) => element.id == myId);
        watch!.watchers[index].syncUserId = watcher.id;
        setState(() {});
        await updateWatchSync(watchId, watcher.id);
        break;

      case "Accept":
        await acceptOrJoinWatch(
            watch!, watcher.id, watcher.callMode ?? "audio");
        break;

      case "Kickout":
      case "Cancel":
      case "Reject":
        await rejectOrLeaveWatch(watch!, watcher.id);
        break;
    }
  }

  void updateActionOrMatch(ActionAndMatch actionAndMatch) async {
    if (watch == null) return;
    final index = watch!.watchers.indexWhere((element) => element.id == myId);
    if (index == -1) return;
    final watcher = watch!.watchers[index];
    if (actionAndMatch.action != null &&
        watcher.action != actionAndMatch.action) {
      updateMyAction(actionAndMatch.action!);
    }
    if (actionAndMatch.match != null &&
        watcher.match != getMatchString(actionAndMatch.match)) {
      updateMyChangedMatch(getMatchString(actionAndMatch.match));
    }
  }

  void updateMyAction(String action) async {
    if (watch == null) return;

    await updateWatchAction(watchId, action);
    final index = watch!.watchers.indexWhere((element) => element.id == myId);
    if (index == -1) return;
    watch!.watchers[index] = watch!.watchers[index].copyWith(action: action);
    //executeWatchAction();
    if (!mounted) return;
    setState(() {});
  }

  void updateMyChangedMatch(String match) async {
    await updateWatchMatch(watchId, match);

    final index = watch!.watchers.indexWhere((element) => element.id == myId);
    if (index == -1) return;
    watch!.watchers[index] =
        watch!.watchers[index].copyWith(match: match, action: "pause");
    //executeMatchChange();
    setState(() {});
  }

  void readWatchers() async {
    //  if (availableWatchDuration == 0) {
    //   final availableWatch = await getAvailableWatchDuration();
    //   isSubscription = availableWatch.isSubscription;
    //   availableWatchDuration = availableWatch.duration;
    //   if (availableWatchDuration == 0) {
    //     gotoSubscription();
    //     return;
    //   }
    // }
    availableWatchDuration = 100000;

    if (watch == null) return;
    watchId = watch!.id;
    watchLink = getWatchLink(watch!);
    final index = watch!.watchers.indexWhere((element) => element.id == myId);
    if (index == -1) {
      final watcher = await getWatcher(watchId, myId);
      if (watcher != null) {
        final user = await getUser(watcher.id);
        watcher.user = user;
        myWatcher = watcher;
        watch!.watchers.add(watcher);
      }
    } else {
      myWatcher = watch!.watchers[index];
    }
    await watcherSub?.cancel();
    await watchersSub?.cancel();

    if (myWatcher == null) return;
    startTimer();

    if (myWatcher!.status == "request") {
      watcherSub = streamWatcher(watchId, myId).listen((watcher) {
        myWatcher = watcher;
        if (watcher == null) {
          watch = null;
          watchId = "";
          watchLink = "";

          setState(() {});
        } else if (watcher.status == "current") {
          final index =
              watch!.watchers.indexWhere((element) => element.id == myId);
          watch!.watchers[index].status = "current";
          readWatchers();
        }
      });
      return;
    }

    // webRTCCallUtils.init(watchId);
    // webRTCCallUtils.executeCallAction(myWatcher!);
    callUtils.initCall(watchId);
    callUtils.executeCallAction(myWatcher!);

    watchersSub =
        streamChangeWatchers(watch!.id).listen((watcherChanges) async {
      for (int i = 0; i < watcherChanges.length; i++) {
        final watcherChange = watcherChanges[i];
        var watcher = watcherChange.value;
        if (watcherChange.added) {
          final index =
              watch!.watchers.indexWhere((element) => element.id == watcher.id);
          if (index == -1) {
            watch!.watchers.add(watcher);
          } else {
            watcher = watch!.watchers[index];
          }

          if (watcher.user == null) {
            final user = await getUser(watcher.id);
            watcher.user = user;
          }
        } else if (watcherChange.modified) {
          final index =
              watch!.watchers.indexWhere((element) => element.id == watcher.id);
          if (index != -1) {
            final prevWatcher = watch!.watchers[index];
            watcher.user = prevWatcher.user;
            watch!.watchers[index] = watcher;
            if (prevWatcher.syncUserId != watcher.syncUserId) {
              if (watcher.syncUserId == myId) {
                updateCurrentWatchPosition();
              }
            } else if (prevWatcher.watchPosition != watcher.watchPosition) {
              final index =
                  watch!.watchers.indexWhere((element) => element.id == myId);
              final myWatcher = watch!.watchers[index];
              if (watcher.watchPosition != null &&
                  myWatcher.syncUserId == watcher.id) {
                seekToWatchPosition(watcher.watchPosition!);

                updateWatchSync(watchId, null);
                watch!.watchers[index].syncUserId = null;
              }
            }
          }
        } else {
          watch!.watchers.removeWhere((element) => element.id == watcher.id);
        }

        watch!.watchers
            .sort((a, b) => a.status?.compareTo(b.status ?? "") ?? 0);
        if (!calling) {
          calling = (watch!.watchers
                  .where((element) =>
                      element.status == "current" && element.callMode != null)
                  .length >
              1);
          duration = MAX_WAIT_DURATION;
        }
        // executeWatchAction();
        // executeMatchChange();
        callUtils.executeCallAction(watcher, watcherChange.removed);

        // webRTCCallUtils.executeCallAction(watcher, watcherChange.removed);
        setState(() {});
      }
    });
  }

  void addNewWatchers() async {
    if (watch == null) return;
    //"watchers": watch?.watchers ?? [],
    final result = await context
        .pushNamedTo(InviteWatchersScreen.route, args: {"watch": watch});
    if (result != null) {
      final selectedUsers = result["watchers"] as List<User>;
      if (selectedUsers.isNotEmpty) {
        //webRTCCallUtils.callMode
        addWatchers(watch!, selectedUsers, [], callUtils.callMode);
      }
    }
  }

  void gotoSubscription() async {
    await context.pushNamedTo(SubscriptionScreen.route);
  }

  void createNewWatch(String callMode) async {
    // final availableWatch = await getAvailableWatchDuration();
    // isSubscription = availableWatch.isSubscription;
    // availableWatchDuration = availableWatch.duration;

    // if (availableWatchDuration == 0) {
    //   gotoSubscription();
    //   return;
    // }
    //availableWatchDuration = 100000;

    if (!mounted) return;
    final result = await context
        .pushNamedTo(InviteWatchersScreen.route, args: {"watch": watch});
    if (result != null) {
      final selectedUsers = result["watchers"] as List<User>;
      //print("selectedUsers = $selectedUsers");
      if (selectedUsers.isNotEmpty) {
        loading = true;
        setState(() {});
        watch = await createWatch(match, selectedUsers, callMode);
        loading = false;
        setState(() {});
        readWatchers();
      }
    }
  }

  Future leaveWatch([bool showComfirmation = true]) async {
    if (watch == null) return;

    if (showComfirmation) {
      final result = await context.showComfirmationDialog(
          "Leave Watch", "Are you sure you want to leave watch");
      if (!result) return;
    }
    stopTimer();

    loading = true;
    setState(() {});

    if (calling) {
      if (isSubscription) {
        if (availableWatchDuration <= 0) {
          await resetSubscription();
        }
      } else {
        await updateDailyLimit(availableWatchDuration);
      }
    }

    await removeWatchers(watch!, [myId], myId);
    callUtils.leaveCall();
    //webRTCCallUtils.leaveCall();
    watchersSub?.cancel();
    watchersSub = null;
    watchId = "";
    loading = false;
    myWatcher = null;
    watch = null;
    setState(() {});
    //readWatchers();
  }

  void cancelWatch() {}

  void shareWatchLink() {}

  void toggleListGrid() {
    isGrid = !isGrid;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final actionAndMatch = ref.watch(watchActionAndMatchProvider);
    updateActionOrMatch(actionAndMatch);
    return LoadingOverlay(
      loading: loading,
      child: Column(
        children: [
          if (watch != null && myWatcher != null) ...[
            myWatcher!.status == "request"
                ? WatchItem(watch: watch!)
                : Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${watch!.watchers.length} Watchers",
                              style: context.bodyMedium,
                            ),
                            Text(
                              calling
                                  ? "Watching... ${durationToString(availableWatchDuration)}"
                                  : "Waiting... ${durationToString(duration)}",
                              style: context.bodySmall?.copyWith(
                                  color: calling
                                      ? availableWatchDuration < 5 * 60
                                          ? Colors.red
                                          : primaryColor
                                      : tint),
                            ),
                          ],
                        ),
                      ),
                      if (watch!.watchers.length < maxWatchers) ...[
                        IconButton(
                          onPressed: addNewWatchers,
                          icon: const Icon(EvaIcons.person_add),
                        ),
                        IconButton(
                          onPressed: shareWatchLink,
                          icon: const Icon(EvaIcons.share),
                        )
                      ],
                      IconButton(
                        onPressed: toggleListGrid,
                        icon: Icon(
                            isGrid
                                ? EvaIcons.list_outline
                                : EvaIcons.grid_outline,
                            size: 20,
                            color: white),
                      ),
                    ],
                  )
          ],
          Expanded(
              child: watch == null || myWatcher == null
                  ? const EmptyListView(message: "No watch")
                  : myWatcher!.status == "request"
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Waiting to be let in ...",
                                  style: context.bodyMedium),
                              Text(
                                  "Watch is being notified. Kindly wait to be let in if the creator accepts",
                                  style: context.bodySmall?.copyWith(
                                    color: lighterTint,
                                  )),
                            ],
                          ),
                        )
                      : CustomGridview(
                          gridCount: isGrid ? 2 : 1,
                          shrinkWrap: true,
                          itemCount: watch!.watchers.length,
                          itemBuilder: (context, index) {
                            final watcher = watch!.watchers[index];

                            return WatcherItem(
                              isCreator: watch!.creatorId == myId,
                              isGrid: isGrid,
                              watcher: watcher,
                              videoRenderer: watcher.id == myId
                                  ? callUtils.getMyRenderer()
                                  : callUtils.getPeerRenderer(watcher.id),
                              // videoRenderer: watcher.id == myId
                              //     ? webRTCCallUtils.getMyRenderer()
                              //     : webRTCCallUtils.getPeerRenderer(watcher.id),
                              onPressed: (action) =>
                                  executeWatcherAction(watcher, action),
                            );
                          },
                        )
              // : WatchersListScreen(
              //     watchers: watch!.watchers,
              //     remoteRenderers: _remoteRenderers,
              //     view: view,
              //     onPressed: executeWatcherAction,
              //     isCreator: watch!.creatorId == myId,
              //   ),
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: watch == null || myWatcher == null
                  ? [
                      Expanded(
                        child: AppButton(
                          bgColor: lightestTint,
                          title: "Audio Watch",
                          onPressed: () => createNewWatch("audio"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          bgColor: lightestTint,
                          title: "Video Watch",
                          onPressed: () => createNewWatch("video"),
                        ),
                      )
                    ]
                  : myWatcher!.status == "request"
                      ? [
                          Expanded(
                            child: AppButton(
                              bgColor: lightestTint,
                              title: "Cancel Request",
                              onPressed: () => leaveWatch(),
                            ),
                          )
                        ]
                      : [
                          CallActionButton(
                            icon: EvaIcons.phone_off,
                            bgColor: Colors.red,
                            onPressed: leaveWatch,
                          ),
                          CallActionButton(
                            icon: EvaIcons.video,
                            selected: callUtils.callMode == "video",
                            onPressed: callUtils.toggleCallMode,
                          ),
                          if (callUtils.callMode == "video") ...[
                            CallActionButton(
                              icon: EvaIcons.flip,
                              onPressed: callUtils.switchCamera,
                            ),
                          ],
                          CallActionButton(
                            icon: EvaIcons.speaker,
                            selected: callUtils.isOnSpeaker,
                            onPressed: callUtils.toggleSpeaker,
                          ),
                          CallActionButton(
                              icon: EvaIcons.mic_off,
                              selected: !callUtils.isAudioOn,
                              onPressed: callUtils.toggleMic),
                          CallActionButton(
                            icon: EvaIcons.phone_off,
                            selected: callUtils.isOnHold,
                            onPressed: callUtils.toggleHold,
                          ),
                          // CallActionButton(
                          //   icon: EvaIcons.phone_off,
                          //   bgColor: Colors.red,
                          //   onPressed: leaveWatch,
                          // ),
                          // CallActionButton(
                          //   icon: EvaIcons.video,
                          //   selected: webRTCCallUtils.callMode == "video",
                          //   onPressed: webRTCCallUtils.startCall,
                          // ),
                          // if (webRTCCallUtils.callMode == "video") ...[
                          //   CallActionButton(
                          //     icon: EvaIcons.flip,
                          //     onPressed: webRTCCallUtils.toggleCamera,
                          //   ),
                          // ],
                          // CallActionButton(
                          //   icon: EvaIcons.speaker,
                          //   selected: webRTCCallUtils.isSpeakerOn,
                          //   onPressed: webRTCCallUtils.toggleSpeaker,
                          // ),
                          // CallActionButton(
                          //     icon: EvaIcons.mic_off,
                          //     selected: !webRTCCallUtils.isAudioOn,
                          //     onPressed: webRTCCallUtils.updateMyCallAudio),
                          // CallActionButton(
                          //   icon: EvaIcons.phone_off,
                          //   selected: webRTCCallUtils.isOnHold,
                          //   onPressed: webRTCCallUtils.updateMyCallHold,
                          // ),
                        ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/match/utils/match_utils.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import '../../match/enums/enums.dart';
import '../../match/screens/matches_screen.dart';
import '../providers/player_provider.dart';
import '../providers/watch_actionandmatch_provider.dart';
import '../services/live_stream_service.dart';
import 'vlc/vlc_player_with_controls.dart';

class LivePlayer extends ConsumerStatefulWidget {
  final LiveMatch match;
  const LivePlayer({super.key, required this.match});

  @override
  ConsumerState<LivePlayer> createState() => _LivePlayerState();
}

class _LivePlayerState extends ConsumerState<LivePlayer> {
  String? streamUrl;
  bool loading = false, paused = false;
  bool isRemainingDuration = false;
  bool isLive = false;
  bool addedListener = false;
  int skipSeconds = 10;

  late LiveMatch match;
  Player? desktopPlayer;
  VlcPlayerController? vlcPlayerController;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    match = widget.match;
    isLive = getMatchStatus(match.status) == MatchStatus.live;
  }

  @override
  void dispose() {
    desktopPlayer?.dispose();
    vlcPlayerController?.stopRendererScanning();
    vlcPlayerController?.dispose();

    super.dispose();
  }

  void startStreaming() async {
    loading = true;
    setState(() {});
    final matchId = widget.match.id;
    final result = await getLiveStream(matchId);
    if (result.isEmpty) {
      streamUrl = "";
    } else {
      String? link = result[0].streamLink;
      if (link == "null") {
        link = null;
      }
      streamUrl = link ?? "";
    }
    if (!mounted) return;
    loading = false;

    if (streamUrl!.isEmpty) {
      setState(() {});
      return;
    }
    if (!kIsWeb && !isAndroidAndIos) {
      desktopPlayer ??= Player(id: 0, commandlineArguments: [
        ':network-caching=2000', // Increase caching to avoid stutters
        ':sout-transcode-vcodec=mp4v', // Set a lower resolution codec if supported
        ':sout-transcode-width=640', // Reduce resolution width
        ':sout-transcode-height=360', // Reduce resolution height
      ]);
      desktopPlayer!.open(
        Media.network(streamUrl, parse: true),
        autoStart: true,
      );

      ref.read(playerProvider.notifier).updateDesktopPlayer(desktopPlayer);
      setState(() {});
      return;
    }

    vlcPlayerController = VlcPlayerController.network(
      streamUrl!,
      autoPlay: false,
      options: VlcPlayerOptions(
        sout: VlcStreamOutputOptions([
          '--sout-transcode-vcodec=mp4v', // Set to a lower quality codec if supported
          '--sout-transcode-width=640', // Lower resolution width
          '--sout-transcode-height=360', // Lower resolution height
        ]),
        extras: ['--network-caching=2000'], // Extra option to increase caching
        // advanced: VlcAdvancedOptions([
        //   VlcAdvancedOptions.networkCaching(
        //       1500), // Increase caching to avoid stutters
        // ]),
        video: VlcVideoOptions([
          VlcVideoOptions.dropLateFrames(
              true), // Optional: Helps smooth playback in some cases
          VlcVideoOptions.skipFrames(
              true), // Enable frame skipping for lower-quality playback
        ]),

        //   sout: [
        //   VlcStreamOutputOptions(
        //     isNetworkCaching: true,
        //     networkCaching: 3000, // Adjust as needed
        //   ),
        // ]
      ),
    );

    ref
        .read(playerProvider.notifier)
        .updateVlcPlayerController(vlcPlayerController);
    setState(() {});
  }
  // void restart() async {
  //   if (winVideoPlayerController == null) return;
  //   final comfirm = await context.showComfirmationDialog(
  //       "Restart Match", "Are you want to restart match");
  //   if (!comfirm) return;

  //   winVideoPlayerController!.seekTo(const Duration(seconds: 0));
  //   ref.read(watchActionAndMatchProvider.notifier).updateAction("restart");
  // }

  // void rewind() {
  //   if (winVideoPlayerController == null) return;
  //   final prevPosition =
  //       winVideoPlayerController!.value.position.inSeconds - skipSeconds;
  //   winVideoPlayerController!
  //       .seekTo(Duration(seconds: prevPosition < 0 ? 0 : prevPosition));
  // }

  // void togglePlayPause() async {
  //   if (winVideoPlayerController == null) return;

  //   setState(() {
  //     paused = !paused;
  //   });

  //   if (paused) {
  //     winVideoPlayerController!.pause();
  //   } else {
  //     winVideoPlayerController!.play();
  //   }

  //   ref
  //       .read(watchActionAndMatchProvider.notifier)
  //       .updateAction(paused ? "pause" : "start");
  // }

  // void forward() {
  //   if (winVideoPlayerController == null) return;

  //   final nextPosition =
  //       winVideoPlayerController!.value.position.inSeconds + skipSeconds;
  //   winVideoPlayerController!.seekTo(Duration(
  //       seconds:
  //           nextPosition > winVideoPlayerController!.value.duration.inSeconds
  //               ? winVideoPlayerController!.value.duration.inSeconds
  //               : nextPosition));
  // }

  // void changeMatch() async {
  //   final comfirm = await context.showComfirmationDialog(
  //       "Change Match", "Are you want to change match");
  //   if (!comfirm || !mounted) return;
  //   context.pushTo(MatchesScreen(
  //     onSelect: (match) {
  //       ref.read(watchActionAndMatchProvider.notifier).updateMatch(match);
  //       this.match = match;
  //       setState(() {});
  //       getstreamUrl();
  //     },
  //   ));
  // }

  // void toggleTimeEndAndLive() {
  //   if (winVideoPlayerController == null) return;

  //   if (isLive) {
  //     winVideoPlayerController!
  //         .seekTo(winVideoPlayerController!.value.duration);
  //   } else {
  //     setState(() {
  //       isRemainingDuration = !isRemainingDuration;
  //     });
  //   }
  // }

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (vlcPlayerController != null)
                  SizedBox.expand(
                    child: VlcPlayerWithControls(
                      controller: vlcPlayerController!,
                      onStopRecording: (value) {},
                      isFullScreen: isFullScreen,
                      onViewFullScreen: toggleFullScreen,
                    ),
                  )
                else if (desktopPlayer != null)
                  Video(
                    player: desktopPlayer,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                if (loading)
                  const CircularProgressIndicator()
                else if (streamUrl == null)
                  IconButton(
                    onPressed: startStreaming,
                    icon: const Icon(
                      EvaIcons.play_circle_outline,
                      size: 50,
                    ),
                  )
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       if (winVideoPlayerController != null)
        //         Row(
        //           children: [
        //             Text(
        //               _formatDuration(winVideoPlayerController!.value.position),
        //               style: context.bodySmall
        //                   ?.copyWith(fontSize: 10, color: tint),
        //             ),
        //             Expanded(child: Container()),
        //             // Expanded(
        //             //   child: VideoProgressIndicator(
        //             //     winVideoPlayerController!,
        //             //     allowScrubbing: true,
        //             //     padding: const EdgeInsets.symmetric(horizontal: 4),
        //             //   ),
        //             // ),
        //             GestureDetector(
        //               onTap: toggleTimeEndAndLive,
        //               child: Text(
        //                 isLive
        //                     ? "Live"
        //                     : _formatDuration(isRemainingDuration
        //                         ? winVideoPlayerController!.value.duration -
        //                             winVideoPlayerController!.value.position
        //                         : winVideoPlayerController!.value.duration),
        //                 style: context.bodySmall?.copyWith(
        //                     fontSize: 10, color: isLive ? Colors.red : tint),
        //               ),
        //             ),
        //           ],
        //         ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: [
        //           // IconButton(
        //           //   onPressed: toggleMatchLike,
        //           //   icon: Icon(
        //           //     liked ? EvaIcons.heart : EvaIcons.heart_outline,
        //           //     color: liked ? Colors.red : tint,
        //           //   ),
        //           // ),
        //           IconButton(
        //             onPressed: restart,
        //             icon: Icon(
        //               EvaIcons.refresh_outline,
        //               color: tint,
        //               size: 16,
        //             ),
        //           ),
        //           IconButton(
        //             onPressed: rewind,
        //             icon: Icon(
        //               EvaIcons.rewind_left_outline,
        //               color: tint,
        //               size: 20,
        //             ),
        //           ),
        //           IconButton(
        //             onPressed: togglePlayPause,
        //             icon: Icon(
        //               paused
        //                   ? EvaIcons.play_circle_outline
        //                   : EvaIcons.pause_circle_outline,
        //               color: tint,
        //               size: 50,
        //             ),
        //           ),
        //           IconButton(
        //             onPressed: forward,
        //             icon: Icon(
        //               EvaIcons.rewind_right_outline,
        //               color: tint,
        //               size: 20,
        //             ),
        //           ),
        //           IconButton(
        //             onPressed: changeMatch,
        //             icon: Icon(
        //               EvaIcons.more_horizontal_outline,
        //               color: tint,
        //               size: 20,
        //             ),
        //           ),
        //         ],
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }
}

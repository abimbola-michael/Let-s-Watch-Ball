import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/profile_photo.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../user/models/user.dart';
import '../models/watcher.dart';
import '../../user/mocks/users.dart';

class WatcherItem extends StatelessWidget {
  final RTCVideoRenderer? videoRenderer;
  final Watcher watcher;
  final void Function(String action) onPressed;
  final bool isCreator;
  final bool isGrid;

  const WatcherItem(
      {super.key,
      required this.watcher,
      required this.onPressed,
      required this.isCreator,
      required this.isGrid,
      this.videoRenderer});

  List<String> getOptions() {
    List<String> options = [];
    final type = watcher.status;

    if (isCreator && watcher.id != myId) {
      if (type == "request") {
        options.add("Accept");
      }
      options.add(type == "current"
          ? "Kickout"
          : type == "invite"
              ? "Cancel"
              : "Reject");
    }
    if (type == "current") {
      options.add("Sync");
    }
    if (watcher.callMode != null) {
      options.addAll([watcher.isAudioOn == true ? "UnMute" : "Mute"]);
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    if (watcher.user == null) {
      return Container();
    }
    final user = watcher.user!;
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
              color: (watcher.audioLevel ?? 0) > 0
                  ? primaryColor
                  : Colors.transparent,
              width: 2),
        ),
        child: Stack(
          children: [
            if (isGrid || videoRenderer != null)
              SizedBox.expand(
                child: videoRenderer == null
                    ? ProfilePhoto(
                        profilePhoto: user.photo,
                        name: user.username,
                        isFill: true,
                        isCircular: false,
                      )
                    : RTCVideoView(
                        videoRenderer!,
                        mirror: watcher.id == myId,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  ProfilePhoto(
                    profilePhoto: user.photo,
                    name: user.username,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: context.bodyMedium?.copyWith(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          watcher.action?.capitalize ?? "",
                          style:
                              context.bodySmall?.copyWith(color: primaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Opacity(
                  //   opacity: watcher.audioLevel ?? 0,
                  //   child: const CircleAvatar(
                  //     radius: 10,
                  //     backgroundColor: primaryColor,
                  //     child: Icon(EvaIcons.speaker, size: 10),
                  //   ),
                  // ),
                  PopupMenuButton<String>(
                    itemBuilder: (context) {
                      return getOptions().map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(
                            option,
                            style: context.bodySmall,
                          ),
                        );
                      }).toList();
                    },
                    onSelected: onPressed,
                    child: const Icon(EvaIcons.more_vertical, size: 16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

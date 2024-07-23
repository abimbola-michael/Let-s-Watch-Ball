import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../user/models/user.dart';
import '../models/watcher.dart';
import '../../user/mocks/users.dart';
import '../../../utils/utils.dart';

class VideoWatcherItem extends StatelessWidget {
  final RTCVideoRenderer? videoRenderer;
  final bool mirror;
  final Watcher watcher;
  final String type;
  final VoidCallback onPressed;
  final VoidCallback? onRightPressed;

  final bool isCreator;
  const VideoWatcherItem(
      {super.key,
      required this.watcher,
      required this.type,
      required this.onPressed,
      this.videoRenderer,
      this.mirror = false,
      required this.isCreator,
      this.onRightPressed});

  @override
  Widget build(BuildContext context) {
    if (watcher.user == null) {
      return Container();
    }
    final user = watcher.user!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: videoRenderer == null
                ? Container()
                : RTCVideoView(
                    videoRenderer!,
                    mirror: mirror,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(user.photo.toJpg),
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
                      user.name,
                      style: context.bodyMedium?.copyWith(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   "${user.watchersCount} watchers",
                    //   style: context.bodySmall?.copyWith(color: primaryColor),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),
              if (isCreator && watcher.id != myId)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        title: type == "current"
                            ? "Kickout"
                            : type == "invite"
                                ? "Cancel"
                                : "Reject",
                        bgColor: lightestTint,
                        onPressed: onPressed,
                      ),
                      if (type == "request")
                        AppButton(
                          margin: const EdgeInsets.only(left: 4),
                          title: "Accept",
                          bgColor: primaryColor,
                          onPressed: onRightPressed,
                        )
                    ],
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

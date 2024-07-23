import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:watchball/shared/components/custom_gridview.dart';
import 'package:watchball/features/watch/components/video_watcher_item.dart';
import 'package:watchball/features/watch/components/watcher_item.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../components/grid_watcher_item.dart';
import '../../user/models/user.dart';
import '../models/watcher.dart';

class WatchersListScreen extends StatelessWidget {
  final List<Watcher> watchers;
  final Map<String, RTCVideoRenderer>? remoteRenderers;
  final String view;
  final String type;
  final void Function(String userId) onPressed;
  final void Function(String userId) onRightPressed;

  final bool isCreator;
  const WatchersListScreen(
      {super.key,
      required this.watchers,
      required this.view,
      required this.type,
      required this.onPressed,
      required this.onRightPressed,
      this.remoteRenderers,
      required this.isCreator});

  @override
  Widget build(BuildContext context) {
    if (watchers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            "No Watchers found",
            style: context.bodySmall,
          ),
        ),
      );
    }
    if (view == "grid") {
      return CustomGridview(
        gridCount:
            remoteRenderers != null && remoteRenderers!.isNotEmpty ? 2 : 3,
        padding: const EdgeInsets.symmetric(vertical: 10),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount:
        //         remoteRenderers != null && remoteRenderers!.isNotEmpty
        //             ? 2
        //             : 3,
        //     childAspectRatio: 1 / 1.2),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: watchers.length,
        itemBuilder: (context, index) {
          final watcher = watchers[index];
          if (remoteRenderers != null && remoteRenderers!.isNotEmpty) {
            return VideoWatcherItem(
              isCreator: isCreator,
              mirror: watcher.id == myId,
              videoRenderer: remoteRenderers![watcher.id],
              watcher: watcher,
              type: type,
              onPressed: () => onPressed(watcher.id),
              onRightPressed: () => onRightPressed(watcher.id),
            );
          }
          return GridWatcherItem(
            isCreator: isCreator,
            watcher: watcher,
            type: type,
            onPressed: () => onPressed(watcher.id),
            onRightPressed: () => onRightPressed(watcher.id),
          );
        },
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: watchers.length,
      itemBuilder: (context, index) {
        final watcher = watchers[index];
        if (remoteRenderers != null) {
          return VideoWatcherItem(
            isCreator: isCreator,
            mirror: watcher.id == myId,
            videoRenderer: remoteRenderers![watcher.id],
            watcher: watcher,
            type: type,
            onPressed: () => onPressed(watcher.id),
            onRightPressed: () => onRightPressed(watcher.id),
          );
        }
        return WatcherItem(
          isCreator: isCreator,
          watcher: watcher,
          type: type,
          onPressed: () => onPressed(watcher.id),
          onRightPressed: () => onRightPressed(watcher.id),
        );
      },
    );
  }
}

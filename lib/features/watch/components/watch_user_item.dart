import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/profile_photo.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../user/models/user.dart';
import '../models/watch.dart';
import '../models/watcher.dart';

class WatcherUserItem extends StatelessWidget {
  final Watch watch;
  final int index;
  final VoidCallback? onPressed;

  const WatcherUserItem(
      {super.key, this.onPressed, required this.index, required this.watch});

  @override
  Widget build(BuildContext context) {
    final user = watch.users[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  "${watch.joinedWatchersIds.contains(user.id) ? "Joined" : "Missed"}${watch.creatorId == user.id ? " - Invited you" : ""}",
                  style: context.bodySmall?.copyWith(color: primaryColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

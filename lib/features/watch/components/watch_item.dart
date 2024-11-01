import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/match/utils/match_utils.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../shared/components/watchers_profile_photo.dart';
import '../../../utils/utils.dart';
import '../models/watch.dart';
import 'watch_arrow_notifcation.dart';

class WatchItem extends StatelessWidget {
  final Watch watch;
  final VoidCallback? onPressed;
  final bool? selected;
  final bool isHistory;
  const WatchItem(
      {super.key,
      required this.watch,
      this.onPressed,
      this.selected,
      this.isHistory = false});

  @override
  Widget build(BuildContext context) {
    // final watchers =
    //     watch.watchers.where((element) => element.id != myId).toList();
    final match = getMatchInfo(watch.match);
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Stack(
              children: [
                WatchersProfilePhoto(
                  users: watch.users,
                  withoutMyId: true,
                ),
                if (selected != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: AppContainer(
                      isCircular: true,
                      height: 24,
                      width: 24,
                      color: selected! ? primaryColor : transparent,
                      borderColor: selected! ? primaryColor : lighterTint,
                      child: selected!
                          ? const Icon(
                              EvaIcons.checkmark,
                              size: 16,
                            )
                          : null,
                    ),
                  )
              ],
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${watch.users.join(", ")}${watch.records.length > 1 ? "(${watch.records.length})" : ""}",
                        style: context.bodyMedium?.copyWith(
                          color: watch.status == "missed" ? Colors.red : tint,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      watch.createdAt.datetime.timeRange(),
                      style: context.bodyMedium?.copyWith(color: lightTint),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (isHistory) ...[
                            WatchArrowNotification(watch: watch),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            flex: 1,
                            child: Text(
                              match.homeName,
                              style: context.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          CachedNetworkImage(
                            imageUrl: match.homeLogo,
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "-",
                            style: context.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          CachedNetworkImage(
                            imageUrl: match.awayLogo,
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              match.awayName,
                              style: context.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (watch.records.length > 1) ...[
                    //   const SizedBox(
                    //     width: 4,
                    //   ),
                    //   Text(
                    //     "(${watch.records.length})",
                    //     style: context.bodySmall?.copyWith(color: primaryColor),
                    //   ),
                    // ]
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

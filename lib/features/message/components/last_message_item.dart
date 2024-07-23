import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchball/features/message/models/message.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';
import '../../../shared/components/app_container.dart';
import '../../match/utils/match_utils.dart';
import 'photoorflag_widget.dart';

class LastMessageItem extends StatelessWidget {
  final Message message;
  final bool isMatch;
  final VoidCallback onPressed;
  const LastMessageItem(
      {super.key,
      required this.message,
      required this.isMatch,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final user = message.user;
    final thumb = user?.photo ?? "";
    final name = user?.name ?? "";
    final matchInfo = getMatchInfo(message.match);
    final title = isMatch ? getMatchTitle(matchInfo) : user?.name ?? "";
    final subtitle = !isMatch ? getMatchTitle(matchInfo) : user?.name ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // CircleAvatar(
          //   radius: 20,
          //   backgroundImage:
          //       thumb.isNotEmpty ? CachedNetworkImageProvider(thumb) : null,
          // ),
          PhotoOrFlagWidget(
              size: 50, isMatch: isMatch, info: matchInfo, photo: user?.photo),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: context.bodyMedium?.copyWith(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      getFullTime(message.createdAt.toDateTime),
                      style: context.bodySmall?.copyWith(color: lighterTint),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Expanded(
                  child: Text(
                    "$subtitle: ${message.message}",
                    style: context.bodyMedium?.copyWith(color: lightTint),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if ((message.unread ?? 0) > 0) ...[
                  const SizedBox(
                    width: 10,
                  ),
                  AppContainer(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      "${message.unread}",
                      style: context.bodySmall,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

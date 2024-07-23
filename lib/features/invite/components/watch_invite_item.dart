import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/watch/models/watch_invite.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class WatchInviteItem extends StatelessWidget {
  final WatchInvite invite;
  final VoidCallback? onViewInvite;
  const WatchInviteItem(
      {super.key, required this.invite, required this.onViewInvite});

  @override
  Widget build(BuildContext context) {
    final watchers = invite.invitedUserIds.contains(",")
        ? invite.invitedUserIds.split(",")
        : [invite.invitedUserIds];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: invite.user != null
                ? CachedNetworkImageProvider(invite.user!.photo)
                : null,
          ),
          const SizedBox(
            width: 6,
          ),
          RichText(
            text: TextSpan(
                text: invite.user?.name ?? "",
                style: context.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text:
                        " invited you${watchers.length == 1 ? "" : " and ${watchers.length - 1} others"} to watch ${invite.match}",
                    style: context.bodyMedium,
                  ),
                  TextSpan(
                    text: " ${timeago.format(invite.createdAt.toDateTime)}",
                    style: context.bodyMedium?.copyWith(color: lightTint),
                  ),
                ]),
          ),
          if (onViewInvite != null) ...[
            const SizedBox(
              width: 6,
            ),
            AppButton(
              title: "View",
              onPressed: onViewInvite,
              wrapped: true,
              outlined: true,
            )
          ]
        ],
      ),
    );
  }
}

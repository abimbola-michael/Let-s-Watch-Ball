import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../models/message.dart';
import '../../../theme/colors.dart';
import '../../../shared/components/app_container.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  const MessageItem({super.key, required this.message});

  Widget profilePhoto(bool isMe) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: message.user != null
          ? CachedNetworkImageProvider(message.user!.photo)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.userId == myId;
    return Container(
      margin: EdgeInsets.only(
          left: isMe ? 50 : 0, right: isMe ? 0 : 50, top: 10, bottom: 10),
      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            profilePhoto(isMe),
            const SizedBox(
              width: 4,
            )
          ],
          Flexible(
            child: AppContainer(
              wrapped: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20),
              ),
              color: isMe ? primaryColor : lightestTint,
              child: Text(
                message.message,
                style: context.bodySmall?.copyWith(color: isMe ? white : tint),
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(
              width: 4,
            ),
            profilePhoto(isMe),
          ]
        ],
      ),
    );
  }
}

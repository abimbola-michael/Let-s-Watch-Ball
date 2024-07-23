import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/comment/models/comment.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatefulWidget {
  final Comment comment;
  final VoidCallback? onReply;
  final VoidCallback? onLike;
  final VoidCallback? onReact;
  final void Function(String type) onViewStats;

  const CommentItem(
      {super.key,
      required this.comment,
      this.onReply,
      this.onLike,
      this.onReact,
      required this.onViewStats});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: widget.comment.user != null
                ? CachedNetworkImageProvider(widget.comment.user!.photo)
                : null,
          ),
          const SizedBox(
            width: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                    text: widget.comment.user?.name ?? "",
                    style: context.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                    children: [
                      TextSpan(
                        text: " ${widget.comment.comment}",
                        style: context.bodyMedium,
                      ),
                      TextSpan(
                        text:
                            " ${timeago.format(widget.comment.time.toDateTime)}",
                        style: context.bodyMedium?.copyWith(color: lightTint),
                      ),
                    ]),
              ),
              // const SizedBox(
              //   height: 4,
              // ),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "",
                          style: context.bodySmall?.copyWith(color: lightTint),
                          children: [
                            if (widget.comment.replies != null &&
                                widget.comment.replies!.isNotEmpty)
                              TextSpan(
                                text:
                                    "${widget.comment.replies!.length} replies",
                                style: context.bodyMedium,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => widget.onViewStats("replies"),
                              ),
                            if (widget.comment.likes != null &&
                                widget.comment.likes!.isNotEmpty)
                              TextSpan(
                                text: "${widget.comment.likes!.length} likes",
                                style: context.bodyMedium,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => widget.onViewStats("likes"),
                              ),
                            if (widget.comment.reactions != null &&
                                widget.comment.reactions!.isNotEmpty)
                              TextSpan(
                                text:
                                    "${widget.comment.reactions!.length} reactions",
                                style: context.bodyMedium,
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => widget.onViewStats("reactions"),
                              ),
                          ]),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onReply,
                        icon: const Icon(OctIcons.reply),
                      ),
                      IconButton(
                        onPressed: widget.onLike,
                        icon: const Icon(OctIcons.heart),
                      ),
                      IconButton(
                        onPressed: widget.onReact,
                        icon: const Icon(OctIcons.smiley),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

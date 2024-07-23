import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/user/models/user.dart';
import 'package:watchball/features/comment/providers/comments_provider.dart';
import 'package:watchball/features/comment/services/comment_service.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/utils/extensions.dart';

import '../components/comment_item.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_container.dart';
import '../../../shared/components/button.dart';
import '../models/comment.dart';
import '../../../theme/colors.dart';

class CommentScreen extends ConsumerStatefulWidget {
  static const route = "/comment";
  final LiveMatch? match;
  const CommentScreen({
    super.key,
    this.match,
  });

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  List<Comment> comments = [];
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  //String matchId = "";
  String receiverId = "";
  Comment? replyComment;
  late LiveMatch match;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // comments.addAll(allComments);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // });
    scrollToBottom();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // matchId = context.args["matchId"] ?? "";
    if (widget.match != null) {
      match = widget.match!;
    } else {
      match = context.args["match"];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void readComments() {}

  void sendComment() async {
    String text = _commentController.text;
    int index = comments.length;
    final sentComment =
        await createComment(match.id, text, replyComment, (comment) {
      final sendingComment = comment.copyWith();
      sendingComment.status = "sending";
      comments.add(sendingComment);
      setState(() {});
    });

    comments[index] = sentComment;
    _commentController.clear();

    scrollToBottom();
    setState(() {});
  }

  void scrollToBottom() async {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.ease);
  }

  void toggleEmojiKeyboard() {}
  void viewStats(String type, Comment comment) {}
  void like(Comment comment) {}
  void reply(Comment comment) {}
  void react(Comment comment) {}

  @override
  Widget build(BuildContext context) {
    final allComments = ref.watch(commentsProvider);
    comments = allComments;

    return Scaffold(
      appBar: widget.match != null
          ? null
          : const AppAppBar(
              title: "Comment",
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                // reverse: true,
                padding: EdgeInsets.zero,
                controller: _scrollController,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return CommentItem(
                    comment: comment,
                    onViewStats: (type) => viewStats(type, comment),
                    onLike: () => like(comment),
                    onReply: () => reply(comment),
                    onReact: () => react(comment),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppContainer(
              color: lightestTint,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: toggleEmojiKeyboard,
                    icon: const Icon(OctIcons.smiley),
                    iconSize: 14,
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: 4,
                      minLines: 1,
                      controller: _commentController,
                      style: context.bodySmall,
                      decoration: InputDecoration(
                        hintText: "Write your comment...",
                        hintStyle:
                            context.bodySmall?.copyWith(color: lighterTint),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  if (_commentController.text.isNotEmpty) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    Button(
                      width: 38,
                      height: 38,
                      isCircular: true,
                      color: primaryColor,
                      onPressed: sendComment,
                      child: const Icon(
                        EvaIcons.paper_plane_outline,
                        color: white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

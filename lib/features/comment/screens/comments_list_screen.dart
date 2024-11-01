import 'package:flutter/material.dart';
import 'package:watchball/features/comment/components/comment_item.dart';
import 'package:watchball/features/comment/models/comment.dart';
import '../../watch/components/watch_item.dart';

class CommentsListScreen extends StatelessWidget {
  final List<Comment> comments;
  const CommentsListScreen({super.key, required this.comments});

  void viewStats(String type, Comment comment) {}
  void like(Comment comment) {}
  void reply(Comment comment) {}
  void react(Comment comment) {}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/comment/models/comment.dart';

import '../../user/models/user.dart';

class CommentsNotifier extends StateNotifier<List<Comment>> {
  CommentsNotifier(super.state);

  void clearComments(List<Comment> comments) {
    state = [];
  }

  void setComments(List<Comment> comments) {
    state = comments;
  }

  void addComment(Comment comment) {
    state = [...state, comment];
  }

  void removeComment(Comment comment) {
    state = state.where((prevComment) => prevComment.id != comment.id).toList();
  }
}

final commentsProvider = StateNotifierProvider<CommentsNotifier, List<Comment>>(
  (ref) {
    return CommentsNotifier([]);
  },
);

import 'package:watchball/features/comment/models/comment.dart';
import 'package:watchball/shared/models/list_change.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/utils/utils.dart';

import '../models/comment.dart';

final FirestoreMethods firestoreMethods = FirestoreMethods();

Future<Comment> createComment(String matchId, String text,
    Comment? replyComment, void Function(Comment comment) onGetComment) async {
  final time = DateTime.now().millisecondsSinceEpoch.toString();
  final id = firestoreMethods.getId(["matches", matchId, "comments"]);

  final comment = Comment(
    id: id,
    matchId: matchId,
    userId: myId,
    comment: text,
    time: time,
    replyId: replyComment?.id,
    replyUserId: replyComment?.userId,
    replyComment: replyComment?.comment,
  );
  onGetComment(comment);

  await firestoreMethods
      .setValue(["matches", matchId, "comments", id], value: comment.toMap());
  return comment;
}

Future clearComments(String matchId) {
  return firestoreMethods.removeValue(["matches", matchId, "comments"]);
}

Future<List<Comment>> readAllComments(String matchId) {
  return firestoreMethods.getValues(
      (map) => Comment.fromMap(map), ["matches", matchId, "comments"]);
}

Stream<List<Comment>> streamComments(String matchId) async* {
  yield* firestoreMethods.getValuesStream(
      (map) => Comment.fromMap(map), ["matches", matchId, "comments"]);
}

Stream<List<ValueChange<Comment>>> streamChangeComments(String matchId) async* {
  yield* firestoreMethods.getValuesChangeStream(
      (map) => Comment.fromMap(map), ["matches", matchId, "comments"]);
}

Stream<Comment?> streamComment(String matchId, String commentId) async* {
  yield* firestoreMethods.getValueStream((map) => Comment.fromMap(map),
      ["matches", matchId, "comments", commentId]);
}

Future<Comment?> getComment(String matchId, String commentId) {
  return firestoreMethods.getValue((map) => Comment.fromMap(map),
      ["matches", matchId, "comments", commentId]);
}

Future updateComment(
    String matchId, String commentId, Map<String, dynamic> value) {
  return firestoreMethods
      .updateValue(["matches", matchId, "comments", commentId], value: value);
}

Future removeComment(String matchId, String commentId) {
  return firestoreMethods
      .removeValue(["matches", matchId, "comments", commentId]);
}

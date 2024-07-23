// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../user/models/user.dart';

class Comment {
  String id;
  String userId;
  String matchId;
  String comment;
  String time;
  String? replyId;
  String? replyUserId;
  String? replyComment;
  List<String>? likes;
  List<String>? reactions;
  List<String>? replies;
  String? status;
  User? user;

  Comment({
    required this.id,
    required this.userId,
    required this.matchId,
    required this.comment,
    required this.time,
    this.replyId,
    this.replyUserId,
    this.replyComment,
    this.likes,
    this.reactions,
    this.replies,
  });

  Comment copyWith({
    String? id,
    String? userId,
    String? matchId,
    String? comment,
    String? time,
    String? replyId,
    String? replyUserId,
    String? replyComment,
    List<String>? likes,
    List<String>? reactions,
    List<String>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      matchId: matchId ?? this.matchId,
      comment: comment ?? this.comment,
      time: time ?? this.time,
      replyId: replyId ?? this.replyId,
      replyUserId: replyUserId ?? this.replyUserId,
      replyComment: replyComment ?? this.replyComment,
      likes: likes ?? this.likes,
      reactions: reactions ?? this.reactions,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'matchId': matchId,
      'comment': comment,
      'time': time,
      'replyId': replyId,
      'replyUserId': replyUserId,
      'replyComment': replyComment,
      'likes': likes,
      'reactions': reactions,
      'replies': replies,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      userId: map['userId'] as String,
      matchId: map['matchId'] as String,
      comment: map['comment'] as String,
      time: map['time'] as String,
      replyId: map['replyId'] != null ? map['replyId'] as String : null,
      replyUserId:
          map['replyUserId'] != null ? map['replyUserId'] as String : null,
      replyComment:
          map['replyComment'] != null ? map['replyComment'] as String : null,
      likes: map['likes'] != null
          ? List<String>.from((map['likes'] as List<String>))
          : null,
      reactions: map['reactions'] != null
          ? List<String>.from((map['reactions'] as List<String>))
          : null,
      replies: map['replies'] != null
          ? List<String>.from((map['replies'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, userId: $userId, matchId: $matchId, comment: $comment, time: $time, replyId: $replyId, replyUserId: $replyUserId, replyComment: $replyComment, likes: $likes, reactions: $reactions, replies: $replies)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.matchId == matchId &&
        other.comment == comment &&
        other.time == time &&
        other.replyId == replyId &&
        other.replyUserId == replyUserId &&
        other.replyComment == replyComment &&
        listEquals(other.likes, likes) &&
        listEquals(other.reactions, reactions) &&
        listEquals(other.replies, replies);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        matchId.hashCode ^
        comment.hashCode ^
        time.hashCode ^
        replyId.hashCode ^
        replyUserId.hashCode ^
        replyComment.hashCode ^
        likes.hashCode ^
        reactions.hashCode ^
        replies.hashCode;
  }
}

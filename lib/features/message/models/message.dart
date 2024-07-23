// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../../user/models/user.dart';

class Message {
  String id;
  String receiverId;
  String matchId;
  String match;
  String userId;
  String message;
  String status;
  String createdAt;
  String modifiedAt;
  String? deletedAt;
  String? replyId;
  String? replyUserId;
  String? replyMessage;
  int? unread;
  //List<String>? reactions;
  User? user;
  List<Message> messages = [];

  Message({
    required this.id,
    required this.receiverId,
    required this.matchId,
    required this.match,
    required this.userId,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
    this.replyId,
    this.replyUserId,
    this.replyMessage,
    this.unread,
    this.user,
  });

  Message copyWith({
    String? id,
    String? receiverId,
    String? matchId,
    String? match,
    String? userId,
    String? message,
    String? status,
    String? createdAt,
    String? modifiedAt,
    String? deletedAt,
    String? replyId,
    String? replyUserId,
    String? replyMessage,
    int? unread,
    User? user,
  }) {
    return Message(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      matchId: matchId ?? this.matchId,
      match: match ?? this.match,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      replyId: replyId ?? this.replyId,
      replyUserId: replyUserId ?? this.replyUserId,
      replyMessage: replyMessage ?? this.replyMessage,
      unread: unread ?? this.unread,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'receiverId': receiverId,
      'matchId': matchId,
      'match': match,
      'userId': userId,
      'message': message,
      'status': status,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'deletedAt': deletedAt,
      'replyId': replyId,
      'replyUserId': replyUserId,
      'replyMessage': replyMessage,
      'unread': unread,
      'user': user?.toMap(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      receiverId: map['receiverId'] as String,
      matchId: map['matchId'] as String,
      match: map['match'] as String,
      userId: map['userId'] as String,
      message: map['message'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
      modifiedAt: map['modifiedAt'] as String,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      replyId: map['replyId'] != null ? map['replyId'] as String : null,
      replyUserId:
          map['replyUserId'] != null ? map['replyUserId'] as String : null,
      replyMessage:
          map['replyMessage'] != null ? map['replyMessage'] as String : null,
      unread: map['unread'] != null ? map['unread'] as int : null,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, receiverId: $receiverId, matchId: $matchId, match: $match, userId: $userId, message: $message, status: $status, createdAt: $createdAt, modifiedAt: $modifiedAt, deletedAt: $deletedAt, replyId: $replyId, replyUserId: $replyUserId, replyMessage: $replyMessage, unread: $unread, user: $user)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.receiverId == receiverId &&
        other.matchId == matchId &&
        other.match == match &&
        other.userId == userId &&
        other.message == message &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt &&
        other.deletedAt == deletedAt &&
        other.replyId == replyId &&
        other.replyUserId == replyUserId &&
        other.replyMessage == replyMessage &&
        other.unread == unread &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        receiverId.hashCode ^
        matchId.hashCode ^
        match.hashCode ^
        userId.hashCode ^
        message.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode ^
        deletedAt.hashCode ^
        replyId.hashCode ^
        replyUserId.hashCode ^
        replyMessage.hashCode ^
        unread.hashCode ^
        user.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:watchball/features/watch/models/watch.dart';

import '../../user/models/user.dart';

class WatchInvite {
  String watchId;
  String userId;
  String invitedUserIds;
  String matchId;
  String match;
  String status;
  String createdAt;
  User? user;
  Watch? watch;
  WatchInvite({
    required this.watchId,
    required this.userId,
    required this.invitedUserIds,
    required this.matchId,
    required this.match,
    required this.status,
    required this.createdAt,
    this.user,
    this.watch,
  });

  WatchInvite copyWith({
    String? watchId,
    String? userId,
    String? invitedUserIds,
    String? matchId,
    String? match,
    String? status,
    String? createdAt,
    User? user,
    Watch? watch,
  }) {
    return WatchInvite(
      watchId: watchId ?? this.watchId,
      userId: userId ?? this.userId,
      invitedUserIds: invitedUserIds ?? this.invitedUserIds,
      matchId: matchId ?? this.matchId,
      match: match ?? this.match,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      watch: watch ?? this.watch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'watchId': watchId,
      'userId': userId,
      'invitedUserIds': invitedUserIds,
      'matchId': matchId,
      'match': match,
      'status': status,
      'createdAt': createdAt,
      'user': user?.toMap(),
      'watch': watch?.toMap(),
    };
  }

  factory WatchInvite.fromMap(Map<String, dynamic> map) {
    return WatchInvite(
      watchId: map['watchId'] as String,
      userId: map['userId'] as String,
      invitedUserIds: map['invitedUserIds'] as String,
      matchId: map['matchId'] as String,
      match: map['match'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      watch: map['watch'] != null
          ? Watch.fromMap(map['watch'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchInvite.fromJson(String source) =>
      WatchInvite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WatchInvite(watchId: $watchId, userId: $userId, invitedUserIds: $invitedUserIds, matchId: $matchId, match: $match, status: $status, createdAt: $createdAt, user: $user, watch: $watch)';
  }

  @override
  bool operator ==(covariant WatchInvite other) {
    if (identical(this, other)) return true;

    return other.watchId == watchId &&
        other.userId == userId &&
        other.invitedUserIds == invitedUserIds &&
        other.matchId == matchId &&
        other.match == match &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.user == user &&
        other.watch == watch;
  }

  @override
  int get hashCode {
    return watchId.hashCode ^
        userId.hashCode ^
        invitedUserIds.hashCode ^
        matchId.hashCode ^
        match.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        user.hashCode ^
        watch.hashCode;
  }
}

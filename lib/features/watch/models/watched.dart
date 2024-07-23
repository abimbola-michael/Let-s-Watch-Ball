// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../user/models/user.dart';

// class Watched {
//   String id;
//   String startTime;
//   String endTime;
class Watched {
  String watchId;
  String userId;
  String watchedUserIds;
  String matchId;
  String match;
  String createdAt;
  String endedAt;
  User? user;

  Watched({
    required this.watchId,
    required this.userId,
    required this.watchedUserIds,
    required this.matchId,
    required this.match,
    required this.createdAt,
    required this.endedAt,
    this.user,
  });

  Watched copyWith({
    String? watchId,
    String? userId,
    String? watchedUserIds,
    String? matchId,
    String? match,
    String? createdAt,
    String? endedAt,
    User? user,
  }) {
    return Watched(
      watchId: watchId ?? this.watchId,
      userId: userId ?? this.userId,
      watchedUserIds: watchedUserIds ?? this.watchedUserIds,
      matchId: matchId ?? this.matchId,
      match: match ?? this.match,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'watchId': watchId,
      'userId': userId,
      'watchedUserIds': watchedUserIds,
      'matchId': matchId,
      'match': match,
      'createdAt': createdAt,
      'endedAt': endedAt,
      'user': user?.toMap(),
    };
  }

  factory Watched.fromMap(Map<String, dynamic> map) {
    return Watched(
      watchId: map['watchId'] as String,
      userId: map['userId'] as String,
      watchedUserIds: map['watchedUserIds'] as String,
      matchId: map['matchId'] as String,
      match: map['match'] as String,
      createdAt: map['createdAt'] as String,
      endedAt: map['endedAt'] as String,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Watched.fromJson(String source) =>
      Watched.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Watched(watchId: $watchId, userId: $userId, watchedUserIds: $watchedUserIds, matchId: $matchId, match: $match, createdAt: $createdAt, endedAt: $endedAt, user: $user)';
  }

  @override
  bool operator ==(covariant Watched other) {
    if (identical(this, other)) return true;

    return other.watchId == watchId &&
        other.userId == userId &&
        other.watchedUserIds == watchedUserIds &&
        other.matchId == matchId &&
        other.match == match &&
        other.createdAt == createdAt &&
        other.endedAt == endedAt &&
        other.user == user;
  }

  @override
  int get hashCode {
    return watchId.hashCode ^
        userId.hashCode ^
        watchedUserIds.hashCode ^
        matchId.hashCode ^
        match.hashCode ^
        createdAt.hashCode ^
        endedAt.hashCode ^
        user.hashCode;
  }
}

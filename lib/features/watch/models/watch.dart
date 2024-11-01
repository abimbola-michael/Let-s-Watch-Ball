// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/watch/models/watcher.dart';

import '../../user/models/user.dart';
import 'watch_record.dart';

// String joinPrivacy;
// String invitePrivacy;

class Watch {
  String id;
  String matchId;
  String match;
  String callMode;
  String creatorId;
  String createdAt;
  String modifiedAt;
  String? deletedAt;
  List<String> watchersIds;
  List<String> joinedWatchersIds;
  List<WatchRecord> records;
  String? status;
  List<Watcher> watchers = [];
  List<User> users = [];
  User? creatorUser;

  Watch({
    required this.id,
    required this.matchId,
    required this.match,
    required this.callMode,
    required this.creatorId,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
    required this.watchersIds,
    required this.joinedWatchersIds,
    required this.records,
  });

  Watch copyWith({
    String? id,
    String? matchId,
    String? match,
    String? callMode,
    String? creatorId,
    String? createdAt,
    String? modifiedAt,
    String? deletedAt,
    List<String>? watchersIds,
    List<String>? joinedWatchersIds,
    List<WatchRecord>? records,
  }) {
    return Watch(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      match: match ?? this.match,
      callMode: callMode ?? this.callMode,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      watchersIds: watchersIds ?? this.watchersIds,
      joinedWatchersIds: joinedWatchersIds ?? this.joinedWatchersIds,
      records: records ?? this.records,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'matchId': matchId,
      'match': match,
      'callMode': callMode,
      'creatorId': creatorId,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'deletedAt': deletedAt,
      'watchersIds': watchersIds,
      'joinedWatchersIds': joinedWatchersIds,
      'records': records.map((x) => x.toMap()).toList(),
    };
  }

  factory Watch.fromMap(Map<String, dynamic> map) {
    return Watch(
      id: map['id'] as String,
      matchId: map['matchId'] as String,
      match: map['match'] as String,
      callMode: map['callMode'] as String,
      creatorId: map['creatorId'] as String,
      createdAt: map['createdAt'] as String,
      modifiedAt: map['modifiedAt'] as String,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      watchersIds: List<String>.from((map['watchersIds'] as List<dynamic>)),
      joinedWatchersIds:
          List<String>.from((map['joinedWatchersIds'] as List<dynamic>)),
      records: List<WatchRecord>.from(
        (map['records'] as List<dynamic>).map<WatchRecord>(
          (x) => WatchRecord.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Watch.fromJson(String source) =>
      Watch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Watch(id: $id, matchId: $matchId, match: $match, callMode: $callMode, creatorId: $creatorId, createdAt: $createdAt, modifiedAt: $modifiedAt, deletedAt: $deletedAt, watchersIds: $watchersIds, joinedWatchersIds: $joinedWatchersIds, records: $records)';
  }

  @override
  bool operator ==(covariant Watch other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.matchId == matchId &&
        other.match == match &&
        other.callMode == callMode &&
        other.creatorId == creatorId &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt &&
        other.deletedAt == deletedAt &&
        listEquals(other.watchersIds, watchersIds) &&
        listEquals(other.joinedWatchersIds, joinedWatchersIds) &&
        listEquals(other.records, records);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        matchId.hashCode ^
        match.hashCode ^
        callMode.hashCode ^
        creatorId.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode ^
        deletedAt.hashCode ^
        watchersIds.hashCode ^
        joinedWatchersIds.hashCode ^
        records.hashCode;
  }
}

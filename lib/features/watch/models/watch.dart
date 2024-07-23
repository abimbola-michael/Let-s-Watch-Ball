// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/watch/models/watcher.dart';

import '../../user/models/user.dart';
import 'watched.dart';

class Watch {
  String id;
  LiveMatch match;
  String creatorId;
  String joinPrivacy;
  String invitePrivacy;
  // String startTime;
  // String endTime;
  //List<Watched> watcheds;
  List<Watcher> watchers = [];
  User? creatorUser;

  Watch({
    required this.id,
    required this.match,
    required this.creatorId,
    required this.joinPrivacy,
    required this.invitePrivacy,
    this.creatorUser,
  });

  Watch copyWith({
    String? id,
    LiveMatch? match,
    String? creatorId,
    String? joinPrivacy,
    String? invitePrivacy,
    User? creatorUser,
  }) {
    return Watch(
      id: id ?? this.id,
      match: match ?? this.match,
      creatorId: creatorId ?? this.creatorId,
      joinPrivacy: joinPrivacy ?? this.joinPrivacy,
      invitePrivacy: invitePrivacy ?? this.invitePrivacy,
      creatorUser: creatorUser ?? this.creatorUser,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'match': match.toMap(),
      'creatorId': creatorId,
      'joinPrivacy': joinPrivacy,
      'invitePrivacy': invitePrivacy,
      'creatorUser': creatorUser?.toMap(),
    };
  }

  factory Watch.fromMap(Map<String, dynamic> map) {
    return Watch(
      id: map['id'] as String,
      match: LiveMatch.fromMap(map['match'] as Map<String, dynamic>),
      creatorId: map['creatorId'] as String,
      joinPrivacy: map['joinPrivacy'] as String,
      invitePrivacy: map['invitePrivacy'] as String,
      creatorUser: map['creatorUser'] != null
          ? User.fromMap(map['creatorUser'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Watch.fromJson(String source) =>
      Watch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Watch(id: $id, match: $match, creatorId: $creatorId, joinPrivacy: $joinPrivacy, invitePrivacy: $invitePrivacy, creatorUser: $creatorUser)';
  }

  @override
  bool operator ==(covariant Watch other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.match == match &&
        other.creatorId == creatorId &&
        other.joinPrivacy == joinPrivacy &&
        other.invitePrivacy == invitePrivacy &&
        other.creatorUser == creatorUser;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        match.hashCode ^
        creatorId.hashCode ^
        joinPrivacy.hashCode ^
        invitePrivacy.hashCode ^
        creatorUser.hashCode;
  }
}

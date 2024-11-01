// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:watchball/features/user/models/user.dart';

class Watcher {
  String id;
  String time;
  //for watchs
  String? status;
  String? action;
  String? match;
  String? syncUserId;
  int? watchPosition;
  String? callMode;
  bool? isAudioOn;
  bool? isFrontCamera;
  bool? isOnHold;
  double? audioLevel;

  //for user watchers
  // bool? canSeeStories;
  // bool? canMessage;
  // bool? canInviteToWatch;
  // bool? canJoinWatch;
  User? user;
  Watcher({
    required this.id,
    required this.time,
    this.status,
    this.action,
    this.match,
    this.syncUserId,
    this.watchPosition,
    this.callMode,
    this.isAudioOn,
    this.isFrontCamera,
    this.isOnHold,
    this.audioLevel,
  });

  Watcher copyWith({
    String? id,
    String? time,
    String? status,
    String? action,
    String? match,
    String? syncUserId,
    int? watchPosition,
    String? callMode,
    bool? isAudioOn,
    bool? isFrontCamera,
    bool? isOnHold,
    double? audioLevel,
  }) {
    return Watcher(
      id: id ?? this.id,
      time: time ?? this.time,
      status: status ?? this.status,
      action: action ?? this.action,
      match: match ?? this.match,
      syncUserId: syncUserId ?? this.syncUserId,
      watchPosition: watchPosition ?? this.watchPosition,
      callMode: callMode ?? this.callMode,
      isAudioOn: isAudioOn ?? this.isAudioOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isOnHold: isOnHold ?? this.isOnHold,
      audioLevel: audioLevel ?? this.audioLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'time': time,
      'status': status,
      'action': action,
      'match': match,
      'syncUserId': syncUserId,
      'watchPosition': watchPosition,
      'callMode': callMode,
      'isAudioOn': isAudioOn,
      'isFrontCamera': isFrontCamera,
      'isOnHold': isOnHold,
      'audioLevel': audioLevel,
    };
  }

  factory Watcher.fromMap(Map<String, dynamic> map) {
    return Watcher(
      id: map['id'] as String,
      time: map['time'] as String,
      status: map['status'] != null ? map['status'] as String : null,
      action: map['action'] != null ? map['action'] as String : null,
      match: map['match'] != null ? map['match'] as String : null,
      syncUserId:
          map['syncUserId'] != null ? map['syncUserId'] as String : null,
      watchPosition:
          map['watchPosition'] != null ? map['watchPosition'] as int : null,
      callMode: map['callMode'] != null ? map['callMode'] as String : null,
      isAudioOn: map['isAudioOn'] != null ? map['isAudioOn'] as bool : null,
      isFrontCamera:
          map['isFrontCamera'] != null ? map['isFrontCamera'] as bool : null,
      isOnHold: map['isOnHold'] != null ? map['isOnHold'] as bool : null,
      audioLevel:
          map['audioLevel'] != null ? map['audioLevel'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Watcher.fromJson(String source) =>
      Watcher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Watcher(id: $id, time: $time, status: $status, action: $action, match: $match, syncUserId: $syncUserId, watchPosition: $watchPosition, callMode: $callMode, isAudioOn: $isAudioOn, isFrontCamera: $isFrontCamera, isOnHold: $isOnHold, audioLevel: $audioLevel)';
  }

  @override
  bool operator ==(covariant Watcher other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.time == time &&
        other.status == status &&
        other.action == action &&
        other.match == match &&
        other.syncUserId == syncUserId &&
        other.watchPosition == watchPosition &&
        other.callMode == callMode &&
        other.isAudioOn == isAudioOn &&
        other.isFrontCamera == isFrontCamera &&
        other.isOnHold == isOnHold &&
        other.audioLevel == audioLevel;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        time.hashCode ^
        status.hashCode ^
        action.hashCode ^
        match.hashCode ^
        syncUserId.hashCode ^
        watchPosition.hashCode ^
        callMode.hashCode ^
        isAudioOn.hashCode ^
        isFrontCamera.hashCode ^
        isOnHold.hashCode ^
        audioLevel.hashCode;
  }
}

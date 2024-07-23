// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../user/models/user.dart';

class Story {
  String id;
  String userId;
  String matchId;
  String match;
  String text;
  String url;
  String thumb;
  String type;
  String color;
  String createdAt;
  String endAt;
  String? deletedAt;
  String modifiedAt;
  int viewsCount;
  //List<String>? views;
  User? user;
  List<Story> stories = [];

  Story({
    required this.id,
    required this.userId,
    required this.matchId,
    required this.match,
    required this.text,
    required this.url,
    required this.thumb,
    required this.type,
    required this.color,
    required this.createdAt,
    required this.endAt,
    this.deletedAt,
    required this.modifiedAt,
    required this.viewsCount,
  });
  //User? user;

  Story copyWith({
    String? id,
    String? userId,
    String? matchId,
    String? match,
    String? text,
    String? url,
    String? thumb,
    String? type,
    String? color,
    String? createdAt,
    String? endAt,
    String? deletedAt,
    String? modifiedAt,
    int? viewsCount,
  }) {
    return Story(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      matchId: matchId ?? this.matchId,
      match: match ?? this.match,
      text: text ?? this.text,
      url: url ?? this.url,
      thumb: thumb ?? this.thumb,
      type: type ?? this.type,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      endAt: endAt ?? this.endAt,
      deletedAt: deletedAt ?? this.deletedAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      viewsCount: viewsCount ?? this.viewsCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'matchId': matchId,
      'match': match,
      'text': text,
      'url': url,
      'thumb': thumb,
      'type': type,
      'color': color,
      'createdAt': createdAt,
      'endAt': endAt,
      'deletedAt': deletedAt,
      'modifiedAt': modifiedAt,
      'viewsCount': viewsCount,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] as String,
      userId: map['userId'] as String,
      matchId: map['matchId'] as String,
      match: map['match'] as String,
      text: map['text'] as String,
      url: map['url'] as String,
      thumb: map['thumb'] as String,
      type: map['type'] as String,
      color: map['color'] as String,
      createdAt: map['createdAt'] as String,
      endAt: map['endAt'] as String,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      modifiedAt: map['modifiedAt'] as String,
      viewsCount: map['viewsCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Story.fromJson(String source) =>
      Story.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Story(id: $id, userId: $userId, matchId: $matchId, match: $match, text: $text, url: $url, thumb: $thumb, type: $type, color: $color, createdAt: $createdAt, endAt: $endAt, deletedAt: $deletedAt, modifiedAt: $modifiedAt, viewsCount: $viewsCount)';
  }

  @override
  bool operator ==(covariant Story other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.matchId == matchId &&
        other.match == match &&
        other.text == text &&
        other.url == url &&
        other.thumb == thumb &&
        other.type == type &&
        other.color == color &&
        other.createdAt == createdAt &&
        other.endAt == endAt &&
        other.deletedAt == deletedAt &&
        other.modifiedAt == modifiedAt &&
        other.viewsCount == viewsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        matchId.hashCode ^
        match.hashCode ^
        text.hashCode ^
        url.hashCode ^
        thumb.hashCode ^
        type.hashCode ^
        color.hashCode ^
        createdAt.hashCode ^
        endAt.hashCode ^
        deletedAt.hashCode ^
        modifiedAt.hashCode ^
        viewsCount.hashCode;
  }
}

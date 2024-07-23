// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class WatchedMatch {
  final String matchId;
  final String league;
  final String date;
  final String time;
  final String homeName;
  final String homeLogo;
  final String awayName;
  final String awayLogo;
  final List<String> watchIds;
  WatchedMatch({
    required this.matchId,
    required this.league,
    required this.date,
    required this.time,
    required this.homeName,
    required this.homeLogo,
    required this.awayName,
    required this.awayLogo,
    required this.watchIds,
  });

  WatchedMatch copyWith({
    String? matchId,
    String? league,
    String? date,
    String? time,
    String? homeName,
    String? homeLogo,
    String? awayName,
    String? awayLogo,
    List<String>? watchIds,
  }) {
    return WatchedMatch(
      matchId: matchId ?? this.matchId,
      league: league ?? this.league,
      date: date ?? this.date,
      time: time ?? this.time,
      homeName: homeName ?? this.homeName,
      homeLogo: homeLogo ?? this.homeLogo,
      awayName: awayName ?? this.awayName,
      awayLogo: awayLogo ?? this.awayLogo,
      watchIds: watchIds ?? this.watchIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchId': matchId,
      'league': league,
      'date': date,
      'time': time,
      'homeName': homeName,
      'homeLogo': homeLogo,
      'awayName': awayName,
      'awayLogo': awayLogo,
      'watchIds': watchIds,
    };
  }

  factory WatchedMatch.fromMap(Map<String, dynamic> map) {
    return WatchedMatch(
      matchId: map['matchId'] as String,
      league: map['league'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      homeName: map['homeName'] as String,
      homeLogo: map['homeLogo'] as String,
      awayName: map['awayName'] as String,
      awayLogo: map['awayLogo'] as String,
      watchIds: List<String>.from((map['watchIds'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchedMatch.fromJson(String source) =>
      WatchedMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WatchedMatch(matchId: $matchId, league: $league, date: $date, time: $time, homeName: $homeName, homeLogo: $homeLogo, awayName: $awayName, awayLogo: $awayLogo, watchIds: $watchIds)';
  }

  @override
  bool operator ==(covariant WatchedMatch other) {
    if (identical(this, other)) return true;

    return other.matchId == matchId &&
        other.league == league &&
        other.date == date &&
        other.time == time &&
        other.homeName == homeName &&
        other.homeLogo == homeLogo &&
        other.awayName == awayName &&
        other.awayLogo == awayLogo &&
        listEquals(other.watchIds, watchIds);
  }

  @override
  int get hashCode {
    return matchId.hashCode ^
        league.hashCode ^
        date.hashCode ^
        time.hashCode ^
        homeName.hashCode ^
        homeLogo.hashCode ^
        awayName.hashCode ^
        awayLogo.hashCode ^
        watchIds.hashCode;
  }
}

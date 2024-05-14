// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class FootballMatch {
  String teamOneIcon;
  String teamOneName;
  int teamOneScore;
  double teamOneOdds;
  String teamTwoIcon;
  String teamTwoName;
  int teamTwoScore;
  double teamTwoOdds;
  double drawOdds;
  int gameTime;
  DateTime dateTime;
  String competition;
  String stage;
  String host;
  FootballMatch({
    required this.teamOneIcon,
    required this.teamOneName,
    required this.teamOneScore,
    required this.teamOneOdds,
    required this.teamTwoIcon,
    required this.teamTwoName,
    required this.teamTwoScore,
    required this.teamTwoOdds,
    required this.drawOdds,
    required this.gameTime,
    required this.dateTime,
    required this.competition,
    required this.stage,
    required this.host,
  });

  FootballMatch copyWith({
    String? teamOneIcon,
    String? teamOneName,
    int? teamOneScore,
    double? teamOneOdds,
    String? teamTwoIcon,
    String? teamTwoName,
    int? teamTwoScore,
    double? teamTwoOdds,
    double? drawOdds,
    int? gameTime,
    DateTime? dateTime,
    String? competition,
    String? stage,
    String? host,
  }) {
    return FootballMatch(
      teamOneIcon: teamOneIcon ?? this.teamOneIcon,
      teamOneName: teamOneName ?? this.teamOneName,
      teamOneScore: teamOneScore ?? this.teamOneScore,
      teamOneOdds: teamOneOdds ?? this.teamOneOdds,
      teamTwoIcon: teamTwoIcon ?? this.teamTwoIcon,
      teamTwoName: teamTwoName ?? this.teamTwoName,
      teamTwoScore: teamTwoScore ?? this.teamTwoScore,
      teamTwoOdds: teamTwoOdds ?? this.teamTwoOdds,
      drawOdds: drawOdds ?? this.drawOdds,
      gameTime: gameTime ?? this.gameTime,
      dateTime: dateTime ?? this.dateTime,
      competition: competition ?? this.competition,
      stage: stage ?? this.stage,
      host: host ?? this.host,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'teamOneIcon': teamOneIcon,
      'teamOneName': teamOneName,
      'teamOneScore': teamOneScore,
      'teamOneOdds': teamOneOdds,
      'teamTwoIcon': teamTwoIcon,
      'teamTwoName': teamTwoName,
      'teamTwoScore': teamTwoScore,
      'teamTwoOdds': teamTwoOdds,
      'drawOdds': drawOdds,
      'gameTime': gameTime,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'competition': competition,
      'stage': stage,
      'host': host,
    };
  }

  factory FootballMatch.fromMap(Map<String, dynamic> map) {
    return FootballMatch(
      teamOneIcon: map['teamOneIcon'] as String,
      teamOneName: map['teamOneName'] as String,
      teamOneScore: map['teamOneScore'] as int,
      teamOneOdds: map['teamOneOdds'] as double,
      teamTwoIcon: map['teamTwoIcon'] as String,
      teamTwoName: map['teamTwoName'] as String,
      teamTwoScore: map['teamTwoScore'] as int,
      teamTwoOdds: map['teamTwoOdds'] as double,
      drawOdds: map['drawOdds'] as double,
      gameTime: map['gameTime'] as int,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      competition: map['competition'] as String,
      stage: map['stage'] as String,
      host: map['host'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FootballMatch.fromJson(String source) =>
      FootballMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FootballMatch(teamOneIcon: $teamOneIcon, teamOneName: $teamOneName, teamOneScore: $teamOneScore, teamOneOdds: $teamOneOdds, teamTwoIcon: $teamTwoIcon, teamTwoName: $teamTwoName, teamTwoScore: $teamTwoScore, teamTwoOdds: $teamTwoOdds, drawOdds: $drawOdds, gameTime: $gameTime, dateTime: $dateTime, competition: $competition, stage: $stage, host: $host)';
  }

  @override
  bool operator ==(covariant FootballMatch other) {
    if (identical(this, other)) return true;

    return other.teamOneIcon == teamOneIcon &&
        other.teamOneName == teamOneName &&
        other.teamOneScore == teamOneScore &&
        other.teamOneOdds == teamOneOdds &&
        other.teamTwoIcon == teamTwoIcon &&
        other.teamTwoName == teamTwoName &&
        other.teamTwoScore == teamTwoScore &&
        other.teamTwoOdds == teamTwoOdds &&
        other.drawOdds == drawOdds &&
        other.gameTime == gameTime &&
        other.dateTime == dateTime &&
        other.competition == competition &&
        other.stage == stage &&
        other.host == host;
  }

  @override
  int get hashCode {
    return teamOneIcon.hashCode ^
        teamOneName.hashCode ^
        teamOneScore.hashCode ^
        teamOneOdds.hashCode ^
        teamTwoIcon.hashCode ^
        teamTwoName.hashCode ^
        teamTwoScore.hashCode ^
        teamTwoOdds.hashCode ^
        drawOdds.hashCode ^
        gameTime.hashCode ^
        dateTime.hashCode ^
        competition.hashCode ^
        stage.hashCode ^
        host.hashCode;
  }
}

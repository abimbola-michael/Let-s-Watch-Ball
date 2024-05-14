// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WatchedMatch {
  String matchId;
  String usersIds;
  String teamOne;
  String teamTwo;
  String teamOneScore;
  String teamOneIcon;
  String teamTwoScore;
  String teamTwoIcon;
  String competition;
  String stage;
  String duration;
  String time;
  WatchedMatch({
    required this.matchId,
    required this.usersIds,
    required this.teamOne,
    required this.teamTwo,
    required this.teamOneScore,
    required this.teamOneIcon,
    required this.teamTwoScore,
    required this.teamTwoIcon,
    required this.competition,
    required this.stage,
    required this.duration,
    required this.time,
  });

  WatchedMatch copyWith({
    String? matchId,
    String? usersIds,
    String? teamOne,
    String? teamTwo,
    String? teamOneScore,
    String? teamOneIcon,
    String? teamTwoScore,
    String? teamTwoIcon,
    String? competition,
    String? stage,
    String? duration,
    String? time,
  }) {
    return WatchedMatch(
      matchId: matchId ?? this.matchId,
      usersIds: usersIds ?? this.usersIds,
      teamOne: teamOne ?? this.teamOne,
      teamTwo: teamTwo ?? this.teamTwo,
      teamOneScore: teamOneScore ?? this.teamOneScore,
      teamOneIcon: teamOneIcon ?? this.teamOneIcon,
      teamTwoScore: teamTwoScore ?? this.teamTwoScore,
      teamTwoIcon: teamTwoIcon ?? this.teamTwoIcon,
      competition: competition ?? this.competition,
      stage: stage ?? this.stage,
      duration: duration ?? this.duration,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchId': matchId,
      'usersIds': usersIds,
      'teamOne': teamOne,
      'teamTwo': teamTwo,
      'teamOneScore': teamOneScore,
      'teamOneIcon': teamOneIcon,
      'teamTwoScore': teamTwoScore,
      'teamTwoIcon': teamTwoIcon,
      'competition': competition,
      'stage': stage,
      'duration': duration,
      'time': time,
    };
  }

  factory WatchedMatch.fromMap(Map<String, dynamic> map) {
    return WatchedMatch(
      matchId: map['matchId'] as String,
      usersIds: map['usersIds'] as String,
      teamOne: map['teamOne'] as String,
      teamTwo: map['teamTwo'] as String,
      teamOneScore: map['teamOneScore'] as String,
      teamOneIcon: map['teamOneIcon'] as String,
      teamTwoScore: map['teamTwoScore'] as String,
      teamTwoIcon: map['teamTwoIcon'] as String,
      competition: map['competition'] as String,
      stage: map['stage'] as String,
      duration: map['duration'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchedMatch.fromJson(String source) =>
      WatchedMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WatchedMatch(matchId: $matchId, usersIds: $usersIds, teamOne: $teamOne, teamTwo: $teamTwo, teamOneScore: $teamOneScore, teamOneIcon: $teamOneIcon, teamTwoScore: $teamTwoScore, teamTwoIcon: $teamTwoIcon, competition: $competition, stage: $stage, duration: $duration, time: $time)';
  }

  @override
  bool operator ==(covariant WatchedMatch other) {
    if (identical(this, other)) return true;

    return other.matchId == matchId &&
        other.usersIds == usersIds &&
        other.teamOne == teamOne &&
        other.teamTwo == teamTwo &&
        other.teamOneScore == teamOneScore &&
        other.teamOneIcon == teamOneIcon &&
        other.teamTwoScore == teamTwoScore &&
        other.teamTwoIcon == teamTwoIcon &&
        other.competition == competition &&
        other.stage == stage &&
        other.duration == duration &&
        other.time == time;
  }

  @override
  int get hashCode {
    return matchId.hashCode ^
        usersIds.hashCode ^
        teamOne.hashCode ^
        teamTwo.hashCode ^
        teamOneScore.hashCode ^
        teamOneIcon.hashCode ^
        teamTwoScore.hashCode ^
        teamTwoIcon.hashCode ^
        competition.hashCode ^
        stage.hashCode ^
        duration.hashCode ^
        time.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LiveMatch {
  final String league;
  final String date;
  final String time;
  final String status;
  final String score;
  final String homeName;
  final String homeLogo;
  final String awayName;
  final String awayLogo;
  final String id;
  LiveMatch({
    required this.league,
    required this.date,
    required this.time,
    required this.status,
    required this.score,
    required this.homeName,
    required this.homeLogo,
    required this.awayName,
    required this.awayLogo,
    required this.id,
  });

  LiveMatch copyWith({
    String? league,
    String? date,
    String? time,
    String? status,
    String? score,
    String? homeName,
    String? homeLogo,
    String? awayName,
    String? awayLogo,
    String? id,
  }) {
    return LiveMatch(
      league: league ?? this.league,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      score: score ?? this.score,
      homeName: homeName ?? this.homeName,
      homeLogo: homeLogo ?? this.homeLogo,
      awayName: awayName ?? this.awayName,
      awayLogo: awayLogo ?? this.awayLogo,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'league': league,
      'date': date,
      'time': time,
      'status': status,
      'score': score,
      'home_name': homeName,
      'home_logo': homeLogo,
      'away_name': awayName,
      'away_logo': awayLogo,
      'id': id,
    };
  }

  factory LiveMatch.fromMap(Map<String, dynamic> map) {
    return LiveMatch(
      league: map['league'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      status: map['status'] as String,
      score: map['score'] as String,
      homeName: map['home_name'] as String,
      homeLogo: map['home_logo'] as String,
      awayName: map['away_name'] as String,
      awayLogo: map['away_logo'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LiveMatch.fromJson(String source) =>
      LiveMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LiveMatch(league: $league, date: $date, time: $time, status: $status, score: $score, homeName: $homeName, homeLogo: $homeLogo, awayName: $awayName, awayLogo: $awayLogo, id: $id)';
  }

  @override
  bool operator ==(covariant LiveMatch other) {
    if (identical(this, other)) return true;

    return other.league == league &&
        other.date == date &&
        other.time == time &&
        other.status == status &&
        other.score == score &&
        other.homeName == homeName &&
        other.homeLogo == homeLogo &&
        other.awayName == awayName &&
        other.awayLogo == awayLogo &&
        other.id == id;
  }

  @override
  int get hashCode {
    return league.hashCode ^
        date.hashCode ^
        time.hashCode ^
        status.hashCode ^
        score.hashCode ^
        homeName.hashCode ^
        homeLogo.hashCode ^
        awayName.hashCode ^
        awayLogo.hashCode ^
        id.hashCode;
  }
}

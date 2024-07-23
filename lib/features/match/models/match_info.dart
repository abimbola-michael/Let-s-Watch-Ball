// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MatchInfo {
  String league;
  String homeName;
  String homeLogo;
  String awayName;
  String awayLogo;
  MatchInfo({
    required this.league,
    required this.homeName,
    required this.homeLogo,
    required this.awayName,
    required this.awayLogo,
  });

  MatchInfo copyWith({
    String? league,
    String? homeName,
    String? homeLogo,
    String? awayName,
    String? awayLogo,
  }) {
    return MatchInfo(
      league: league ?? this.league,
      homeName: homeName ?? this.homeName,
      homeLogo: homeLogo ?? this.homeLogo,
      awayName: awayName ?? this.awayName,
      awayLogo: awayLogo ?? this.awayLogo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'league': league,
      'homeName': homeName,
      'homeLogo': homeLogo,
      'awayName': awayName,
      'awayLogo': awayLogo,
    };
  }

  factory MatchInfo.fromMap(Map<String, dynamic> map) {
    return MatchInfo(
      league: map['league'] as String,
      homeName: map['homeName'] as String,
      homeLogo: map['homeLogo'] as String,
      awayName: map['awayName'] as String,
      awayLogo: map['awayLogo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchInfo.fromJson(String source) =>
      MatchInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MatchInfo(league: $league, homeName: $homeName, homeLogo: $homeLogo, awayName: $awayName, awayLogo: $awayLogo)';
  }

  @override
  bool operator ==(covariant MatchInfo other) {
    if (identical(this, other)) return true;

    return other.league == league &&
        other.homeName == homeName &&
        other.homeLogo == homeLogo &&
        other.awayName == awayName &&
        other.awayLogo == awayLogo;
  }

  @override
  int get hashCode {
    return league.hashCode ^
        homeName.hashCode ^
        homeLogo.hashCode ^
        awayName.hashCode ^
        awayLogo.hashCode;
  }
}

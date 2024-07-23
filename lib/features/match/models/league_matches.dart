// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'live_match.dart';

class LeagueMatches {
  String league;
  List<LiveMatch> matches;
  LeagueMatches({
    required this.league,
    required this.matches,
  });

  LeagueMatches copyWith({
    String? league,
    List<LiveMatch>? matches,
  }) {
    return LeagueMatches(
      league: league ?? this.league,
      matches: matches ?? this.matches,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'league': league,
      'matches': matches.map((x) => x.toMap()).toList(),
    };
  }

  factory LeagueMatches.fromMap(Map<String, dynamic> map) {
    return LeagueMatches(
      league: map['league'] as String,
      matches: List<LiveMatch>.from(
        (map['matches'] as List<dynamic>).map<LiveMatch>(
          (x) => LiveMatch.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LeagueMatches.fromJson(String source) =>
      LeagueMatches.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LeagueMatches(league: $league, matches: $matches)';

  @override
  bool operator ==(covariant LeagueMatches other) {
    if (identical(this, other)) return true;

    return other.league == league && listEquals(other.matches, matches);
  }

  @override
  int get hashCode => league.hashCode ^ matches.hashCode;
}

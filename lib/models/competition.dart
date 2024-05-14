// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:watchball/models/football_match.dart';

class Competition {
  String name;
  String logo;
  String stage;
  String host;
  List<FootballMatch> matches;
  Competition({
    required this.name,
    required this.logo,
    required this.stage,
    required this.host,
    required this.matches,
  });

  Competition copyWith({
    String? name,
    String? logo,
    String? stage,
    String? host,
    List<FootballMatch>? matches,
  }) {
    return Competition(
      name: name ?? this.name,
      logo: logo ?? this.logo,
      stage: stage ?? this.stage,
      host: host ?? this.host,
      matches: matches ?? this.matches,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'logo': logo,
      'stage': stage,
      'host': host,
      'matches': matches.map((x) => x.toMap()).toList(),
    };
  }

  factory Competition.fromMap(Map<String, dynamic> map) {
    return Competition(
      name: map['name'] as String,
      logo: map['logo'] as String,
      stage: map['stage'] as String,
      host: map['host'] as String,
      matches: List<FootballMatch>.from(
        (map['matches'] as List<int>).map<FootballMatch>(
          (x) => FootballMatch.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Competition.fromJson(String source) =>
      Competition.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Competition(name: $name, logo: $logo, stage: $stage, host: $host, matches: $matches)';
  }

  @override
  bool operator ==(covariant Competition other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.logo == logo &&
        other.stage == stage &&
        other.host == host &&
        listEquals(other.matches, matches);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        logo.hashCode ^
        stage.hashCode ^
        host.hashCode ^
        matches.hashCode;
  }
}

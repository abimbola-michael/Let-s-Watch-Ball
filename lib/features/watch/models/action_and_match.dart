// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:watchball/features/match/models/live_match.dart';

class ActionAndMatch {
  String? action;
  LiveMatch? match;
  ActionAndMatch({
    this.action,
    this.match,
  });

  ActionAndMatch copyWith({
    String? action,
    LiveMatch? match,
  }) {
    return ActionAndMatch(
      action: action ?? this.action,
      match: match ?? this.match,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'action': action,
      'match': match?.toMap(),
    };
  }

  factory ActionAndMatch.fromMap(Map<String, dynamic> map) {
    return ActionAndMatch(
      action: map['action'] != null ? map['action'] as String : null,
      match: map['match'] != null
          ? LiveMatch.fromMap(map['match'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActionAndMatch.fromJson(String source) =>
      ActionAndMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ActionAndMatch(action: $action, match: $match)';

  @override
  bool operator ==(covariant ActionAndMatch other) {
    if (identical(this, other)) return true;

    return other.action == action && other.match == match;
  }

  @override
  int get hashCode => action.hashCode ^ match.hashCode;
}

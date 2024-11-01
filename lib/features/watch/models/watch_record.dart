// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WatchRecord {
  String match;
  String createdAt;
  String? startedAt;
  String? endedAt;
  WatchRecord({
    required this.match,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
  });

  WatchRecord copyWith({
    String? match,
    String? createdAt,
    String? startedAt,
    String? endedAt,
  }) {
    return WatchRecord(
      match: match ?? this.match,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'match': match,
      'createdAt': createdAt,
      'startedAt': startedAt,
      'endedAt': endedAt,
    };
  }

  factory WatchRecord.fromMap(Map<String, dynamic> map) {
    return WatchRecord(
      match: map['match'] as String,
      createdAt: map['createdAt'] as String,
      startedAt: map['startedAt'] != null ? map['startedAt'] as String : null,
      endedAt: map['endedAt'] != null ? map['endedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchRecord.fromJson(String source) =>
      WatchRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WatchRecord(match: $match, createdAt: $createdAt, startedAt: $startedAt, endedAt: $endedAt)';
  }

  @override
  bool operator ==(covariant WatchRecord other) {
    if (identical(this, other)) return true;

    return other.match == match &&
        other.createdAt == createdAt &&
        other.startedAt == startedAt &&
        other.endedAt == endedAt;
  }

  @override
  int get hashCode {
    return match.hashCode ^
        createdAt.hashCode ^
        startedAt.hashCode ^
        endedAt.hashCode;
  }
}

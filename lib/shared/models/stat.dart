// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Stat {
  String id;
  String time;
  Stat({
    required this.id,
    required this.time,
  });

  Stat copyWith({
    String? id,
    String? time,
  }) {
    return Stat(
      id: id ?? this.id,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'time': time,
    };
  }

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      id: map['id'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Stat.fromJson(String source) =>
      Stat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Stat(id: $id, time: $time)';

  @override
  bool operator ==(covariant Stat other) {
    if (identical(this, other)) return true;

    return other.id == id && other.time == time;
  }

  @override
  int get hashCode => id.hashCode ^ time.hashCode;
}

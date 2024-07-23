// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:watchball/features/user/models/user.dart';

class Watcher {
  String id;
  String status;
  String time;
  User? user;
  Watcher({
    required this.id,
    required this.status,
    required this.time,
  });

  Watcher copyWith({
    String? id,
    String? status,
    String? time,
  }) {
    return Watcher(
      id: id ?? this.id,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'time': time,
    };
  }

  factory Watcher.fromMap(Map<String, dynamic> map) {
    return Watcher(
      id: map['id'] as String,
      status: map['status'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Watcher.fromJson(String source) =>
      Watcher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Watcher(id: $id, status: $status, time: $time)';

  @override
  bool operator ==(covariant Watcher other) {
    if (identical(this, other)) return true;

    return other.id == id && other.status == status && other.time == time;
  }

  @override
  int get hashCode => id.hashCode ^ status.hashCode ^ time.hashCode;
}

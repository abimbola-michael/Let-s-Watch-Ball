// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Notif {
  String notifId;
  String id;
  String userId;
  String type;
  String message;
  String time;
  bool seen;
  Notif({
    required this.notifId,
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.time,
    required this.seen,
  });

  Notif copyWith({
    String? notifId,
    String? id,
    String? userId,
    String? type,
    String? message,
    String? time,
    bool? seen,
  }) {
    return Notif(
      notifId: notifId ?? this.notifId,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      time: time ?? this.time,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notifId': notifId,
      'id': id,
      'userId': userId,
      'type': type,
      'message': message,
      'time': time,
      'seen': seen,
    };
  }

  factory Notif.fromMap(Map<String, dynamic> map) {
    return Notif(
      notifId: map['notifId'] as String,
      id: map['id'] as String,
      userId: map['userId'] as String,
      type: map['type'] as String,
      message: map['message'] as String,
      time: map['time'] as String,
      seen: map['seen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notif.fromJson(String source) =>
      Notif.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notif(notifId: $notifId, id: $id, userId: $userId, type: $type, message: $message, time: $time, seen: $seen)';
  }

  @override
  bool operator ==(covariant Notif other) {
    if (identical(this, other)) return true;

    return other.notifId == notifId &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.message == message &&
        other.time == time &&
        other.seen == seen;
  }

  @override
  int get hashCode {
    return notifId.hashCode ^
        id.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        message.hashCode ^
        time.hashCode ^
        seen.hashCode;
  }
}

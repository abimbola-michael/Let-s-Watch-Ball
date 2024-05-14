// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Contact {
  String userId;
  String timeAdded;
  Contact({
    required this.userId,
    required this.timeAdded,
  });

  Contact copyWith({
    String? userId,
    String? timeAdded,
  }) {
    return Contact(
      userId: userId ?? this.userId,
      timeAdded: timeAdded ?? this.timeAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'timeAdded': timeAdded,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      userId: map['userId'] as String,
      timeAdded: map['timeAdded'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Contact(userId: $userId, timeAdded: $timeAdded)';

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.timeAdded == timeAdded;
  }

  @override
  int get hashCode => userId.hashCode ^ timeAdded.hashCode;
}

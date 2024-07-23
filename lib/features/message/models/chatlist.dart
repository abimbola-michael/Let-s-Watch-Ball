// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chatlist {
  String id;
  String createdAt;
  String? type;
  Chatlist({
    required this.id,
    required this.createdAt,
    this.type,
  });

  Chatlist copyWith({
    String? id,
    String? createdAt,
    String? type,
  }) {
    return Chatlist(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'type': type,
    };
  }

  factory Chatlist.fromMap(Map<String, dynamic> map) {
    return Chatlist(
      id: map['id'] as String,
      createdAt: map['createdAt'] as String,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chatlist.fromJson(String source) =>
      Chatlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Chatlist(id: $id, createdAt: $createdAt, type: $type)';

  @override
  bool operator ==(covariant Chatlist other) {
    if (identical(this, other)) return true;

    return other.id == id && other.createdAt == createdAt && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ createdAt.hashCode ^ type.hashCode;
}

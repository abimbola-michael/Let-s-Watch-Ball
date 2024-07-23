// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PhoneContact {
  String id;
  String phone;
  String name;
  String createdAt;
  String modifiedAt;
  bool canSeeStories;
  bool canMessage;
  bool canInviteToWatch;
  bool canJoinWatch;
  PhoneContact({
    required this.id,
    required this.phone,
    required this.name,
    required this.createdAt,
    required this.modifiedAt,
    required this.canSeeStories,
    required this.canMessage,
    required this.canInviteToWatch,
    required this.canJoinWatch,
  });

  PhoneContact copyWith({
    String? id,
    String? phone,
    String? name,
    String? createdAt,
    String? modifiedAt,
    bool? canSeeStories,
    bool? canMessage,
    bool? canInviteToWatch,
    bool? canJoinWatch,
  }) {
    return PhoneContact(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      canSeeStories: canSeeStories ?? this.canSeeStories,
      canMessage: canMessage ?? this.canMessage,
      canInviteToWatch: canInviteToWatch ?? this.canInviteToWatch,
      canJoinWatch: canJoinWatch ?? this.canJoinWatch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phone': phone,
      'name': name,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'canSeeStories': canSeeStories,
      'canMessage': canMessage,
      'canInviteToWatch': canInviteToWatch,
      'canJoinWatch': canJoinWatch,
    };
  }

  factory PhoneContact.fromMap(Map<String, dynamic> map) {
    return PhoneContact(
      id: map['id'] as String,
      phone: map['phone'] as String,
      name: map['name'] as String,
      createdAt: map['createdAt'] as String,
      modifiedAt: map['modifiedAt'] as String,
      canSeeStories: map['canSeeStories'] as bool,
      canMessage: map['canMessage'] as bool,
      canInviteToWatch: map['canInviteToWatch'] as bool,
      canJoinWatch: map['canJoinWatch'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhoneContact.fromJson(String source) =>
      PhoneContact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhoneContact(id: $id, phone: $phone, name: $name, createdAt: $createdAt, modifiedAt: $modifiedAt, canSeeStories: $canSeeStories, canMessage: $canMessage, canInviteToWatch: $canInviteToWatch, canJoinWatch: $canJoinWatch)';
  }

  @override
  bool operator ==(covariant PhoneContact other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.phone == phone &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt &&
        other.canSeeStories == canSeeStories &&
        other.canMessage == canMessage &&
        other.canInviteToWatch == canInviteToWatch &&
        other.canJoinWatch == canJoinWatch;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        phone.hashCode ^
        name.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode ^
        canSeeStories.hashCode ^
        canMessage.hashCode ^
        canInviteToWatch.hashCode ^
        canJoinWatch.hashCode;
  }
}

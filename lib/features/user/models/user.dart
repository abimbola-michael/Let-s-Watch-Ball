// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../../watch/models/watch.dart';
import '../../watch/models/watch_invite.dart';

class User {
  String id;
  String name;
  String email;
  String phone;
  String bio;
  String photo;
  String createdAt;
  String modifiedAt;
  String? deletedAt;
  String? currentWatch;
  //String? requestedWatch;
  //List<String>? invitedWatchs;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.photo,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
    this.currentWatch,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? photo,
    String? createdAt,
    String? modifiedAt,
    String? deletedAt,
    String? currentWatch,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      currentWatch: currentWatch ?? this.currentWatch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'photo': photo,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'deletedAt': deletedAt,
      'currentWatch': currentWatch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      bio: map['bio'] as String,
      photo: map['photo'] as String,
      createdAt: map['createdAt'] as String,
      modifiedAt: map['modifiedAt'] as String,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      currentWatch:
          map['currentWatch'] != null ? map['currentWatch'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, bio: $bio, photo: $photo, createdAt: $createdAt, modifiedAt: $modifiedAt, deletedAt: $deletedAt, currentWatch: $currentWatch)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.bio == bio &&
        other.photo == photo &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt &&
        other.deletedAt == deletedAt &&
        other.currentWatch == currentWatch;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        bio.hashCode ^
        photo.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode ^
        deletedAt.hashCode ^
        currentWatch.hashCode;
  }
}

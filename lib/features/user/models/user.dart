// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class User {
  String id;
  String username;
  String name;
  String email;
  String phone;
  String photo;
  String token;
  String? sub;
  String? subExpiryTime;
  int? dailyLimit;
  String? dailyLimitDate;
  String? bestPlayer;
  String? bestClub;
  String? bestCountry;
  String createdAt;
  String modifiedAt;
  String? deletedAt;
  String? phoneName;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.token,
    this.sub,
    this.subExpiryTime,
    this.dailyLimit,
    this.dailyLimitDate,
    this.bestPlayer,
    this.bestClub,
    this.bestCountry,
    required this.createdAt,
    required this.modifiedAt,
    this.deletedAt,
    this.phoneName,
  });

  User copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? phone,
    String? photo,
    String? token,
    String? sub,
    String? subExpiryTime,
    int? dailyLimit,
    String? dailyLimitDate,
    String? bestPlayer,
    String? bestClub,
    String? bestCountry,
    String? createdAt,
    String? modifiedAt,
    String? deletedAt,
    String? phoneName,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      token: token ?? this.token,
      sub: sub ?? this.sub,
      subExpiryTime: subExpiryTime ?? this.subExpiryTime,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      dailyLimitDate: dailyLimitDate ?? this.dailyLimitDate,
      bestPlayer: bestPlayer ?? this.bestPlayer,
      bestClub: bestClub ?? this.bestClub,
      bestCountry: bestCountry ?? this.bestCountry,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      phoneName: phoneName ?? this.phoneName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'token': token,
      'sub': sub,
      'subExpiryTime': subExpiryTime,
      'dailyLimit': dailyLimit,
      'dailyLimitDate': dailyLimitDate,
      'bestPlayer': bestPlayer,
      'bestClub': bestClub,
      'bestCountry': bestCountry,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'deletedAt': deletedAt,
      'phoneName': phoneName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      photo: map['photo'] as String,
      token: map['token'] as String,
      sub: map['sub'] != null ? map['sub'] as String : null,
      subExpiryTime:
          map['subExpiryTime'] != null ? map['subExpiryTime'] as String : null,
      dailyLimit: map['dailyLimit'] != null ? map['dailyLimit'] as int : null,
      dailyLimitDate: map['dailyLimitDate'] != null
          ? map['dailyLimitDate'] as String
          : null,
      bestPlayer:
          map['bestPlayer'] != null ? map['bestPlayer'] as String : null,
      bestClub: map['bestClub'] != null ? map['bestClub'] as String : null,
      bestCountry:
          map['bestCountry'] != null ? map['bestCountry'] as String : null,
      createdAt: map['createdAt'] as String,
      modifiedAt: map['modifiedAt'] as String,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      phoneName: map['phoneName'] != null ? map['phoneName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, name: $name, email: $email, phone: $phone, photo: $photo, token: $token, sub: $sub, subExpiryTime: $subExpiryTime, dailyLimit: $dailyLimit, dailyLimitDate: $dailyLimitDate, bestPlayer: $bestPlayer, bestClub: $bestClub, bestCountry: $bestCountry, createdAt: $createdAt, modifiedAt: $modifiedAt, deletedAt: $deletedAt, phoneName: $phoneName)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.photo == photo &&
        other.token == token &&
        other.sub == sub &&
        other.subExpiryTime == subExpiryTime &&
        other.dailyLimit == dailyLimit &&
        other.dailyLimitDate == dailyLimitDate &&
        other.bestPlayer == bestPlayer &&
        other.bestClub == bestClub &&
        other.bestCountry == bestCountry &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt &&
        other.deletedAt == deletedAt &&
        other.phoneName == phoneName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        token.hashCode ^
        sub.hashCode ^
        subExpiryTime.hashCode ^
        dailyLimit.hashCode ^
        dailyLimitDate.hashCode ^
        bestPlayer.hashCode ^
        bestClub.hashCode ^
        bestCountry.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode ^
        deletedAt.hashCode ^
        phoneName.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  String id;
  String name;
  String email;
  String phone;
  String timeJoined;
  String bio;
  String photo;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.timeJoined,
    required this.bio,
    required this.photo,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? timeJoined,
    String? bio,
    String? photo,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      timeJoined: timeJoined ?? this.timeJoined,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'timeJoined': timeJoined,
      'bio': bio,
      'photo': photo,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      timeJoined: map['timeJoined'] as String,
      bio: map['bio'] as String,
      photo: map['photo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, timeJoined: $timeJoined, bio: $bio, photo: $photo)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.timeJoined == timeJoined &&
        other.bio == bio &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        timeJoined.hashCode ^
        bio.hashCode ^
        photo.hashCode;
  }
}

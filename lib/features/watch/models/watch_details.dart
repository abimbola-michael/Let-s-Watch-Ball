// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WatchDetails {
  String id;
  String creatorId;
  String homeName;
  String homeLogo;
  String awayName;
  String awayLogo;
  String time;
  WatchDetails({
    required this.id,
    required this.creatorId,
    required this.homeName,
    required this.homeLogo,
    required this.awayName,
    required this.awayLogo,
    required this.time,
  });

  WatchDetails copyWith({
    String? id,
    String? creatorId,
    String? homeName,
    String? homeLogo,
    String? awayName,
    String? awayLogo,
    String? time,
  }) {
    return WatchDetails(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      homeName: homeName ?? this.homeName,
      homeLogo: homeLogo ?? this.homeLogo,
      awayName: awayName ?? this.awayName,
      awayLogo: awayLogo ?? this.awayLogo,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'creatorId': creatorId,
      'homeName': homeName,
      'homeLogo': homeLogo,
      'awayName': awayName,
      'awayLogo': awayLogo,
      'time': time,
    };
  }

  factory WatchDetails.fromMap(Map<String, dynamic> map) {
    return WatchDetails(
      id: map['id'] as String,
      creatorId: map['creatorId'] as String,
      homeName: map['homeName'] as String,
      homeLogo: map['homeLogo'] as String,
      awayName: map['awayName'] as String,
      awayLogo: map['awayLogo'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchDetails.fromJson(String source) =>
      WatchDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WatchDetails(id: $id, creatorId: $creatorId, homeName: $homeName, homeLogo: $homeLogo, awayName: $awayName, awayLogo: $awayLogo, time: $time)';
  }

  @override
  bool operator ==(covariant WatchDetails other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.creatorId == creatorId &&
        other.homeName == homeName &&
        other.homeLogo == homeLogo &&
        other.awayName == awayName &&
        other.awayLogo == awayLogo &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        creatorId.hashCode ^
        homeName.hashCode ^
        homeLogo.hashCode ^
        awayName.hashCode ^
        awayLogo.hashCode ^
        time.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StreamInfo {
  String extraTitle;
  String? streamLink;
  String referer;
  StreamInfo({
    required this.extraTitle,
    required this.streamLink,
    required this.referer,
  });

  StreamInfo copyWith({
    String? extraTitle,
    String? streamLink,
    String? referer,
  }) {
    return StreamInfo(
      extraTitle: extraTitle ?? this.extraTitle,
      streamLink: streamLink ?? this.streamLink,
      referer: referer ?? this.referer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'extra_title': extraTitle,
      'stream_link': streamLink,
      'referer': referer,
    };
  }

  factory StreamInfo.fromMap(Map<String, dynamic> map) {
    return StreamInfo(
      extraTitle: map['extra_title'] as String,
      streamLink: map['stream_link'] as String?,
      referer: map['referer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamInfo.fromJson(String source) =>
      StreamInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StreamInfo(extraTitle: $extraTitle, streamLink: $streamLink, referer: $referer)';

  @override
  bool operator ==(covariant StreamInfo other) {
    if (identical(this, other)) return true;

    return other.extraTitle == extraTitle &&
        other.streamLink == streamLink &&
        other.referer == referer;
  }

  @override
  int get hashCode =>
      extraTitle.hashCode ^ streamLink.hashCode ^ referer.hashCode;
}

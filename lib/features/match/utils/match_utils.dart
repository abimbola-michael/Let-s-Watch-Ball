import 'dart:convert';
import 'package:watchball/features/match/models/live_match.dart';

import '../enums/enums.dart';
import '../models/match_info.dart';

String getGameTime(String status) {
  String time = "";
  for (int i = 0; i < status.length; i++) {
    final char = status[i];
    if (int.tryParse(char) != null) {
      time += char;
    }
  }
  return time;
}

MatchStatus getMatchStatus(String status) {
  if (status.toLowerCase().contains("coming")) {
    return MatchStatus.toPlay;
  }
  if (RegExp(r"[0-9]").hasMatch(status)) {
    return MatchStatus.live;
  }
  return MatchStatus.played;
}

String getMatchString(LiveMatch? match) {
  if (match == null) return "";
  final details = {
    //"id": match.id,
    "league": match.league,
    "homeName": match.homeName,
    "homeLogo": match.homeLogo,
    "awayName": match.awayName,
    "awayLogo": match.awayLogo,
  };
  return jsonEncode(details);
}

MatchInfo getMatchInfo(String info) {
  // return info.isEmpty ? {} : jsonDecode(info);
  return MatchInfo.fromJson(info);
}

String getMatchTitle(MatchInfo matchInfo) {
  return "${matchInfo.homeName} vs ${matchInfo.awayName}";
}

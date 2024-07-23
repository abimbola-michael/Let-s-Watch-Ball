import 'dart:convert';
import 'package:watchball/features/match/models/live_match.dart';

import '../models/match_info.dart';

String getMatchString(LiveMatch? match) {
  if (match == null) return "";
  final details = {
    //"id": match.id,
    "league": match.league,
    "homeName": match.homeName,
    "homeLogo": match.homeLogo,
    "awayName": match.homeName,
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

import 'package:watchball/utils/mockdatas/matches.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../models/competition.dart';

List<Competition> allLeagues = [
  Competition(
    name: "Premier League",
    logo: Flags.england,
    stage: "Semi Finals",
    host: "England",
    matches: liveMatches,
  ),
];

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/match/models/live_match.dart';

class MatchesNotifier extends StateNotifier<List<LiveMatch>> {
  MatchesNotifier(super.state);
  void updateMatches(List<LiveMatch> matches) {
    state = matches;
  }
}

final matchesProvider = StateNotifierProvider<MatchesNotifier, List<LiveMatch>>(
  (ref) => MatchesNotifier([]),
);

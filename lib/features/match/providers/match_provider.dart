import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/match/models/live_match.dart';

class MatchNotifier extends StateNotifier<LiveMatch?> {
  MatchNotifier(super.state);
  void updateMatch(LiveMatch? match) {
    state = match;
  }
}

final matchProvider = StateNotifierProvider<MatchNotifier, LiveMatch?>(
  (ref) {
    return MatchNotifier(null);
  },
);

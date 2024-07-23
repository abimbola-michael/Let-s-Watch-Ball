import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/watched_match.dart';

class WatchedsNotifier extends StateNotifier<List<WatchedMatch>> {
  WatchedsNotifier(super.state);

  void clearWatchedMatches(List<WatchedMatch> matches) {
    state = [];
  }

  void setWatchedMatches(List<WatchedMatch> matches) {
    state = matches;
  }

  void addWatchedMatch(WatchedMatch match) {
    state = [...state, match];
  }

  void removeWatchedMatch(WatchedMatch match) {
    state =
        state.where((prevmatch) => prevmatch.matchId != match.matchId).toList();
  }
}

final watchedsProvider =
    StateNotifierProvider<WatchedsNotifier, List<WatchedMatch>>(
  (ref) {
    return WatchedsNotifier([]);
  },
);

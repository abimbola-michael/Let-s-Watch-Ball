// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/match/models/live_match.dart';

import '../models/action_and_match.dart';

class WatchActionAndMatchNotifier extends StateNotifier<ActionAndMatch> {
  WatchActionAndMatchNotifier(super.state);

  void updateAction(String action) {
    state = state.copyWith(action: action);
  }

  void updateMatch(LiveMatch match) {
    state = state.copyWith(match: match);
  }
}

final watchActionAndMatchProvider =
    StateNotifierProvider<WatchActionAndMatchNotifier, ActionAndMatch>(
  (ref) {
    return WatchActionAndMatchNotifier(ActionAndMatch());
  },
);

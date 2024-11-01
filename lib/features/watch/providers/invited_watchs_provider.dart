import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user/models/user.dart';
import '../models/watch.dart';

class InvitedWatchsNotifier extends StateNotifier<List<Watch>> {
  InvitedWatchsNotifier(super.state);

  void clearWatchWatchs(List<Watch> watchs) {
    state = [];
  }

  void setWatchs(List<Watch> watchs) {
    state = watchs;
  }

  void addWatch(Watch watch) {
    state = [...state, watch];
  }

  void addAllWatchs(List<Watch> watchs) {
    state = [...state, ...watchs];
  }

  void removeWatch(Watch watch) {
    state = state.where((prevWatch) => prevWatch.id != watch.id).toList();
  }
}

final invitedWatchsProvider =
    StateNotifierProvider<InvitedWatchsNotifier, List<Watch>>(
  (ref) {
    return InvitedWatchsNotifier([]);
  },
);

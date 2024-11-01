import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user/models/user.dart';
import '../models/watch.dart';

class AvailableWatchsNotifier extends StateNotifier<List<Watch>> {
  AvailableWatchsNotifier(super.state);

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

final availableWatchsProvider =
    StateNotifierProvider<AvailableWatchsNotifier, List<Watch>>(
  (ref) {
    return AvailableWatchsNotifier([]);
  },
);

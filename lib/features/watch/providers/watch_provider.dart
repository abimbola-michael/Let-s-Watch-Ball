import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/watch.dart';

class WatchNotifier extends StateNotifier<Watch?> {
  WatchNotifier(super.state);

  void updateWatch(Watch? watch) {
    state = watch;
  }
}

final watchProvider = StateNotifierProvider<WatchNotifier, Watch?>(
  (ref) {
    return WatchNotifier(null);
  },
);

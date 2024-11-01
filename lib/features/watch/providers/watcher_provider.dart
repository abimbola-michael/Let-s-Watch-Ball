import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/watcher.dart';

class WatcherNotifier extends StateNotifier<Watcher?> {
  WatcherNotifier(super.state);

  void updateWatcher(Watcher? watcher) {
    state = watcher;
  }
}

final watcherProvider = StateNotifierProvider<WatcherNotifier, Watcher?>(
  (ref) {
    return WatcherNotifier(null);
  },
);

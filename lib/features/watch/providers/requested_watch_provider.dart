import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchNotifier extends StateNotifier<String?> {
  WatchNotifier(super.state);
  void updateWatch(String? watch) {
    state = watch;
  }
}

final requestedWatchProvider = StateNotifierProvider<WatchNotifier, String?>(
  (ref) {
    return WatchNotifier(null);
  },
);

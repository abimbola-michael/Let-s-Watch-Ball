import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchWatchsNotifier extends StateNotifier<String> {
  SearchWatchsNotifier(super.state);

  void updateSearch(String text) {
    state = text;
  }
}

final searchWatchProvider = StateNotifierProvider<SearchWatchsNotifier, String>(
  (ref) {
    return SearchWatchsNotifier("");
  },
);

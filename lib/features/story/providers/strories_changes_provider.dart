import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../firebase/firestore_methods.dart';
import '../models/story.dart';

class StoriesChangesNotifier extends StateNotifier<List<ValueChange<Story>>> {
  StoriesChangesNotifier(super.state);

  void setStoriesChanges(List<ValueChange<Story>> storiesChanges) {
    state = storiesChanges;
  }
}

final storiesChangesProvider =
    StateNotifierProvider<StoriesChangesNotifier, List<ValueChange<Story>>>(
  (ref) {
    return StoriesChangesNotifier([]);
  },
);

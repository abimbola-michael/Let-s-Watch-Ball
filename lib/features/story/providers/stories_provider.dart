import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/story/models/story.dart';

class StoriesNotifier extends StateNotifier<List<Story>> {
  StoriesNotifier(super.state);

  void clearStories(List<Story> stories) {
    state = [];
  }

  void setStories(List<Story> stories) {
    state = stories;
  }

  void addStory(Story stories) {
    state = [...state, stories];
  }

  void removeStory(Story status) {
    state = state.where((prevStory) => prevStory.id != status.id).toList();
  }
}

final storiesProvider = StateNotifierProvider<StoriesNotifier, List<Story>>(
  (ref) {
    return StoriesNotifier([]);
  },
);

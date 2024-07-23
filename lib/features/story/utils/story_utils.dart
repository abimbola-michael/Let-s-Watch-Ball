import 'package:watchball/features/story/models/story.dart';
import 'package:watchball/utils/utils.dart';

import '../models/story.dart';

Map<String, Story> getGroupedUserStories(List<Story> stories) {
  Map<String, Story> storyMap = {};
  for (int i = 0; i < stories.length; i++) {
    final story = stories[i];

    if (story.userId != myId && storyMap[story.userId] == null) {
      storyMap[story.userId] = story;
    }
    // if (story.status == "sent" && story.userId != myId) {
    //   story.unread = (story.unread ?? 0) + 1;
    // }
    storyMap[story.userId]!.stories.add(story);
  }
  return storyMap;
}

Map<String, Story> getGroupedMatchStories(List<Story> stories) {
  Map<String, Story> storyMap = {};
  for (int i = 0; i < stories.length; i++) {
    final story = stories[i];
    if (storyMap[story.matchId] == null) {
      storyMap[story.matchId] = story;
    }
    // if (story.status == "sent") {
    //   story.unread = (story.unread ?? 0) + 1;
    // }
    storyMap[story.userId]!.stories.add(story);
  }
  return storyMap;
}

List<Story> getGroupedStories(List<Story> stories, {required bool isMatch}) {
  List<Story> stories = [];
  Map<String, int> storyMap = {};
  for (int i = 0; i < stories.length; i++) {
    var story = stories[i];
    final id = isMatch ? story.matchId : story.userId;
    var index = storyMap[id];
    if (index == null) {
      index = stories.length;
      storyMap[id] = index;
      stories.add(story);
    } else {
      final prevMessage = stories[index];
      final prevMessages = prevMessage.stories;
      //final unread = prevMessage.unread;
      final user = prevMessage.user;
      prevMessages.add(story);

      stories[index] = story;
      //stories[index].unread = unread;
      stories[index].stories = prevMessages;
      stories[index].user = user;
    }
    story = stories[index];

    // if (story.status == "sent") {
    //   story.unread = (story.unread ?? 0) + 1;
    // }
  }
  return stories;
}

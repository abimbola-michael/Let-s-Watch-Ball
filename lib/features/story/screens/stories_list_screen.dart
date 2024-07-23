import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/message/components/message_item.dart';
import 'package:watchball/features/message/models/message.dart';
import 'package:watchball/features/story/models/story.dart';
import 'package:watchball/features/story/providers/strories_changes_provider.dart';

import '../../../shared/views/empty_list_view.dart';
import '../components/story_item.dart';
import '../providers/stories_provider.dart';
import '../utils/story_utils.dart';

class StoriesListScreen extends ConsumerStatefulWidget {
  final bool isMatch;
  const StoriesListScreen({super.key, required this.isMatch});

  @override
  ConsumerState<StoriesListScreen> createState() => _StoriesListScreenState();
}

class _StoriesListScreenState extends ConsumerState<StoriesListScreen> {
  bool loading = false;

  List<Story> stories = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allStories = ref.watch(storiesProvider);
    stories = getGroupedStories(allStories, isMatch: widget.isMatch);
    //final storiesChanges =  ref.watch(storiesChangesProvider);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (stories.isEmpty) {
      return const EmptyListView(message: "No story");
    }
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryItem(story: story);
      },
    );
  }
}

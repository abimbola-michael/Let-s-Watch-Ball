import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/user/models/user.dart';
import 'package:watchball/features/story/providers/stories_provider.dart';
import 'package:watchball/features/story/services/story_service.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/utils/extensions.dart';

import '../../story/components/story_item.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_container.dart';
import '../../../shared/components/button.dart';
import '../../story/models/story.dart';
import '../../../theme/colors.dart';

class StoryScreen extends ConsumerStatefulWidget {
  static const route = "/story";
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  List<Story> stories = [];
  final _storyController = TextEditingController();
  final _scrollController = ScrollController();
  //String matchId = "";
  String receiverId = "";
  Story? replyStory;
  User? user;
  LiveMatch? match;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // stories.addAll(allStories);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // });
    scrollToBottom();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //matchId = context.args["matchId"] ?? "";
    match = context.args["match"];
    receiverId = context.args["receiverId"] ?? "";
    user = context.args["user"];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _storyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future getUserInfo() async {
    user = await getUser(receiverId);
    setState(() {});
  }

  void readStories() {}

  void sendStory() async {
    String text = _storyController.text;
    int index = stories.length;
    // final sentStory =
    //     await createStory(match, receiverId, text, replyStory, (story) {
    //   stories.add(story.copyWith(status: "sending"));
    //   setState(() {});
    // });

    // stories[index] = sentStory;
    _storyController.clear();

    scrollToBottom();
    setState(() {});
  }

  void scrollToBottom() async {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.ease);
  }

  void toggleEmojiKeyboard() {}

  @override
  Widget build(BuildContext context) {
    // final allStories = ref.watch(storiesProvider);
    // stories = allStories
    //     .where(
    //       (story) =>
    //           story.matchId == match.id &&
    //           (story.userId == receiverId ||
    //               story.receiverId == receiverId),
    //     )
    //     .toList();
    return Scaffold(
      appBar: const AppAppBar(
        title: "Story",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                // reverse: true,
                padding: EdgeInsets.zero,
                controller: _scrollController,
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  //return StoryItem(story: story);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppContainer(
              color: const Color(0xFFEAEAEA),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  IconButton(
                      onPressed: toggleEmojiKeyboard,
                      icon: const Icon(OctIcons.smiley)),
                  Expanded(
                    child: TextField(
                      maxLines: 4,
                      minLines: 1,
                      controller: _storyController,
                      style: context.bodySmall,
                      decoration: InputDecoration(
                        hintText: "Write your story...",
                        hintStyle: context.bodySmall
                            ?.copyWith(color: const Color(0xFF4F4E53)),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  if (_storyController.text.isNotEmpty) ...[
                    const SizedBox(
                      width: 10,
                    ),
                    Button(
                      width: 38,
                      height: 38,
                      isCircular: true,
                      color: primaryColor,
                      onPressed: sendStory,
                      child: const Icon(
                        EvaIcons.paper_plane_outline,
                        color: white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

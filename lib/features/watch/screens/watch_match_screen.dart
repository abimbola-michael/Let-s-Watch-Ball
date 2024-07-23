import 'package:cached_chewie_plus/cached_chewie_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/watch/providers/watch_provider.dart';
import 'package:watchball/features/comment/screens/comment_screen.dart';
import 'package:watchball/features/message/screens/message_screen.dart';
import 'package:watchball/features/wallet/screens/select_users_screen.dart';
import 'package:watchball/features/watch/screens/watchers_screen.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/features/user/mocks/users.dart';

import '../../../shared/components/columnorrow.dart';
import '../../../shared/components/logo.dart';
import '../../match/components/live_match_item.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_container.dart';
import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/app_tabbar.dart';
import '../../user/components/user_hor_item.dart';
import '../../user/models/user.dart';
import '../services/live_stream_service.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';

class WatchMatchScreen extends ConsumerStatefulWidget {
  static const route = "/watch-match";
  const WatchMatchScreen({super.key});

  @override
  ConsumerState<WatchMatchScreen> createState() => _WatchMatchScreenState();
}

class _WatchMatchScreenState extends ConsumerState<WatchMatchScreen> {
  List<String> tabs = [
    "Watchers",
    "Comments",
    "Messages",
    "Stories",
    "Recent Matches",
    "Invitations"
  ];

  List<LiveMatch> matches = [];
  List<String?> streamLinks = [];
  int matchIndex = 0;
  final _matchPageController = PageController();
  bool isFirstTime = true;

  CachedVideoPlayerController? _playerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isFirstTime) {
      final match = context.args["match"];
      matches.add(match);
      streamLinks.add("");
      // currentWatch = context.args["watch"];
      // if (currentWatch != null) {
      //   currentWatchId = currentWatch!.id;
      //   listenForWatch();
      //   // match = watch!.match;
      //   // watchLink = "watchball.hms.com/${watch!.id}";
      //   // readWatchers();
      // } else {
      //   createNewWatch();
      // }
      //getStreamLink();
      isFirstTime = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _matchPageController.dispose();
    _playerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void updateMatchIndex(int index) {
    setState(() {
      matchIndex = index;
    });
    playVideo();
  }

  void playVideo() async {
    String? streamLink = streamLinks[matchIndex];
    final match = matches[matchIndex];
    if (streamLink == "") {
      final result = await getLiveStream(match.id);
      if (result.isEmpty) {
        streamLink = null;
      } else {
        String? link = result[0].streamLink;
        if (link == "null") {
          link = null;
        }
        streamLink = link;
      }
    }

    if (streamLink != null && !isWindows) {
      _playerController =
          CachedVideoPlayerController.networkUrl(Uri.parse(streamLink!));
      await _playerController!.initialize().then((_) {
        // if (_playerController!.value.isInitialized) {
        //   _playerController!.play();
        //   setState(() {});
        //   print("Initialized");
        // }
      }).catchError((e) {
        print("Error ${e.message}");
        streamLink = null;
        setState(() {});
      });
      _chewieController = ChewieController(
          videoPlayerController: _playerController!,
          autoPlay: true,
          looping: false);
    }
    if (!mounted) return;

    setState(() {});
  }

  Future getStreamLink() async {
    // try {
    //   final result = await getLiveStream(match.id);
    //   if (result.isEmpty) return;

    //   String? link = result[0].streamLink;
    //   if (link == "null") {
    //     link = null;
    //   }
    //   streamLink = link;
    //   print("streamLink = $streamLink");
    //   if (streamLink != null) {
    //     playVideo();
    //   } else {
    //     loadingMatch = false;
    //     setState(() {});
    //   }
    // } on DioException catch (e) {
    //   streamLink = null;
    //   setState(() {});
    // }
  }

  void addOrGotoMatch(LiveMatch match) {
    if (match.id == matches[matchIndex].id) return;
    int prevIndex = matches.indexWhere((prevMatch) => prevMatch.id == match.id);
    if (prevIndex == -1) {
      matches.add(match);
      streamLinks.add("");
      matchIndex = matches.length - 1;
    } else {
      matchIndex = prevIndex;
    }

    _matchPageController.jumpToPage(matchIndex);
    setState(() {});
  }

  void addMatch(LiveMatch match) {
    matches.add(match);
    streamLinks.add("");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentWatch = ref.watch(watchProvider);
    if (currentWatch != null) {
      addOrGotoMatch(currentWatch.match);
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: const AppAppBar(
          title: "Watch",
        ),
        body: ColumnOrRow(
          column: context.isPortrait,
          children: [
            Flexible(
              flex: context.isPortrait ? 0 : 1,
              fit: context.isPortrait ? FlexFit.loose : FlexFit.tight,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: matches.isNotEmpty
                    ? PageView.builder(
                        controller: _matchPageController,
                        onPageChanged: updateMatchIndex,
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          final streamLink = streamLinks[index];
                          return SizedBox.expand(
                            // child: streamLink == ""
                            //     ? const Center(
                            //         child: CircularProgressIndicator(),
                            //       )
                            //     : streamLink != null && streamLink!.isNotEmpty
                            //         ? _chewieController != null
                            //             ? Chewie(
                            //                 controller: _chewieController!,
                            //               )
                            //             : null

                            //         // ? BetterPlayer.network(
                            //         //     streamLink!,
                            //         //     //  betterPlayerConfiguration: BetterPlayerConfiguration(),
                            //         //   )
                            //         : Center(
                            //             child: Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: streamLink == null
                            //                 ? Text(
                            //                     "Stream link not available yet. Watch out for the match",
                            //                     style: context.bodySmall,
                            //                     textAlign: TextAlign.center)
                            //                 : const CircularProgressIndicator(),
                            //           )),
                            child: AppContainer(
                              color: lighterTint,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, scroll) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      collapsedHeight: 150,
                      backgroundColor: transparent,
                      automaticallyImplyLeading: true,
                      title: Container(),
                      flexibleSpace: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            matches[matchIndex].league,
                            style:
                                context.headlineSmall?.copyWith(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          LiveMatchItem(match: matches[matchIndex]),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ];
                },
                body: DefaultTabController(
                  length: tabs.length,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        dividerColor: transparent,
                        tabs: List.generate(
                          tabs.length,
                          (index) {
                            final tab = tabs[index];
                            return Tab(
                              text: tab,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: List.generate(tabs.length, (index) {
                            final tab = tabs[index];
                            switch (tab) {
                              case "Watchers":
                                return const WatchersScreen();
                              case "Comments":
                                return CommentScreen(
                                  match: matches[matchIndex],
                                );
                              case "Messages":
                                return Container();
                              // return const MessageScreen();
                              case "Stories":
                                return Container();

                              case "Recent Matches":
                                return Container();

                              case "Invitations":
                                return Container();
                            }

                            return Container();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

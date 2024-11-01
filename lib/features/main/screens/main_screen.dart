import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:watchball/features/story/providers/stories_provider.dart';
import 'package:watchball/firebase/auth_methods.dart';
import 'package:watchball/shared/components/app_bottom_navigation_bar.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/features/watch/providers/watchs_history_provider.dart';
import 'package:watchball/features/match/providers/match_provider.dart';
import 'package:watchball/features/watch/providers/requested_watch_provider.dart';
import 'package:watchball/features/watch/providers/watch_provider.dart';
import 'package:watchball/features/watch/screens/watchs_screen.dart';
import 'package:watchball/features/message/screens/messages_screen.dart';
import 'package:watchball/features/story/screens/stories_screen.dart';
import 'package:watchball/features/wallet/screens/wallet_screen.dart';
import 'package:watchball/features/match/screens/prev_matches_screen.dart';
import 'package:watchball/features/profile/screens/profile_screen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/watch/screens/watchers_screen.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/features/message/utils/message_utils.dart';
import 'package:watchball/utils/utils.dart';

import '../../../main.dart';
import '../../../utils/country_code_utils.dart';
import '../../contact/models/phone_contact.dart';
import '../../../shared/models/list_change.dart';
import '../../contact/providers/contacts_provider.dart';
import '../../match/models/live_match.dart';
import '../../message/models/chatlist.dart';
import '../../message/models/message.dart';
import '../../story/models/story.dart';
import '../../story/providers/strories_changes_provider.dart';
import '../../user/models/user.dart';
import '../../user/providers/users_provider.dart';
import '../../user/providers/user_provider.dart';
import '../../watch/services/live_stream_service.dart';
import '../../message/services/message_service.dart';
import '../../story/services/story_service.dart';
import '../../../theme/colors.dart';
import '../../story/utils/story_utils.dart';
import '../../match/screens/matches_screen.dart';
import '../../watch/screens/watchs_history_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  static const route = "/main";
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int currentIndex = 0;
  StreamSubscription? userSub;
  StreamSubscription? watchSub;
  StreamSubscription? messagesSub;
  StreamSubscription? updatesSub;
  StreamSubscription? invitationsSub;
  StreamSubscription? watchedSub;
  StreamSubscription? chatlistsSub;
  StreamSubscription? contactsSub;
  // StreamSubscription? usersSub;
  StreamSubscription? storiesSub;

  Watch? currentWatch;
  String? currentWatchId;
  String? requestedWatchId;
  // List<Watch>? invitedWatchs;
  List<IconData> icons = [
    MingCute.football_line,
    MingCute.tv_2_line,
    // MingCute.message_1_line,
    // MingCute.live_photo_fill,
    //MingCute.invite_line,
    OctIcons.person
  ];
  List<int> badgeCounts = [0, 0, 0];
  int unseenWatchsCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountryDialCode();
    //AuthMethods().logOut();
    //listenForUserUpdate();
    //listenForContacts();
    //FlutterContacts.addListener(listenForContacts);
  }

  @override
  void dispose() {
    userSub?.cancel();
    watchSub?.cancel();
    messagesSub?.cancel();
    updatesSub?.cancel();
    watchedSub?.cancel();
    invitationsSub?.cancel();
    contactsSub?.cancel();
    chatlistsSub?.cancel();
    storiesSub?.cancel();
    //FlutterContacts.removeListener(listenForContacts);
    super.dispose();
  }

  void getCountryDialCode() async {
    countryDialCode = await getCurrentCountryDialingCode() ?? "";
  }

  // void listenForUserUpdate() async {
  //   // await Hive.openBox<String>("lastIimes");
  //   // await Hive.openBox<Watch>("users");
  //   userSub = streamUser(myId).listen((user) async {
  //     if (user != null) {
  //       ref.read(userProvider.notifier).updateUser(user);
  //       if (currentWatchId != user.currentWatch) {
  //         currentWatchId = user.currentWatch;
  //         watchSub?.cancel();
  //         if (currentWatchId != null) {
  //           watchSub = streamWatch(currentWatchId!).listen((newWatch) async {
  //             ref.read(watchProvider.notifier).updateWatch(newWatch);
  //             if (newWatch == null ||
  //                 newWatch.match.id != currentWatch?.match.id) {
  //               ref.read(matchProvider.notifier).updateMatch(newWatch?.match);
  //             }
  //             currentWatch = newWatch;
  //           });
  //         } else {
  //           watchSub?.cancel();
  //           watchSub = null;
  //           ref.read(watchProvider.notifier).updateWatch(null);
  //         }
  //       }
  //       // else if (requestedWatchId != user.requestedWatch) {
  //       //   requestedWatchId = user.requestedWatch;
  //       //   ref
  //       //       .read(requestedWatchProvider.notifier)
  //       //       .updateWatch(requestedWatchId);
  //       // }
  //       // else if (invitedWatchs != user.invitedWatchs) {
  //       //   final watchsChanges = getListChanges<Watch>(
  //       //       invitedWatchs ?? [],
  //       //       user.invitedWatchs ?? [],
  //       //       (invite) => invite.watchId);
  //       //   invitedWatchs = user.invitedWatchs;
  //       //   //  print("watchsChanges = $watchsChanges");
  //       //   for (int i = 0; i < watchsChanges.length; i++) {
  //       //     final watchsChange = watchsChanges[i];
  //       //     if (watchsChange.type == ListChangeType.added) {
  //       //       final invite = watchsChange.value;
  //       //       ref.read(watchsProvider.notifier).addWatch(invite);

  //       //       final user = await getUser(invite.userId);
  //       //       final watchers = invite.invitedUserIds.contains(",")
  //       //           ? invite.invitedUserIds.split(",")
  //       //           : [invite.invitedUserIds];
  //       //       // final watch = await getWatch(invite.watchId);
  //       //       String message =
  //       //           "${user?.name ?? ""} invited you${watchers.length == 1 ? "" : " and ${watchers.length - 1} others"} to watch ${invite.match}";
  //       //       if (!mounted) return;
  //       //       context.showSnackBar(message, false);

  //       //       // if (user != null && watch != null) {
  //       //       //   String message =
  //       //       //       "${user.name} is inviting you${watch.watchers.length == 2 ? "" : " and ${watch.watchers.length - 2} others"} to watch ${watch.match.homeName} vs ${watch.match.awayName}";
  //       //       //   if (!mounted) return;
  //       //       //   context.showSnackBar(message, false);
  //       //       // }
  //       //     }
  //       //   }
  //       // }
  //     }
  //   });
  // }

  void listenForWatchs() async {
    final watchsBox = Hive.box<String>("watchs");
    // final lastTimesBox = Hive.box<String>("lastTimes");
    // final lastTime = lastTimesBox.get("invite");

    // List<Watch> watchs = watchsBox.values.toList();
    // watchs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void listenForWatched() async {
    //await Hive.openBox<Watched>("watch_history");
    final watchedsBox = Hive.box<String>("watch_history");
    // final lastTimesBox = Hive.box<String>("lastTimes");
    // final lastTime = lastTimesBox.get("watched");

    // List<Watched> watcheds = watchedsBox.values.toList();
    // watcheds.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void listenForUpdates() async {
    //await Hive.openBox<LiveMatch>("updates");
    final matchesBox = Hive.box<String>("matches");
    List<String> matches = matchesBox.values.toList();
    final lastTimesBox = Hive.box<String>("lastTimes");
    // final lastTime = lastTimesBox.get("matches");

    // matches.sort((a, b) =>
    //     getDateTime(b.date, b.time).compareTo(getDateTime(a.date, a.time)));

    // final newMatches = await getMatches();
    // matchesBox.clear();
    // for (int i = 0; i < newMatches.length; i++) {
    //   final match = newMatches[i];
    //   matchesBox.put(match.id, match);
    // }
    // matches = newMatches;
  }

  void listenForStories(List<String> contactIds) async {
    storiesSub?.cancel();
    // final box = await Hive.openBox<Story>("stories");
    final storiesBox = Hive.box<Story>("stories");
    final lastTimesBox = Hive.box<String>("lastTimes");
    String? lastTime = lastTimesBox.get("stories");

    List<Story> stories = storiesBox.values.toList();
    stories.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    //final lastTime = stories.isEmpty ? null : stories.last.createdAt;

    if (contactIds.isEmpty) return;
    storiesSub =
        streamChangeStories(contactIds, lastTime).listen((storiesChanges) {
      storiesChanges.mergeResult(
        stories,
        (value) => value.id,
        createdAtCallback: (value) => value.createdAt,
        modifiedAtCallback: (value) => value.modifiedAt,
        deletedAtCallback: (value) => value.deletedAt,
        changeCallback: (change) {
          if (change.removed) {
            storiesBox.delete(change.value.id);
          } else {
            storiesBox.put(change.value.id, change.value);
          }
          ref
              .read(storiesChangesProvider.notifier)
              .setStoriesChanges(storiesChanges);
        },
      );
      ref.read(storiesProvider.notifier).setStories(stories);

      // for (int i = 0; i < storyChanges.length; i++) {
      //   final storyChange = storyChanges[i];
      //   final type = storyChange.type;
      //   final value = storyChange.value;
      //   if (type == DocumentChangeType.removed) {
      //     storiesBox.delete(value.id);
      //     stories.removeWhere((story) => story.id == value.id);
      //     return;
      //   }
      //   lastTimesBox.put("stories", value.modifiedAt);
      //   if (value.modifiedAt == value.createdAt) {
      //     storiesBox.put(value.id, value);
      //     stories.add(value);
      //   } else if (value.modifiedAt == value.deletedAt) {
      //     storiesBox.delete(value.id);
      //     stories.removeWhere((story) => story.id == value.id);
      //   } else {
      //     storiesBox.put(value.id, value);
      //     final storyIndex =
      //         stories.indexWhere((story) => story.id == value.id);
      //     if (storyIndex != -1) {
      //       stories[storyIndex] = value;
      //     }
      //   }

      // if (type == DocumentChangeType.added) {
      //   storiesBox.put(value.id, value);
      //   stories.add(value);
      // } else if (type == DocumentChangeType.modified) {
      //   if (value.deletedAt != null) {
      //     stories.removeWhere((story) => story.id == value.id);
      //   } else {
      //     final storyIndex =
      //         stories.indexWhere((story) => story.id == value.id);
      //     if (storyIndex != -1) {
      //       stories[storyIndex] = value;
      //     }
      //   }
      //   storiesBox.put(value.id, value);
      // } else if (type == DocumentChangeType.removed) {
      //   stories.removeWhere((story) => story.id == value.id);
      //   storiesBox.delete(value.id);
      // }
      //}
    });
  }

  void listenForChatlist() async {
    await Hive.openBox<Chatlist>("chatlist");
    final chatlistBox = Hive.box<Chatlist>("chatlist");
    List<Chatlist> chatlist = chatlistBox.values.toList();
    chatlist.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final lastTime = chatlist.isEmpty ? null : chatlist.last.createdAt;
    List<String> chatlistIds = chatlist.map((value) => value.id).toList();

    chatlistsSub = streamChangeChatlist(lastTime).listen((messageChanges) {
      for (int i = 0; i < messageChanges.length; i++) {
        final messageChange = messageChanges[i];
        final type = messageChange.type;
        final value = messageChange.value;
        if (type == DocumentChangeType.added) {
          chatlistIds.add(value.id);
          chatlistBox.put(value.id, value);
        } else if (type == DocumentChangeType.modified) {
          chatlistBox.put(value.id, value);
        } else if (type == DocumentChangeType.removed) {
          chatlistIds.remove(value.id);
          chatlistBox.delete(value.id);
        }
      }
      listenForMessages(chatlistIds);
    });
  }

  void listenForMessages(List<String> chatlistIds) async {
    messagesSub?.cancel();
    //await Hive.openBox<Message>("messages");
    final messageBox = Hive.box<Message>("messages");
    final lastTimesBox = Hive.box<String>("lastTimes");
    final lastTime = lastTimesBox.get("messages");

    List<Message> messages = messageBox.values.toList();
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // final lastTime = messages.isEmpty ? null : messages.last.createdAt;

    final groupedUserMessages = getGroupedUserMessages(messages);
    final groupedMatchesMessages = getGroupedMatchMessages(messages);

    for (var entry in groupedUserMessages.entries) {
      final key = entry.key;
      final value = entry.value;
    }
    if (chatlistIds.isEmpty) return;
    messagesSub =
        streamChangeMessages(chatlistIds, lastTime).listen((messageChanges) {
      for (int i = 0; i < messageChanges.length; i++) {
        final messageChange = messageChanges[i];
        final type = messageChange.type;
        final value = messageChange.value;
        lastTimesBox.put("messages", value.modifiedAt);
        if (type == DocumentChangeType.added) {
          messageBox.put(value.id, value);
        } else if (type == DocumentChangeType.modified) {
          messageBox.put(value.id, value);
        } else if (type == DocumentChangeType.removed) {
          messageBox.delete(value.id);
        }
      }
    });
  }

  void updateWatchsCount(int count) {
    badgeCounts[5] = count;
    setState(() {});
  }

  void updateTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          MatchesScreen(),
          WatchsScreen(),
          // MessagesScreen(),
          // StoriesScreen(),
          ProfileScreen(),
          // WalletScreen(),
          // ContactsScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        onTap: updateTab,
        icons: icons,
        badgeCounts: badgeCounts,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     backgroundColor: transparent,
      //     selectedItemColor: primaryColor,
      //     unselectedItemColor: lighterTint,
      //     currentIndex: currentIndex,
      //     onTap: updateTab,
      //     //BoxIcons.bx_football
      //     items: const [
      //       BottomNavigationBarItem(
      //         icon: Icon(MingCute.football_line),
      //         label: "Updates",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(MingCute.tv_2_line),
      //         label: "Watched",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(MingCute.wallet_2_line),
      //         label: "Wallet",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(MingCute.group_line),
      //         label: "Contacts",
      //       ),
      //       BottomNavigationBarItem(
      //         // icon: Icon(MingCute.star_line),
      //         icon: Icon(MingCute.invite_line),
      //         label: "Watchs",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(OctIcons.person),
      //         label: "Profile",
      //       ),
      //     ]),
    );
  }
}

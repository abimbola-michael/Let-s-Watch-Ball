import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/shared/components/logo.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/shared/components/app_tabbar.dart';
import 'package:watchball/features/update/components/date_tabbar.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../shared/components/app_icon_button.dart';

import '../../../utils/utils.dart';
import 'matches_list_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int currentIndex = 0;
  // int playedIndex = 0;
  // int unplayedIndex = 0;

  // final _unplayedScrollController = ScrollController();
  // final _playedScrollController = ScrollController();

  //late PageController _pageController;

  List<String> tabs = ["Live", "Played", "Unplayed"];
  List<String> unplayedTabs = [];
  List<String> playedTabs = [];
  DateTime dateTime = DateTime.now();
  String listType = "Competitions";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _pageController = PageController(initialPage: currentIndex);

    //getDates();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _pageController.dispose();
    // _unplayedScrollController.dispose();
    // _playedScrollController.dispose();

    super.dispose();
  }

  // void updateTab(int index) {
  //   _pageController.jumpToPage(index);
  // }

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

//   void getDates() {
//     final now = DateTime.now();
//     final firstDayOfTheYear = DateTime(now.year, 1, 1);
//     final firstDayOfTheNextYear = DateTime(now.year + 1, 1, 1);
//     final days = firstDayOfTheNextYear.difference(firstDayOfTheYear).inDays;

//     final todayDays = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
//     final remainingDays = days - todayDays;
// // playedTabs = List.generate(todayDays,
// //         (i) => getCalDate(firstDayOfTheYear.add(Duration(days: i - 1))));
//     playedTabs = List.generate(
//         todayDays, (i) => getCalDate(now.subtract(Duration(days: i))));

//     unplayedTabs = List.generate(
//         remainingDays,
//         (i) => getCalDate(
//             firstDayOfTheYear.add(Duration(days: i + todayDays - 1))));
//   }

//   // void scrollDateToCenter() async {
//   //   await Future.delayed(const Duration(milliseconds: 100));
//   //   if (currentIndex == 1) {
//   //     scrollToCenter(_playedScrollController, playedIndex);
//   //   } else if (currentIndex == 2) {
//   //     scrollToCenter(_unplayedScrollController, unplayedIndex);
//   //   }
//   // }

//   void scrollToCenter(ScrollController controller, int index) {
//     double position = (index * 100) - context.widthPercent(50) + 50;
//     double max = controller.position.maxScrollExtent;
//     controller.jumpTo(position < 0
//         ? 0
//         : position > max
//             ? max
//             : position);
//   }

//   void updatePlayedIndex(int index) {
//     setState(() {
//       playedIndex = index;
//     });
//     scrollToCenter(_playedScrollController, playedIndex);
//   }

//   void updateUnPlayedIndex(int index) {
//     setState(() {
//       unplayedIndex = index;
//     });
//     scrollToCenter(_unplayedScrollController, unplayedIndex);
//   }

//   void viewMatch(FootballMatch match) {}

  void updateDateTime(DateTime newDateTime) {
    setState(() {
      dateTime = newDateTime;
    });
  }

  void updateListType(String newListType) {
    setState(() {
      listType = newListType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        leading: Logo(),
        title: "Matches",
        trailing: AppIconButton(icon: EvaIcons.search),
      ),
      body: Column(
        children: [
          // if (currentIndex == 0)
          //   const TabItem(selected: true, tab: "Live")
          // else if (currentIndex == 1)
          //   DateTabBar(
          //     reverse: true,
          //     tabs: playedTabs,
          //     scrollController: _playedScrollController,
          //     selectedTab: playedIndex,
          //     onTabChanged: updatePlayedIndex,
          //   )
          // else if (currentIndex == 2)
          //   DateTabBar(
          //     tabs: unplayedTabs,
          //     scrollController: _unplayedScrollController,
          //     selectedTab: unplayedIndex,
          //     onTabChanged: updateUnPlayedIndex,
          //   ),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                return Container();
                // return MatchesListScreen(
                //   type: tab,
                //   dateTime: dateTime,
                //   onChangeDateTime: updateDateTime,
                //   listType: listType,
                //   onChangeListType: updateListType,
                // );
              }),
            ),
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: PageView.builder(
            //     itemCount: tabs.length,
            //     itemBuilder: (context, index) {
            //       final tab = tabs[index];
            //       return MatchesListScreen(
            //         type: tab,
            //       );
            //     },
            //     controller: _pageController,
            //     onPageChanged: updatePage,
            //   ),
            // ),
          ),
          AppTabBar(
            selectedTab: currentIndex,
            tabs: tabs,
            onTabChanged: updateIndex,
          ),
        ],
      ),
      // body: NestedScrollView(
      //   headerSliverBuilder: (context, innerBoxIsScrolled) {
      //     return [
      //       SliverAppBar(
      //         expandedHeight: 180,
      //         // pinned: true,
      //         // floating: true,
      //         backgroundColor: transparent,
      //         flexibleSpace: AppContainer(
      //           //height: 180,
      //           width: double.infinity,
      //           child: PageView.builder(
      //             itemCount: liveMatches.length,
      //             itemBuilder: (context, index) {
      //               final match = liveMatches[index];
      //               return Padding(
      //                 padding: const EdgeInsets.symmetric(horizontal: 8),
      //                 child: MatchItem(match: match),
      //               );
      //             },
      //             controller: _livePageController,
      //             onPageChanged: updateLiveMatchPage,
      //           ),
      //         ),
      //       )
      //     ];
      //   },
      //   body: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     child: Column(
      //       children: [
      //         DateTabBar(
      //           tabs: tabs,
      //           scrollController: _scrollController,
      //           selectedTab: currentIndex,
      //           onTabChanged: updateIndex,
      //         ),
      //         Expanded(
      //           child: PageView.builder(
      //             itemCount: tabs.length,
      //             itemBuilder: (context, index) {
      //               final tab = tabs[index];
      //               return MatchesListScreen(
      //                 type: tab,
      //               );
      //             },
      //             controller: _pageController,
      //             onPageChanged: updatePage,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      // body: Column(
      //   children: [
      //     AppContainer(
      //       height: 180,
      //       width: double.infinity,
      //       child: PageView.builder(
      //         itemCount: liveMatches.length,
      //         itemBuilder: (context, index) {
      //           final match = liveMatches[index];
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 8),
      //             child: MatchItem(match: match),
      //           );
      //           // return LiveUpdateItem(
      //           //   match: match,
      //           //   onPressed: () => viewMatch(match),
      //           // );
      //         },
      //         controller: _livePageController,
      //         onPageChanged: updateLiveMatchPage,
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 20),
      //         child: Column(
      //           children: [
      //             DateTabBar(
      //               tabs: tabs,
      //               scrollController: _scrollController,
      //               selectedTab: currentIndex,
      //               onTabChanged: updateIndex,
      //             ),
      //             Expanded(
      //               child: PageView.builder(
      //                 itemCount: tabs.length,
      //                 itemBuilder: (context, index) {
      //                   final tab = tabs[index];
      //                   return MatchesListScreen(
      //                     type: tab,
      //                   );
      //                 },
      //                 controller: _pageController,
      //                 onPageChanged: updatePage,
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

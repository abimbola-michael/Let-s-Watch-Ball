import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/components/match/competition_matches_item.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/mockdatas/competitions.dart';

import '../../components/updates/date_tabbar.dart';
import '../../models/competition.dart';
import '../../utils/utils.dart';

class MatchesListScreen extends StatefulWidget {
  final String type;
  final DateTime dateTime;
  final void Function(DateTime dateTime) onChangeDateTime;
  final String listType;
  final void Function(String listType) onChangeListType;
  const MatchesListScreen(
      {super.key,
      required this.type,
      required this.dateTime,
      required this.onChangeDateTime,
      required this.listType,
      required this.onChangeListType});

  @override
  State<MatchesListScreen> createState() => _MatchesListScreenState();
}

class _MatchesListScreenState extends State<MatchesListScreen> {
  List<Competition> competitions = [];
  double initalOffset = 0;
  List<String> tabs = [];
  final _tabScrollController = ScrollController();
  int tabIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    competitions = allLeagues;
    _pageController = PageController(initialPage: 0);

    getDates();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void getDates() {
    final now = DateTime.now();
    final firstDayOfTheYear = DateTime(now.year, 1, 1);
    final firstDayOfTheNextYear = DateTime(now.year + 1, 1, 1);
    final days = firstDayOfTheNextYear.difference(firstDayOfTheYear).inDays;

    final todayDays = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final remainingDays = days - todayDays;
// playedTabs = List.generate(todayDays,
//         (i) => getCalDate(firstDayOfTheYear.add(Duration(days: i - 1))));
    if (widget.type == "Live") {
      tabs = ["Live"];
    } else if (widget.type == "Played") {
      tabs = List.generate(todayDays, (i) {
        final date = now.subtract(
          Duration(days: i),
        );
        if (date.year == widget.dateTime.year &&
            date.month == widget.dateTime.month &&
            date.day == widget.dateTime.day) {
          tabIndex = i;
        }
        return getCalDate(date);
      });
    } else {
      tabs = List.generate(
        remainingDays,
        (i) {
          final date = firstDayOfTheYear.add(
            Duration(days: i + todayDays - 1),
          );
          if (date.year == widget.dateTime.year &&
              date.month == widget.dateTime.month &&
              date.day == widget.dateTime.day) {
            tabIndex = i;
          }
          return getCalDate(date);
        },
      );
    }
  }

  void scrollToCenter() {
    double position = (tabIndex * 100) - context.widthPercent(50, 100) + 50;
    double max = _tabScrollController.position.maxScrollExtent;
    _tabScrollController.jumpTo(position < 0
        ? 0
        : position > max
            ? max
            : position);
  }

  // void updateTabIndex(int index) {
  //   setState(() {
  //     tabIndex = index;
  //   });
  //   scrollToCenter();
  // }

  void updateTab(int index) {
    _pageController.jumpToPage(index);
  }

  void updatePage(int index) {
    setState(() {
      tabIndex = index;
    });
    scrollToCenter();
  }

  void pickDate() async {}
  void showFilters() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: pickDate,
                icon: const Icon(EvaIcons.calendar_outline),
              ),
            ),
            Expanded(
              child: DateTabBar(
                reverse: widget.type == "Played",
                tabs: tabs,
                scrollController: _tabScrollController,
                selectedTab: tabIndex,
                onTabChanged: updateTab,
              ),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: showFilters,
                icon: const Icon(IonIcons.filter),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PageView.builder(
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final tab = tabs[index];
              return ListView.builder(
                itemCount: competitions.length,
                itemBuilder: (context, index) {
                  final competition = competitions[index];
                  return CompetitionMatchesItem(competition: competition);
                },
              );
            },
            controller: _pageController,
            onPageChanged: updatePage,
          ),
        ),
      ],
    );
  }
}

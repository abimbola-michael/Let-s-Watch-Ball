import 'package:flutter/material.dart';
import 'package:watchball/components/profile/profile_stat_item.dart';
import 'package:watchball/components/reuseable/app_appbar.dart';
import 'package:watchball/models/football_match.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../components/match/odds_item.dart';
import '../../components/reuseable/app_container.dart';
import '../../components/reuseable/app_tabbar.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import 'matches_list_screen.dart';

class MatchInfoScreen extends StatefulWidget {
  static const route = "/match-info";
  const MatchInfoScreen({super.key});

  @override
  State<MatchInfoScreen> createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  late FootballMatch match;
  List<String> tabs = ["Info", "Line-Ups", "Feed"];
  final _pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    match = context.args["match"];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  void updateTab(int index) {
    _pageController.jumpToPage(index);
  }

  void updatePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              match.competition,
              style: context.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              match.host,
              style: context.bodySmall?.copyWith(color: lighterTint),
            ),
          ],
        ),
        trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              OctIcons.bell,
              color: white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flag(
                        match.teamOneIcon,
                        size: 24,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        match.teamOneName,
                        style: context.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (match.gameTime > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${match.teamOneScore}",
                              style:
                                  context.headlineSmall?.copyWith(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AppContainer(
                              height: 5,
                              width: 10,
                              borderRadius: BorderRadius.circular(10),
                              color: tint,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${match.teamTwoScore}",
                              style:
                                  context.headlineSmall?.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      Text(
                        match.gameTime == 0
                            ? getTime(match.dateTime)
                            : match.gameTime < 5400
                                ? match.gameTime.toMinsOrSecs
                                : "Full Time",
                        style: context.bodySmall?.copyWith(color: lighterTint),
                      ),
                      // Text(
                      //   getTime(match.dateTime),
                      //   style: context.bodyMedium?.copyWith(),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   getDate(match.dateTime),
                      //   style: context.bodyMedium
                      //       ?.copyWith(fontWeight: FontWeight.w700),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flag(
                        match.teamTwoIcon,
                        size: 24,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        match.teamTwoName,
                        style: context.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (match.gameTime > 0) ...[
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                    child: OddsItem(
                      title: match.teamOneName,
                      odd: match.teamOneOdds,
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: OddsItem(
                      title: "Draw",
                      odd: match.drawOdds,
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: OddsItem(
                      title: match.teamTwoName,
                      odd: match.teamTwoOdds,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
            AppTabBar(
                selectedTab: currentIndex, tabs: tabs, onTabChanged: updateTab),
            // Expanded(
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
            if (match.gameTime > 0) ...[
              const SizedBox(
                height: 8,
              ),
              Wrap(
                children: [
                  ProfileStatItem(title: "Likes", count: 150, onPressed: () {}),
                  const Text(", "),
                  ProfileStatItem(
                      title: "Dislikes", count: 100, onPressed: () {}),
                  const Text(", "),
                  ProfileStatItem(
                      title: "Watchs", count: 100, onPressed: () {}),
                  const Text(", "),
                  ProfileStatItem(
                      title: "Comments", count: 100, onPressed: () {}),
                  const Text(" and "),
                  ProfileStatItem(title: "Stars", count: 100, onPressed: () {}),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      OctIcons.thumbsup,
                      size: 20,
                    ),
                    color: tint,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      OctIcons.thumbsdown,
                      size: 20,
                    ),
                    color: tint,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(OctIcons.play, size: 20),
                    color: tint,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(OctIcons.comment, size: 20),
                    color: tint,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(OctIcons.star, size: 20),
                    color: tint,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

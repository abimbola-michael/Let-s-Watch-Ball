import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/logo.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/features/match/models/league_matches.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/update/screens/updates_list_screen.dart';
import 'package:watchball/features/watch/services/live_stream_service.dart';

import '../../../shared/components/app_icon_button.dart';

import '../../../theme/colors.dart';
import '../../../utils/utils.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  List<String> tabs = ["All", "Live", "To play", "Played"];
  List<LiveMatch> matches = [];
  List<LeagueMatches> leaguesMatches = [];
  List<LeagueMatches> toplayLeagueMatches = [];
  List<LeagueMatches> playedLeagueMatches = [];
  List<LeagueMatches> liveLeagueMatches = [];

  bool loading = true;
  bool watching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLiveMatches();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // void gotoWatchMatchRequest(String watchId) async {
  //   final watch = await getWatch(watchId);
  //   if (watch == null) {
  //     removeUserWatch();
  //     return;
  //   }
  //   final watchers = await getWatchers(watchId);
  //   if (watchers.isEmpty) {
  //     removeUserWatch();
  //     return;
  //   }
  //   watch.watchers = watchers;

  //   final creatorUser = await addWatcherUser(watchers, watch.creatorId);
  //   if (!mounted) return;
  //   context.pushNamedTo(WatchMatchRequestScreen.route, args: {
  //     "watch": watch,
  //     "watchers": watchers,
  //     "creatorUser": creatorUser
  //   });
  // }

  void updateWatchingChange(bool newWatching) {
    watching = newWatching;
  }

  void readLiveMatches() async {
    // matches = allLiveMatches;

    matches = await getMatches();
    matches.sort((a, b) =>
        getDateTime(a.date, a.time).compareTo(getDateTime(b.date, b.time)));
    print("allMatches = $matches");
    Map<String, int> leagueIndices = {};
    Map<String, int> liveLeagueIndices = {};
    Map<String, int> toplayLeagueIndices = {};
    Map<String, int> playedLeagueIndices = {};

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final leagueName = match.league;

      if (leagueIndices[leagueName] == null) {
        leagueIndices[leagueName] = leaguesMatches.length;
        leaguesMatches.add(LeagueMatches(league: leagueName, matches: [match]));
      } else {
        leaguesMatches[leagueIndices[leagueName]!].matches.add(match);
      }
      if (match.status.startsWith("H")) {
        if (liveLeagueIndices[leagueName] == null) {
          liveLeagueIndices[leagueName] = liveLeagueMatches.length;
          liveLeagueMatches
              .add(LeagueMatches(league: leagueName, matches: [match]));
        } else {
          liveLeagueMatches[liveLeagueIndices[leagueName]!].matches.add(match);
        }
      } else if (match.status == "UpComing") {
        if (toplayLeagueIndices[leagueName] == null) {
          toplayLeagueIndices[leagueName] = toplayLeagueMatches.length;
          toplayLeagueMatches
              .add(LeagueMatches(league: leagueName, matches: [match]));
        } else {
          toplayLeagueMatches[toplayLeagueIndices[leagueName]!]
              .matches
              .add(match);
        }
      } else {
        if (playedLeagueIndices[leagueName] == null) {
          playedLeagueIndices[leagueName] = playedLeagueMatches.length;
          playedLeagueMatches
              .add(LeagueMatches(league: leagueName, matches: [match]));
        } else {
          playedLeagueMatches[playedLeagueIndices[leagueName]!]
              .matches
              .add(match);
        }
      }
    }
    if (!mounted) return;
    loading = false;
    setState(() {});
  }

  void searchLeagueOrMatches() {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppAppBar(
          leading: const Logo(),
          title: "Updates",
          trailing: AppIconButton(
            icon: EvaIcons.search,
            onPressed: searchLeagueOrMatches,
          ),
        ),
        body: Column(
          children: [
            TabBar(
              padding: EdgeInsets.zero,
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
                  return UpdatesListScreen(
                    onWatching: updateWatchingChange,
                    loading: loading,
                    leaguesMatches: index == 0
                        ? leaguesMatches
                        : index == 1
                            ? liveLeagueMatches
                            : index == 2
                                ? toplayLeagueMatches
                                : playedLeagueMatches,
                  );
                }),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {},
          child: const Icon(EvaIcons.calendar),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/match/providers/matches_provider.dart';
import 'package:watchball/shared/components/logo.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/features/match/models/league_matches.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/match/screens/matches_list_screen.dart';
import 'package:watchball/features/watch/services/live_stream_service.dart';

import '../../../shared/components/app_icon_button.dart';

import '../../../shared/components/app_search_bar.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import '../enums/enums.dart';
import '../providers/search_matches_provider.dart';
import '../utils/match_utils.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  final void Function(LiveMatch match)? onSelect;
  const MatchesScreen({super.key, this.onSelect});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  List<String> tabs = ["Played", "Live", "To play"];

  // List<String> tabs = ["All", "Live", "To play", "Played"];
  List<LiveMatch> matches = [];
  List<LeagueMatches> leaguesMatches = [];
  List<LeagueMatches> toplayLeagueMatches = [];
  List<LeagueMatches> playedLeagueMatches = [];
  List<LeagueMatches> liveLeagueMatches = [];

  bool loading = true;
  bool isSearch = false;
  final searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLiveMatches();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void readLiveMatches() async {
    // matches = allLiveMatches;

    matches = await getMatches();
    matches.sort((a, b) =>
        getDateTime(a.date, a.time).compareTo(getDateTime(b.date, b.time)));
    ref.read(matchesProvider.notifier).updateMatches(matches);
    print("allMatches = $matches");

    Map<String, int> leagueIndices = {};
    Map<String, int> liveLeagueIndices = {};
    Map<String, int> toplayLeagueIndices = {};
    Map<String, int> playedLeagueIndices = {};

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final leagueName = match.league;
      MatchStatus matchStatus = getMatchStatus(match.status);

      if (leagueIndices[leagueName] == null) {
        leagueIndices[leagueName] = leaguesMatches.length;
        leaguesMatches.add(LeagueMatches(league: leagueName, matches: [match]));
      } else {
        leaguesMatches[leagueIndices[leagueName]!].matches.add(match);
      }
      if (matchStatus == MatchStatus.live) {
        if (liveLeagueIndices[leagueName] == null) {
          liveLeagueIndices[leagueName] = liveLeagueMatches.length;
          liveLeagueMatches
              .add(LeagueMatches(league: leagueName, matches: [match]));
        } else {
          liveLeagueMatches[liveLeagueIndices[leagueName]!].matches.add(match);
        }
      } else if (matchStatus == MatchStatus.toPlay) {
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

  void startSearch() {
    isSearch = true;
    setState(() {});
  }

  void updateSearch(String value) {
    ref
        .read(searchMatchProvider.notifier)
        .updateSearch(value.trim().toLowerCase());
  }

  void stopSearch() {
    ref.read(searchMatchProvider.notifier).updateSearch("");

    searchController.clear();
    isSearch = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSearch,
      onPopInvoked: (pop) {
        if (pop) return;
        if (isSearch) {
          stopSearch();
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        initialIndex: 1,
        child: Scaffold(
          appBar: (isSearch
              ? AppSearchBar(
                  hint: "Search Matches",
                  controller: searchController,
                  onChanged: updateSearch,
                  onCloseSearch: stopSearch,
                )
              : AppAppBar(
                  hideBackButton: widget.onSelect == null,
                  leading: widget.onSelect != null ? null : const Logo(),
                  title: widget.onSelect != null ? "Select Match" : "Matches",
                  trailing: AppIconButton(
                    icon: EvaIcons.search,
                    onPressed: startSearch,
                  ),
                )) as PreferredSizeWidget?,
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
                    return Tab(text: tab);
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: List.generate(tabs.length, (index) {
                    return MatchesListScreen(
                      onSelect: widget.onSelect,
                      loading: loading,
                      leaguesMatches: index == 0
                          ? playedLeagueMatches
                          : index == 1
                              ? liveLeagueMatches
                              : toplayLeagueMatches,
                    );
                  }),
                ),
              )
            ],
          ),
          // floatingActionButton: FloatingActionButton.small(
          //   onPressed: () {},
          //   child: const Icon(EvaIcons.calendar),
          // ),
        ),
      ),
    );
  }
}

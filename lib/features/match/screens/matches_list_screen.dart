import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/match/components/live_match_item.dart';
import 'package:watchball/features/match/models/league_matches.dart';
import 'package:watchball/shared/views/empty_list_view.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../theme/colors.dart';
import '../models/live_match.dart';
import '../providers/search_matches_provider.dart';

class MatchesListScreen extends ConsumerWidget {
  final bool loading;
  final List<LeagueMatches> leaguesMatches;
  final void Function(LiveMatch match)? onSelect;
  final Future<void> Function() onRefresh;
  const MatchesListScreen(
      {super.key,
      required this.leaguesMatches,
      required this.onRefresh,
      this.loading = false,
      this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(searchMatchProvider);
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    // if (leaguesMatches.isEmpty) {
    //   return const EmptyListView(message: "No match");
    // }
    return CustomMaterialIndicator(
      onRefresh: onRefresh,
      backgroundColor: Colors.white,
      indicatorBuilder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: CircularProgressIndicator(
            color: primaryColor,
            value:
                controller.state.isLoading ? null : min(controller.value, 1.0),
          ),
        );
      },
      child: leaguesMatches.isEmpty
          ? SingleChildScrollView(
              child: SizedBox(
                height: context.height,
                width: double.infinity,
                child: const EmptyListView(message: "No match"),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: leaguesMatches.length,
              itemBuilder: (context, index) {
                final league = leaguesMatches[index];
                final matches = league.matches
                    .where((match) =>
                        match.homeName.toLowerCase().contains(searchText) ||
                        match.awayName.toLowerCase().contains(searchText) ||
                        match.league.toLowerCase().contains(searchText))
                    .toList();
                if (matches.isEmpty) return Container();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        league.league,
                        style: context.headlineSmall?.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          final match = matches[index];
                          return LiveMatchItem(
                              match: match,
                              onPressed: onSelect == null
                                  ? null
                                  : () {
                                      onSelect!(match);
                                      context.pop();
                                    });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

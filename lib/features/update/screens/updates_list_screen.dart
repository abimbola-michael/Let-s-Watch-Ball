import 'package:flutter/material.dart';
import 'package:watchball/features/match/components/live_match_item.dart';
import 'package:watchball/features/match/models/league_matches.dart';
import 'package:watchball/shared/views/empty_list_view.dart';
import 'package:watchball/utils/extensions.dart';

import '../../match/models/live_match.dart';

class UpdatesListScreen extends StatelessWidget {
  final bool loading;
  final List<LeagueMatches> leaguesMatches;
  final void Function(bool watching) onWatching;
  const UpdatesListScreen(
      {super.key,
      required this.leaguesMatches,
      required this.loading,
      required this.onWatching});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (leaguesMatches.isEmpty) {
      return const EmptyListView(message: "No match");
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: leaguesMatches.length,
      itemBuilder: (context, index) {
        final league = leaguesMatches[index];
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
                itemCount: league.matches.length,
                itemBuilder: (context, index) {
                  final match = league.matches[index];
                  return LiveMatchItem(
                    match: match,
                    onWatching: onWatching,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

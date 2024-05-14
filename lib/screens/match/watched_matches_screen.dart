import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/components/reuseable/app_appbar.dart';

import '../../components/match/watched_match_item.dart';
import '../../models/watched_match.dart';

class WatchedMatchesScreen extends StatefulWidget {
  const WatchedMatchesScreen({super.key});

  @override
  State<WatchedMatchesScreen> createState() => _WatchedMatchesScreenState();
}

class _WatchedMatchesScreenState extends State<WatchedMatchesScreen> {
  List<WatchedMatch> matches = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: "Watched",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return WatchedMatchItem(match: match);
              },
            ),
          )
        ],
      ),
    );
  }
}

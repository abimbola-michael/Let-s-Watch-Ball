import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/logo.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_search_bar.dart';

import '../../../shared/components/app_icon_button.dart';
import '../../../shared/views/empty_list_view.dart';
import '../../match/components/watched_match_item.dart';
import '../models/watched.dart';

class WatchedMatchesScreen extends StatefulWidget {
  const WatchedMatchesScreen({super.key});

  @override
  State<WatchedMatchesScreen> createState() => _WatchedMatchesScreenState();
}

class _WatchedMatchesScreenState extends State<WatchedMatchesScreen> {
  List<Watched> watcheds = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    // matches = allWatchedMatches;
    super.initState();
  }

  void searchMatches(String value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Watched",
        leading: const Logo(),
        trailing: AppIconButton(
          icon: EvaIcons.search,
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            AppSearchBar(
              hint: "Search matches...",
              onChanged: searchMatches,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : watcheds.isEmpty
                      ? const EmptyListView(message: "No match")
                      : ListView.builder(
                          itemCount: watcheds.length,
                          itemBuilder: (context, index) {
                            final watched = watcheds[index];
                            return WatchedMatchItem(watched: watched);
                          },
                        ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(EvaIcons.play_circle_outline),
      ),
    );
  }
}

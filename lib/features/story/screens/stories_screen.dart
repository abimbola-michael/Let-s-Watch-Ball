import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/logo.dart';
import '../models/story.dart';
import '../../../theme/colors.dart';
import 'stories_list_screen.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  List<Story> peopleStories = [];
  List<Story> matchStories = [];

  List<String> tabs = [
    "People",
    "Match",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppAppBar(
          leading: const Logo(),
          title: "Stories",
          trailing: AppIconButton(
            icon: EvaIcons.search,
            onPressed: () {},
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TabBar(
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
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: TabBarView(
                  children: List.generate(tabs.length, (index) {
                    return StoriesListScreen(isMatch: index == 1);
                  }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {},
          child: const Icon(EvaIcons.plus_circle_outline),
        ),
      ),
    );
  }
}

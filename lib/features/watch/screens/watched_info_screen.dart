import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/utils/extensions.dart';

import '../models/watched_match.dart';

class WatchedInfoScreen extends StatefulWidget {
  static const route = "/watched-info";
  const WatchedInfoScreen({super.key});

  @override
  State<WatchedInfoScreen> createState() => _WatchedInfoScreenState();
}

class _WatchedInfoScreenState extends State<WatchedInfoScreen> {
  late WatchedMatch match;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    match = context.args["match"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "",
      ),
      body: Column(
        children: [],
      ),
    );
  }
}

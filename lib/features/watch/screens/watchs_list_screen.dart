import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/features/watch/screens/watch_request_screen.dart';
import 'package:watchball/utils/extensions.dart';

import 'watch_match_screen.dart';
import '../components/watch_item.dart';

class WatchsListScreen extends StatefulWidget {
  final List<Watch> watchs;
  final bool isAwaiting;
  const WatchsListScreen(
      {super.key, required this.watchs, required this.isAwaiting});

  @override
  State<WatchsListScreen> createState() => _WatchsListScreenState();
}

class _WatchsListScreenState extends State<WatchsListScreen> {
  void viewRequest(BuildContext context, Watch watch) async {
    final result = await context
        .pushNamedTo(WatchRequestScreen.route, args: {"watch": watch});
    // if (result != null) {
    //   if (!context.mounted) return;
    //   context.pushNamedTo(StreamMatchScreen.route,
    //       args: {"match": (result as Watch?)?.match});
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.watchs.length,
      itemBuilder: (context, index) {
        final watch = widget.watchs[index];
        return WatchItem(
          watch: watch,
          onPressed: () => viewRequest(context, watch),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/features/watch/components/watch_record_item.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/app_appbar.dart';
import '../../../utils/utils.dart';
import '../components/watch_item.dart';
import '../components/watch_user_item.dart';
import '../models/watch.dart';
import 'stream_match_screen.dart';

class WatchInfoScreen extends StatefulWidget {
  static const route = "/watch-info";
  const WatchInfoScreen({super.key});

  @override
  State<WatchInfoScreen> createState() => _WatchInfoScreenState();
}

class _WatchInfoScreenState extends State<WatchInfoScreen> {
  late Watch watch;
  bool firstTime = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      watch = context.args["watch"];
      firstTime = false;
    }
  }

  void gotoStreamMatch() {
    context.pushNamedAndPop(StreamMatchScreen.route, args: {"watch": watch});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: "Watch Info",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  WatchItem(watch: watch),
                  const SizedBox(height: 10),
                  Text(
                    "Watchers",
                    style: context.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: watch.users.length,
                    itemBuilder: (context, index) {
                      return WatcherUserItem(watch: watch, index: index);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Records",
                    style: context.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: watch.records.length,
                    itemBuilder: (context, index) {
                      return WatchRecordItem(watch: watch, index: index);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              title: "Rewatch",
              onPressed: gotoStreamMatch,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

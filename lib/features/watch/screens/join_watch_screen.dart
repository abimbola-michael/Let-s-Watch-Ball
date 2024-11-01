import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_alert_dialog.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_search_bar.dart';
import 'package:watchball/shared/components/app_text_field.dart';
import 'package:watchball/features/watch/components/watch_item.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/app_container.dart';
import '../../user/components/user_hor_item.dart';
import '../../user/models/user.dart';
import '../../user/mocks/users.dart';
import '../mocks/watchs.dart';

class JoinWatchScreen extends StatefulWidget {
  static const route = "/join-watch";

  const JoinWatchScreen({super.key});

  @override
  State<JoinWatchScreen> createState() => _JoinWatchScreenState();
}

class _JoinWatchScreenState extends State<JoinWatchScreen> {
//  final _controller = TextEditingController();

  List<Watch> watchs = [];
  Watch? selectedWatch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    watchs = allWatchs;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller.dispose();
    super.dispose();
  }

  void toggleSelect(Watch watch) {
    if (selectedWatch != null && selectedWatch == watch) {
      selectedWatch = null;
    } else {
      selectedWatch = watch;
    }

    setState(() {});
  }

  void joinWatch() {
    context.pop({"watch": selectedWatch});
  }

  void joinWithLink() async {
    TextEditingController? controller = TextEditingController();
    void pasteLink() {
      //controller.text =
    }
    final result = await context.showAlertDialog((context) {
      return AppAlertDialog(
        title: "Join With link",
        actions: const ["Cancel", "Join"],
        onPresseds: [
          () {
            context.pop();
          },
          () {
            context.pop(controller.text);
          }
        ],
        child: AppContainer(
          width: double.infinity,
          borderRadius: BorderRadius.circular(30),
          padding: const EdgeInsets.only(left: 10),
          margin: const EdgeInsets.only(bottom: 10),
          color: lightestTint,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: context.bodyMedium?.copyWith(color: tint),
                  decoration: InputDecoration(
                    hintText: "Enter or Paste link",
                    hintStyle: context.bodyMedium?.copyWith(color: lighterTint),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                onPressed: pasteLink,
                icon: const Icon(
                  OctIcons.paste,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    });
    controller.dispose();
    if (result != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Join Watch",
              style: context.headlineSmall?.copyWith(fontSize: 18),
            ),
            Text(
              "Select Watch",
              style: context.bodySmall?.copyWith(),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: joinWithLink,
          icon: const Icon(
            EvaIcons.link_outline,
            color: white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Watchers",
              style: context.bodyMedium,
            ),
            AppContainer(
              height: 100,
              child: selectedWatch == null
                  ? Text(
                      "Tap to select watch",
                      style: context.bodyMedium,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //shrinkWrap: true,
                      itemCount: selectedWatch!.watchers.length,
                      itemBuilder: (context, index) {
                        final user = selectedWatch!.watchers[index].user;
                        if (user == null) {
                          return Container();
                        }
                        return UserHorItem(user: user);
                      },
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: watchs.length,
                itemBuilder: (context, index) {
                  final watch = watchs[index];
                  return WatchItem(
                    selected: selectedWatch == watch,
                    watch: watch,
                    onPressed: () => toggleSelect(watch),
                  );
                },
              ),
            ),
            if (selectedWatch != null)
              AppButton(
                title: "Join",
                onPressed: joinWatch,
                margin: const EdgeInsets.symmetric(vertical: 20),
              )
            // Row(
            //   children: [
            //     Expanded(
            //       child: AppSearchBar(
            //         hint: "Enter Watch code",
            //         controller: _controller,
            //       ),
            //       // child: AppTextField(
            //       //   titleText: "Enter Watch Code",
            //       //   hintText: "Enter Code",
            //       //   controller: _controller,
            //       // ),
            //     ),
            //     IconButton(
            //       onPressed: pasteCode,
            //       icon: const Icon(OctIcons.paste),
            //     )
            //   ],
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // AppButton(
            //   title: "Join",
            //   onPressed: joinWatch,
            // )
          ],
        ),
      ),
    );
  }
}

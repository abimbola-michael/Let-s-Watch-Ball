import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/user/components/user_hor_item.dart';
import 'package:watchball/features/user/components/user_select_item.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/features/user/mocks/users.dart';

import '../../../shared/components/app_alert_dialog.dart';
import '../../../shared/components/app_button.dart';
import '../../user/models/user.dart';
import '../models/watcher.dart';
import '../../../firebase/firestore_methods.dart';
import '../../user/services/user_service.dart';
import '../../../theme/colors.dart';

class InviteWatchersScreen extends StatefulWidget {
  static const route = "/invite-watchers";
  const InviteWatchersScreen({super.key});

  @override
  State<InviteWatchersScreen> createState() => _InviteWatchersScreenState();
}

class _InviteWatchersScreenState extends State<InviteWatchersScreen> {
  List<User> users = [];
  List<User> selectedUsers = [];
  List<User> invitedUsers = [];
  bool hasAddedInitial = false;
  String watchLink = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //users = allContacts;
    readUsers();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    List<Watcher> watchers = context.args["users"] ?? [];
    invitedUsers = watchers.map((watcher) => watcher.user!).toList();
    watchLink = context.args["link"] ?? "";
    if (!hasAddedInitial) {
      selectedUsers.addAll(invitedUsers);
      hasAddedInitial = true;
    }
  }

  void readUsers() async {
    users = await readAllUsers();
    setState(() {});
  }

  void toggleSelect(User user) {
    final userIndex =
        selectedUsers.indexWhere((element) => element.id == user.id);
    if (userIndex != -1) {
      selectedUsers.removeAt(userIndex);
    } else {
      selectedUsers.add(user);
    }
    setState(() {});
  }

  void createWatch() {
    context.pop({"contacts": selectedUsers});
  }

  void inviteWithLink() async {
    void copyLink() {
      //controller.text =
    }
    final result = await context.showAlertDialog((context) {
      return AppAlertDialog(
        title: "Invite With link",
        actions: const ["Cancel", "Share"],
        onPresseds: [
          () {
            context.pop();
          },
          () {
            context.pop(true);
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
                child: Text(
                  watchLink,
                  style: context.bodyMedium?.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: copyLink,
                icon: const Icon(
                  OctIcons.copy,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    });
    if (result != null) {
      shareLink();
    }
  }

  void shareLink() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Invite Watchers",
              style: context.headlineSmall?.copyWith(fontSize: 18),
            ),
            Text(
              "Select Watchers",
              style: context.bodySmall?.copyWith(),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: inviteWithLink,
          icon: const Icon(EvaIcons.link_outline, color: white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${selectedUsers.length} Selected Watchers",
              style: context.bodyMedium,
            ),
            AppContainer(
              height: 100,
              child: selectedUsers.isEmpty
                  ? Text(
                      "Tap contact to select",
                      style: context.bodyMedium,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: selectedUsers.length,
                      itemBuilder: (context, index) {
                        final user = selectedUsers[index];
                        return UserHorItem(
                          user: user,
                          onClose: () => toggleSelect(user),
                        );
                      },
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final bool selected = selectedUsers
                          .indexWhere((element) => element.id == user.id) !=
                      -1;
                  return UserSelectItem(
                    user: user,
                    selected: selected,
                    onPressed: () => toggleSelect(user),
                  );
                },
              ),
            ),
            if (selectedUsers.isNotEmpty)
              AppButton(
                title: "Invite",
                onPressed: createWatch,
                margin: const EdgeInsets.symmetric(vertical: 20),
              )
          ],
        ),
      ),
    );
  }
}

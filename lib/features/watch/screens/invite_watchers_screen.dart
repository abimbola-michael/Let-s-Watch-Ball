import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/main.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/user/components/user_hor_item.dart';
import 'package:watchball/features/user/components/user_select_item.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/shared/components/app_search_bar.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/features/user/mocks/users.dart';
import 'package:watchball/utils/utils.dart';

import '../../../shared/components/app_alert_dialog.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../utils/country_code_utils.dart';
import '../../contact/models/phone_contact.dart';
import '../../contact/providers/contacts_provider.dart';
import '../../match/models/live_match.dart';
import '../../match/utils/match_utils.dart';
import '../../match/utils/match_utils.dart';
import '../../user/models/user.dart';
import '../../user/providers/users_provider.dart';
import '../models/watcher.dart';
import '../../../firebase/firestore_methods.dart';
import '../../user/services/user_service.dart';
import '../../../theme/colors.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'findorinvite_watchers_screen.dart';

class InviteWatchersScreen extends ConsumerStatefulWidget {
  static const route = "/invite-watchers";
  const InviteWatchersScreen({super.key});

  @override
  ConsumerState<InviteWatchersScreen> createState() =>
      _InviteWatchersScreenState();
}

class _InviteWatchersScreenState extends ConsumerState<InviteWatchersScreen> {
  bool isSearch = false;
  List<User> users = [];
  //List<User> unregisteredUsers = [];

  List<User> selectedUsers = [];
  List<User> invitedUsers = [];
  bool firstTime = true;
  bool loading = false;
  //String watchLink = "";
  Watch? watch;
  final searchController = TextEditingController();
  final findUserController = TextEditingController();

  List<String> availablePlatforms = [];

  @override
  void initState() {
    super.initState();
    readUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (firstTime) {
      watch = context.args["watch"];
      if (watch != null) {
        invitedUsers = watch!.watchers.map((watcher) => watcher.user!).toList();
        selectedUsers.addAll(invitedUsers);
      }

      firstTime = false;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    findUserController.dispose();
    super.dispose();
  }

  String getWatchInviteMessage([String? name]) {
    if (watch == null) return "";
    final match = getMatchInfo(watch!.match);
    final watchLink = getWatchLink(watch!);
    return "Hi${name == null ? "" : " $name"}, Lets watch ${match.homeName} vs ${match.awayName} match together on Watch Ball! Join me by clicking the link below.\n$watchLink\nSee you there!";
  }

  String getContactInviteMessage([String? name]) {
    String playStoreLink = "https://watchball.com";
    return "Hi${name == null ? "" : " $name"}, Let's watch ball together on Watch Ball! It's a cool, simple and amazing app we can use to watch football match. Get it at $playStoreLink";
  }

  String getMessage([String? name]) {
    return watch != null
        ? getWatchInviteMessage(name)
        : getContactInviteMessage(name);
  }

  void shareInvite() async {
    await Share.share(
        subject: "Let's Watch Ball",
        watch != null ? getWatchInviteMessage() : getContactInviteMessage());
  }

  Uri getWhatsAppUri(String phoneNumber, [String? name]) {
    final encodedMessage = Uri.encodeComponent(getMessage(name));
    return Uri.parse("whatsapp://send?phone=$phoneNumber&text=$encodedMessage");
  }

  Uri getSMSUri(String phoneNumber, [String? name]) {
    final encodedMessage = Uri.encodeComponent(getMessage(name));
    return Uri.parse("sms:$phoneNumber?body=$encodedMessage");
  }

  void shareContactInvite(
      String platform, String phoneNumber, String name) async {
    if (platform == "WhatsApp") {
      launchUrl(getWhatsAppUri(phoneNumber, name));
    } else if (platform == "SMS") {
      launchUrl(getSMSUri(phoneNumber, name));
    }
    //  else if (platform == "Telegram") {
    //   launchUrl(getTelegramUri(phoneNumber, name));
    // }
  }

  void readUsers() async {
    loading = true;
    setState(() {});
    final watchersBox = Hive.box<String>("watchers");
    final watchers =
        watchersBox.values.map((e) => Watcher.fromJson(e)).toList();

    watchers.sort((a, b) => b.time.compareTo(a.time));
    insertWatchers(watchers);
    final newWatchers =
        await readMyWatchers(watchers.isNotEmpty ? watchers.first.time : null);
    for (var watcher in newWatchers) {
      watchersBox.put(watcher.id, watcher.toJson());
      //watchers.insert(0, watcher);
    }
    insertWatchers(newWatchers);

    availablePlatforms.clear();

    if (users.isNotEmpty) {
      final number = users.first.phone;
      if (await canLaunchUrl(getWhatsAppUri(number))) {
        availablePlatforms.add("WhatsApp");
      }

      if (await canLaunchUrl(getSMSUri(number))) {
        availablePlatforms.add("SMS");
      }
    }
    loading = false;
    setState(() {});
  }

  void insertWatchers(List<Watcher> watchers) async {
    if (watchers.isEmpty) return;
    final usersBox = Hive.box<String>("users");

    for (int i = 0; i < watchers.length; i++) {
      final watcher = watchers[i];
      final userJson = usersBox.get(watcher.id);
      User? user;
      if (userJson != null) {
        user = User.fromJson(userJson);
      } else {
        user = await getUser(watcher.id, useCache: false);
      }
      if (user != null) {
        usersBox.put(user.id, user.toJson());
        users.insert(0, user);
      }
    }
    setState(() {});
  }

  void toggleSelect(User user) {
    if (invitedUsers.indexWhere((element) => element.id == user.id) != -1) {
      return;
    }
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

  void copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link));
  }

  void pasteLink() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      String code = data.text!;
    }
  }

  void startSearch() {
    isSearch = true;
    setState(() {});
  }

  void updateSearch(String value) {
    setState(() {});
    // ref
    //     .read(searchMatchProvider.notifier)
    //     .updateSearch(value.trim().toLowerCase());
  }

  void stopSearch() {
    searchController.clear();
    isSearch = false;
    setState(() {});
  }

  void gotoFindWatcheFromContacts() async {
    final result = await context
        .pushNamedTo(FindOrInviteWatchersScreen.route, args: {"watch": watch});
    if (result != null) {
      final watchers = result as List<Watcher>;
      if (watchers.isNotEmpty) {
        insertWatchers(watchers);
      }
    }
  }

  void findUser() async {
    final value = findUserController.text.trim();
    if (value.isEmpty) return;
    String type = "";
    if (isValidEmail(value)) {
      type = "email";
    } else if (isValidPhoneNumber(value)) {
      type = "phone";
    } else if (isValidUsername(value)) {
      type = "username";
    } else {
      return;
    }
    final searchedUsers = await searchUser(type, value);
    if (!mounted) return;

    if (searchedUsers.isNotEmpty) {
      for (int i = 0; i < searchedUsers.length; i++) {
        final user = searchedUsers[i];
        if (user.id == myId) {
          context.showSnackBar("You are already a watcher in the match");
          continue;
        }
        final index = users.indexWhere((element) => element.id == user.id);
        if (index != -1) {
          users.removeAt(index);
        }
        users.insert(0, user);
      }
      findUserController.clear();
      setState(() {});
    } else {
      context.showSnackBar("No user found. Check that the $type is correct");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSearch,
      onPopInvoked: (pop) {
        if (pop) return;
        if (isSearch) {
          stopSearch();
        }
      },
      child: Scaffold(
        appBar: (isSearch
            ? AppSearchBar(
                hint: "Search Contacts",
                controller: searchController,
                onChanged: updateSearch,
                onCloseSearch: stopSearch,
              )
            : AppAppBar(
                title: "Invite ${watch != null ? "Watchers" : "Contacts"}",
                subtitle: selectedUsers.isEmpty
                    ? "Select ${watch != null ? "Watchers" : "Contacts"}"
                    : "${selectedUsers.length} Selected ${watch != null ? "Watchers" : "Contacts"}",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: startSearch,
                      icon: const Icon(EvaIcons.search, color: white),
                    ),
                    IconButton(
                      onPressed: shareInvite,
                      icon: const Icon(EvaIcons.share_outline, color: white),
                    ),
                  ],
                ),
              )) as PreferredSizeWidget?,
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (watch != null)
                      AppContainer(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 10),
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
                                    closable: invitedUsers.indexWhere(
                                            (element) =>
                                                element.id == user.id) ==
                                        -1,
                                    onClose: () => toggleSelect(user),
                                  );
                                },
                              ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: findUserController,
                            hintText: "Enter Username, Email or Phone number",
                            prefix: IconButton(
                                onPressed: gotoFindWatcheFromContacts,
                                icon: const Icon(LineAwesome.address_book)),
                          ),
                        ),
                        AppButton(
                          title: "Add",
                          wrapped: true,
                          onPressed: findUser,
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final bool selected = selectedUsers.indexWhere(
                                  (element) => element.id == user.id) !=
                              -1;
                          final contactsBox = Hive.box<String>("contacts");

                          final contactJson = contactsBox.get(user.phone);
                          final contact = contactJson != null
                              ? PhoneContact.fromJson(contactJson)
                              : null;
                          return UserSelectItem(
                            availablePlatforms: availablePlatforms,
                            user: user,
                            selected: selected,
                            onPressed: () {
                              toggleSelect(user);
                            },
                            onShare: (platform) => shareContactInvite(
                                platform, user.phone, user.username),
                            contactStatus: contact?.contactStatus,
                          );
                        },
                      ),
                    ),
                    // Expanded(
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: users.length + unregisteredUsers.length,
                    //     itemBuilder: (context, index) {
                    //       final user = index < users.length
                    //           ? users[index]
                    //           : unregisteredUsers[index - users.length];
                    //       final bool selected = selectedUsers.indexWhere(
                    //               (element) => element.id == user.id) !=
                    //           -1;
                    //       return Column(
                    //         mainAxisSize: MainAxisSize.min,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           if (index == 0 || index == users.length)
                    //             Padding(
                    //               padding:
                    //                   const EdgeInsets.symmetric(vertical: 8.0),
                    //               child: Text(
                    //                 index == users.length
                    //                     ? "Invite Contacts"
                    //                     : "Contacts on Let's Watch Ball",
                    //                 style: context.bodySmall
                    //                     ?.copyWith(color: lighterTint),
                    //                 maxLines: 1,
                    //                 overflow: TextOverflow.ellipsis,
                    //               ),
                    //             ),
                    //           UserSelectItem(
                    //             availablePlatforms: availablePlatforms,
                    //             user: user,
                    //             selected: selected,
                    //             onPressed: () {
                    //               toggleSelect(user);
                    //             },
                    //             onShare: (platform) => shareContactInvite(
                    //                 platform, user.phone, user.username),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   ),
                    // ),
                    if (selectedUsers.isNotEmpty)
                      AppButton(
                        title: "Invite",
                        onPressed: createWatch,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                      )
                  ],
                ),
              ),
      ),
    );
  }
}

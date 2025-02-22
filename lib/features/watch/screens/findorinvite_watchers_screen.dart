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
import 'package:watchball/main.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/user/components/user_hor_item.dart';
import 'package:watchball/features/user/components/user_select_item.dart';
import 'package:watchball/shared/components/app_search_bar.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../../shared/components/app_button.dart';
import '../../../utils/country_code_utils.dart';
import '../../contact/models/phone_contact.dart';

import '../../contact/providers/contacts_provider.dart';
import '../../match/utils/match_utils.dart';
import '../../user/enums/enums.dart';
import '../../user/models/user.dart';
import '../models/watch.dart';
import '../models/watcher.dart';
import '../../user/services/user_service.dart';
import '../../../theme/colors.dart';
import '../providers/search_contacts_provider.dart';
import '../utils/utils.dart';
import '../views/contacts_list_view.dart';

class FindOrInviteWatchersScreen extends ConsumerStatefulWidget {
  static const route = "/findorinvite-watchers";
  const FindOrInviteWatchersScreen({super.key});

  @override
  ConsumerState<FindOrInviteWatchersScreen> createState() =>
      _FindOrInviteWatchersScreenState();
}

class _FindOrInviteWatchersScreenState
    extends ConsumerState<FindOrInviteWatchersScreen> {
  bool isSearch = false;
  // List<User> users = [];
  // List<User> unregisteredUsers = [];

  // List<User> selectedUsers = [];
  // List<User> invitedUsers = [];
  List<Watcher> newlyAddedWatchers = [];

  bool firstTime = true;
  bool loading = false;
  //String watchLink = "";
  Watch? watch;
  bool isInvite = false;
  final searchController = TextEditingController();
  List<String> availablePlatforms = [];

  @override
  void initState() {
    super.initState();
    readContacts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (firstTime) {
      isInvite = context.args["isInvite"] ?? false;
      // if (watch != null) {
      //   invitedUsers = watch!.watchers.map((watcher) => watcher.user!).toList();
      //   selectedUsers.addAll(invitedUsers);
      // }

      firstTime = false;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
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
    return getContactInviteMessage(name);
    // return watch != null
    //     ? getWatchInviteMessage(name)
    //     : getContactInviteMessage(name);
  }

  void shareInvite() async {
    await Share.share(subject: "Let's Watch Ball", getMessage());
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
  }

  void readContacts() async {
    if (!isAndroidAndIos) return;
    loading = true;
    setState(() {});

    String? dialCode = await getCurrentCountryDialingCode();
    //final usersBox = Hive.box<String>("users");
    final phoneContactsBox = Hive.box<String>("contacts");
    //phoneContactsBox.clear();

    List<PhoneContact> phoneContacts =
        phoneContactsBox.values.map((e) => PhoneContact.fromJson(e)).toList();
    getAvailablePlatforms(phoneContacts);

    phoneContacts
        .sort((a, b) => (a.name ?? a.phone).compareTo((b.name ?? b.phone)));

    ref.read(contactsProvider.notifier).setPhoneContacts(phoneContacts);

    // Request contact permission
    if (!(await FlutterContacts.requestPermission())) return;

    List<Contact> contacts =
        await FlutterContacts.getContacts(withProperties: true);

    for (int i = 0; i < contacts.length; i++) {
      final contact = contacts[i];
      for (var phone in contact.phones) {
        final phoneNumber = phone.number.toValidNumber(dialCode);
        if (phoneNumber == null || contact.displayName.isEmpty) continue;
        final prevContactJson = phoneContactsBox.get(phoneNumber);
        final time = timeNow;
        //ContactStatus contactStatus = ContactStatus.unadded;

        if (prevContactJson != null) {
          final prevContact = PhoneContact.fromJson(prevContactJson);

          if (contact.displayName != prevContact.name) {
            prevContact.name = contact.displayName;
            prevContact.modifiedAt = time;
            // modified = true;
            await phoneContactsBox.put(phoneNumber, prevContact.toJson());
          }
        } else {
          final phoneContact = PhoneContact(
              phone: phoneNumber,
              name: contact.displayName,
              createdAt: time,
              modifiedAt: time,
              contactStatus: ContactStatus.unadded);
          await phoneContactsBox.put(phoneNumber, phoneContact.toJson());
        }
      }
    }
    phoneContacts =
        phoneContactsBox.values.map((e) => PhoneContact.fromJson(e)).toList();
    phoneContacts
        .sort((a, b) => (a.name ?? a.phone).compareTo((b.name ?? b.phone)));

    ref.read(contactsProvider.notifier).setPhoneContacts(phoneContacts);
    getAvailablePlatforms(phoneContacts);

    loading = false;
    setState(() {});
  }

  void getAvailablePlatforms(List<PhoneContact> phoneContacts) async {
    if (phoneContacts.isNotEmpty && availablePlatforms.isEmpty) {
      final number = phoneContacts.first.phone;
      if (await canLaunchUrl(getWhatsAppUri(number))) {
        availablePlatforms.add("WhatsApp");
      }

      if (await canLaunchUrl(getSMSUri(number))) {
        availablePlatforms.add("SMS");
      }
    }
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
    ref
        .read(searchContactsProvider.notifier)
        .updateSearch(value.trim().toLowerCase());
  }

  void stopSearch() {
    searchController.clear();
    isSearch = false;
    setState(() {});
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
        if (!isInvite) {
          context.pop(newlyAddedWatchers);
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
                title: isInvite ? "Invite Contacts" : "Find Watchers",
                subtitle: isInvite ? null : "Select Contacts",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (loading)
                      const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator()),
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
        body:
            // loading
            //     ? const Center(child: CircularProgressIndicator())
            //     :
            isInvite
                ? ContactsListView(
                    isInvite: true, availablePlatforms: availablePlatforms)
                : DefaultTabController(
                    length: ContactStatus.values.length,
                    child: Column(
                      children: [
                        TabBar(
                          padding: EdgeInsets.zero,
                          isScrollable: true,
                          tabAlignment: TabAlignment.center,
                          dividerColor: transparent,
                          tabs: List.generate(
                            ContactStatus.values.length,
                            (index) {
                              final tab =
                                  ContactStatus.values[index].name.capitalize;
                              return Tab(text: tab);
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: List.generate(ContactStatus.values.length,
                                (index) {
                              return ContactsListView(
                                  contactStatusIndex: index,
                                  availablePlatforms: availablePlatforms,
                                  newlyAddedWatchers: newlyAddedWatchers);
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}

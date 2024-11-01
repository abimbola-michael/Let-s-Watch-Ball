// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchball/features/contact/providers/contacts_provider.dart';

import 'package:watchball/features/user/enums/enums.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/features/watch/models/watcher.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/utils/country_code_utils.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../contact/components/contact_item.dart';
import '../../contact/models/phone_contact.dart';
import '../../user/components/user_select_item.dart';
import '../../user/models/user.dart';
import '../providers/search_contacts_provider.dart';

class ContactsListView extends ConsumerWidget {
  final bool isInvite;
  final int? contactStatusIndex;
  final List<String> availablePlatforms;
  final List<Watcher>? newlyAddedWatchers;
  const ContactsListView(
      {super.key,
      this.contactStatusIndex,
      required this.availablePlatforms,
      this.isInvite = false,
      this.newlyAddedWatchers});

  Uri getWhatsAppUri(String phoneNumber, [String? name]) {
    final encodedMessage = Uri.encodeComponent(getContactInviteMessage(name));
    return Uri.parse("whatsapp://send?phone=$phoneNumber&text=$encodedMessage");
  }

  Uri getSMSUri(String phoneNumber, [String? name]) {
    final encodedMessage = Uri.encodeComponent(getContactInviteMessage(name));
    return Uri.parse("sms:$phoneNumber?body=$encodedMessage");
  }

  String getContactInviteMessage([String? name]) {
    String playStoreLink = "https://watchball.com";
    return "Hi${name == null ? "" : " $name"}, Let's watch ball together on Watch Ball! It's a cool, simple and amazing app we can use to watch football match. Get it at $playStoreLink";
  }

  void shareContactInvite(String platform, PhoneContact contact) {
    final phoneNumber = contact.phone;
    final name = contact.name;
    if (platform == "WhatsApp") {
      launchUrl(getWhatsAppUri(phoneNumber, name));
    } else if (platform == "SMS") {
      launchUrl(getSMSUri(phoneNumber, name));
    }
  }

  void addContact(PhoneContact contact, WidgetRef ref) async {
    final dialCode = await getCurrentCountryDialingCode();
    final number = contact.phone.toValidNumber(dialCode);
    if (number == null) return;
    final users = await getUsersWithNumbers([number]);
    final phoneContactsBox = Hive.box<String>("contacts");
    if (users.isNotEmpty) {
      final usersBox = Hive.box<String>("users");
      final watchersBox = Hive.box<String>("watchers");

      contact.contactStatus = ContactStatus.added;
      contact.userIds = [];
      for (var user in users) {
        contact.userIds!.add(user.id);
        usersBox.put(user.id, user.toJson());
        final watchers = await addMyWatcher([user.id]);
        if (watchers.isNotEmpty) {
          final watcher = watchers.first;
          watchersBox.put(user.id, watcher.toJson());
          if (newlyAddedWatchers != null) {
            newlyAddedWatchers!.add(watcher);
          }
        }
      }
    } else {
      contact.contactStatus = ContactStatus.requested;
      await addRequestedWatcher([contact.phone]);
    }
    phoneContactsBox.put(contact.phone, contact.toJson());
    ref.read(contactsProvider.notifier).updatePhoneContacts(contact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersBox = Hive.box<String>("users");

    final contacts = ref.watch(contactsProvider).where((contact) =>
        (isInvite && contact.contactStatus != ContactStatus.added) ||
        (contactStatusIndex != null &&
            contact.contactStatus ==
                ContactStatus.values[contactStatusIndex!]));

    final searchText = ref.watch(searchContactsProvider);

    final phoneContacts = contacts.where((contact) {
      return contact.name!.toLowerCase().contains(searchText) ||
          contact.phone.toLowerCase().contains(searchText);
    }).toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: phoneContacts.length,
      itemBuilder: (context, index) {
        final phoneContact = phoneContacts[index];

        List<User> users = [];
        if (phoneContact.userIds != null && phoneContact.userIds!.isNotEmpty) {
          for (final userId in phoneContact.userIds!) {
            final userJson = usersBox.get(userId);
            if (userJson != null) {
              final user = User.fromJson(userJson);
              user.phoneName = phoneContact.name;
              users.add(user);
            }
          }
        } else {
          final user = User(
              id: "",
              username: "",
              phoneName: phoneContact.name ?? "",
              name: "",
              email: "",
              phone: phoneContact.phone,
              photo: "",
              token: "",
              createdAt: phoneContact.createdAt,
              modifiedAt: phoneContact.modifiedAt ?? phoneContact.createdAt);
          users.add(user);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(users.length, (index) {
            final user = users[index];
            return UserSelectItem(
              availablePlatforms: availablePlatforms,
              user: user,
              onPressed: () {
                if (phoneContact.contactStatus == ContactStatus.unadded) {
                  addContact(phoneContact, ref);
                } else if (phoneContact.contactStatus ==
                    ContactStatus.requested) {
                  shareContactInvite("SMS", phoneContact);
                } else {}
              },
              onShare: (platform) => shareContactInvite(platform, phoneContact),
            );
          }),
        );
        // return ContactItem(
        //   isInvite: isInvite,
        //   availablePlatforms: availablePlatforms,
        //   contact: phoneContact,
        //   onPressed: () => phoneContact.contactStatus == ContactStatus.unadded
        //       ? addContact(phoneContact, ref)
        //       : shareContactInvite("SMS", phoneContact),
        //   onShare: (platform) => shareContactInvite(platform, phoneContact),
        // );
      },
    );
  }
}

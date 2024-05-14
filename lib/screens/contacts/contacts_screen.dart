import 'package:flutter/material.dart';
import 'package:watchball/components/contact/contact_item.dart';
import 'package:watchball/models/contact.dart';
import 'package:watchball/models/user.dart';
import 'package:watchball/utils/mockdatas/users.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<User> contacts = [];
  //final _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contacts = allFriends;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ContactItem(
            user: contact,
            type: "request",
          );
        });
  }
}

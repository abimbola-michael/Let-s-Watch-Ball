import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_appbar.dart';

import '../../../shared/components/app_icon_button.dart';
import '../../contact/models/phone_contact.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  List<PhoneContact> phoneContacts = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Select Contact",
        trailing: AppIconButton(
          icon: EvaIcons.search,
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        itemCount: phoneContacts.length,
        itemBuilder: (BuildContext context, int index) {},
      ),
    );
  }
}

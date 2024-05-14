import 'package:flutter/material.dart';
import 'package:watchball/components/reuseable/app_appbar.dart';
import 'package:watchball/components/settings/settings_category_item.dart';
import 'package:watchball/components/settings/settings_item.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/colors.dart';

class SettingsAndMoreScreen extends StatefulWidget {
  static const route = "/settings-and-more";
  const SettingsAndMoreScreen({super.key});

  @override
  State<SettingsAndMoreScreen> createState() => _SettingsAndMoreScreenState();
}

class _SettingsAndMoreScreenState extends State<SettingsAndMoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "Settings and More",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsCategoryItem(title: "Match", children: [
                SettingsItem(title: "Liked Matches", icon: OctIcons.thumbsup),
                SettingsItem(
                    title: "Disliked Matches", icon: OctIcons.thumbsdown),
                SettingsItem(title: "Starred Matches", icon: OctIcons.star),
                SettingsItem(title: "Watched Matches", icon: OctIcons.play),
                SettingsItem(
                    title: "Discussed Matches", icon: EvaIcons.mic_outline),
              ]),
              SettingsCategoryItem(title: "Feed", children: [
                SettingsItem(title: "Liked Feeds", icon: OctIcons.thumbsup),
                SettingsItem(
                    title: "Disliked Feeds", icon: OctIcons.thumbsdown),
                SettingsItem(title: "Starred Feeds", icon: OctIcons.star),
                SettingsItem(
                    title: "Discussed Feeds", icon: EvaIcons.mic_outline),
              ]),
              SettingsCategoryItem(title: "Discussion", children: [
                SettingsItem(
                    title: "Liked Discussions", icon: OctIcons.thumbsup),
                SettingsItem(
                    title: "Disliked Discussions", icon: OctIcons.thumbsdown),
                SettingsItem(title: "Starred Discussions", icon: OctIcons.star),
              ]),
              SettingsCategoryItem(title: "Notification", children: [
                SettingsItem(title: "Bio", icon: OctIcons.thumbsup),
                SettingsItem(title: "Discussion", icon: OctIcons.thumbsdown),
                SettingsItem(title: "Feed", icon: OctIcons.thumbsup),
                SettingsItem(title: "Request", icon: OctIcons.thumbsdown),
              ]),
              SettingsCategoryItem(title: "Privacy", children: [
                SettingsItem(title: "Discussion", icon: OctIcons.thumbsup),
                SettingsItem(title: "Comment", icon: OctIcons.thumbsdown),
                SettingsItem(title: "Contact", icon: OctIcons.thumbsdown),
                SettingsItem(title: "Account", icon: OctIcons.thumbsup),
                SettingsItem(title: "Blocked", icon: OctIcons.thumbsdown),
              ]),
              SettingsCategoryItem(title: "More", children: [
                SettingsItem(title: "About", icon: OctIcons.thumbsup),
                SettingsItem(
                    title: "Terms and Privacy Policy", icon: OctIcons.thumbsup),
                SettingsItem(title: "Help", icon: OctIcons.thumbsdown),
                SettingsItem(
                    title: "Invite a Contact", icon: OctIcons.thumbsdown),
                SettingsItem(
                  title: "Log Out",
                  icon: OctIcons.thumbsdown,
                  color: red,
                ),
              ]),
              SettingsCategoryItem(title: "Follow Us", children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(IonIcons.logo_instagram),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(IonIcons.logo_twitter),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(IonIcons.logo_facebook),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(IonIcons.logo_tiktok),
                    ),
                  ],
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}

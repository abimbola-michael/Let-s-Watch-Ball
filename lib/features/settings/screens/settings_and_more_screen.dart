import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchball/features/main/screens/main_screen.dart';
import 'package:watchball/features/contact/screens/invite_contacts_screen.dart';
import 'package:watchball/firebase/auth_methods.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/features/settings/components/settings_category_item.dart';
import 'package:watchball/features/settings/components/settings_item.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../theme/colors.dart';
import '../../onboarding/screens/welcome_screen.dart';
import '../../profile/screens/edit_profile_screen.dart';
import '../../watch/screens/findorinvite_watchers_screen.dart';
import '../utils/constants.dart';

class SettingsAndMoreScreen extends StatefulWidget {
  static const route = "/settings-and-more";
  const SettingsAndMoreScreen({super.key});

  @override
  State<SettingsAndMoreScreen> createState() => _SettingsAndMoreScreenState();
}

class _SettingsAndMoreScreenState extends State<SettingsAndMoreScreen> {
  final am = AuthMethods();
  void gotoEditProfilePage(String type) async {
    final newValue = await context.pushTo(EditProfileScreen(type: type));
    if (newValue == null) return;
  }

  void changeEmail() {
    gotoEditProfilePage("email");
  }

  void changePassword() {
    gotoEditProfilePage("password");
  }

  Future logout() async {
    final comfirm = await context.showComfirmationDialog(
        "Logout", "Are you sure you want to logout?");
    if (!comfirm) return;
    await am.logOut();
    Hive.box<String>("details").delete("dailyLimit");
    Hive.box<String>("details").delete("dailyLimitDate");
    gotoStartPage();

    if (!mounted) return;
  }

  void deleteAccount() async {
    final comfirm = await context.showComfirmationDialog(
        "Delete Account", "Are you sure you want to delete account?");
    if (!comfirm) return;
    await am.deleteAccount();
    await logout();
    Hive.box<String>("details").delete("dailyLimit");
    Hive.box<String>("details").delete("dailyLimitDate");

    if (!mounted) return;
    gotoStartPage();
  }

  void gotoStartPage() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      WelcomeScreen.route,
      (Route<dynamic> route) => false, // Remove all routes
    );
  }

  //void addAccount() {}
  void gotoTermsAndPrivacy() {
    launchUrl(Uri.parse(TERMS_AND_PRIVACY_LINK));
  }

  void gotoAbout() {
    launchUrl(Uri.parse(ABOUT_LINK));
  }

  void gotoContactUs() {
    String subjectTemp = "Contact: ";
    String bodyTemp = "My name is .....\nI am contacting for ...";

    launchUrl(Uri.parse(
        "mailto:abimbolamichael100@gmail.com?subject=$subjectTemp&body=$bodyTemp"));
  }

  void gotoHelpCenter() {
    String subjectTemp = "Help: ";
    String bodyTemp = "My name is .....\nI need help with ...";

    launchUrl(Uri.parse(
        "mailto:abimbolamichael100@gmail.com?subject=$subjectTemp&body=$bodyTemp"));
  }

  void gotoInviteContact() {
    context.pushNamedTo(FindOrInviteWatchersScreen.route,
        args: {"isInvite": true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: "Settings and More",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SettingsCategoryItem(title: "Match", children: [
              //   SettingsItem(title: "Liked Matches", icon: OctIcons.thumbsup),
              //   SettingsItem(
              //       title: "Disliked Matches", icon: OctIcons.thumbsdown),
              //   SettingsItem(title: "Starred Matches", icon: OctIcons.star),
              //   SettingsItem(title: "Watched Matches", icon: OctIcons.play),
              //   SettingsItem(
              //       title: "Discussed Matches", icon: EvaIcons.mic_outline),
              // ]),
              // SettingsCategoryItem(title: "Feed", children: [
              //   SettingsItem(title: "Liked Feeds", icon: OctIcons.thumbsup),
              //   SettingsItem(
              //       title: "Disliked Feeds", icon: OctIcons.thumbsdown),
              //   SettingsItem(title: "Starred Feeds", icon: OctIcons.star),
              //   SettingsItem(
              //       title: "Discussed Feeds", icon: EvaIcons.mic_outline),
              // ]),
              // SettingsCategoryItem(title: "Discussion", children: [
              //   SettingsItem(
              //       title: "Liked Discussions", icon: OctIcons.thumbsup),
              //   SettingsItem(
              //       title: "Disliked Discussions", icon: OctIcons.thumbsdown),
              //   SettingsItem(title: "Starred Discussions", icon: OctIcons.star),
              // ]),
              // SettingsCategoryItem(title: "Notification", children: [
              //   SettingsItem(title: "Bio", icon: OctIcons.thumbsup),
              //   SettingsItem(title: "Discussion", icon: OctIcons.thumbsdown),
              //   SettingsItem(title: "Feed", icon: OctIcons.thumbsup),
              //   SettingsItem(title: "Request", icon: OctIcons.thumbsdown),
              // ]),
              // SettingsCategoryItem(title: "Privacy", children: [
              //   SettingsItem(title: "Discussion", icon: OctIcons.thumbsup),
              //   SettingsItem(title: "Comment", icon: OctIcons.thumbsdown),
              //   SettingsItem(title: "Contact", icon: OctIcons.thumbsdown),
              //   SettingsItem(title: "Account", icon: OctIcons.thumbsup),
              //   SettingsItem(title: "Blocked", icon: OctIcons.thumbsdown),
              // ]),
              SettingsCategoryItem(title: "Account", children: [
                SettingsItem(
                  title: "Change Email",
                  icon: OctIcons.mail,
                  onPressed: changeEmail,
                ),
                SettingsItem(
                  title: "Change Password",
                  icon: OctIcons.lock,
                  onPressed: changePassword,
                ),
                SettingsItem(
                  title: "Logout",
                  icon: Icons.exit_to_app_outlined,
                  onPressed: logout,
                ),
                SettingsItem(
                  title: "Delete Account",
                  icon: OctIcons.trash,
                  color: Colors.red,
                  onPressed: deleteAccount,
                ),
              ]),
              SettingsCategoryItem(title: "More", children: [
                SettingsItem(
                  title: "About",
                  icon: OctIcons.info,
                  onPressed: gotoAbout,
                ),
                SettingsItem(
                  title: "Terms and Privacy Policy",
                  icon: OctIcons.info,
                  onPressed: gotoTermsAndPrivacy,
                ),
                SettingsItem(
                  title: "Help",
                  icon: OctIcons.mail,
                  onPressed: gotoHelpCenter,
                ),
                SettingsItem(
                  title: "Contact Us",
                  icon: OctIcons.mail,
                  onPressed: gotoContactUs,
                ),
                SettingsItem(
                  title: "Invite a Contact",
                  icon: OctIcons.person_add,
                  onPressed: gotoInviteContact,
                ),
              ]),
              // SettingsCategoryItem(title: "Follow Us", children: [
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       IconButton(
              //         onPressed: () {},
              //         icon: const Icon(IonIcons.logo_instagram),
              //       ),
              //       IconButton(
              //         onPressed: () {},
              //         icon: const Icon(IonIcons.logo_twitter),
              //       ),
              //       IconButton(
              //         onPressed: () {},
              //         icon: const Icon(IonIcons.logo_facebook),
              //       ),
              //       IconButton(
              //         onPressed: () {},
              //         icon: const Icon(IonIcons.logo_tiktok),
              //       ),
              //     ],
              //   )
              // ])
            ],
          ),
        ),
      ),
    );
  }
}

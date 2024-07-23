import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/features/profile/components/profile_stat_item.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/shared/components/menu_item.dart';
import 'package:watchball/features/about/screens/about_screen.dart';
import 'package:watchball/features/settings/screens/settings_and_more_screen.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../about/components/about_item.dart';
import '../../../shared/components/logo.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/app_tabbar.dart';
import '../../user/mocks/users.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final _pageController = PageController();

  int currentIndex = 0;

  // void updateTab(int index) {
  //   _pageController.jumpToPage(index);
  // }

  void updatePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _pageController.dispose();
    super.dispose();
  }

  void viewContacts() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        leading: const Logo(),
        title: "Profile",
        // trailing: PopupMenuButton(
        //   itemBuilder: (context) {
        //     return [
        //       PopupMenuItem(
        //         onTap: () {},
        //         child: const MenuItem(
        //           title: "Watched Matches",
        //           icon: EvaIcons.settings_outline,
        //         ),
        //       ),
        //       PopupMenuItem(
        //         onTap: () {},
        //         child: const MenuItem(
        //           title: "Starred Matches",
        //           icon: EvaIcons.settings_outline,
        //         ),
        //       ),
        //       PopupMenuItem(
        //         onTap: () {},
        //         child: const MenuItem(
        //           title: "Starred Feeds",
        //           icon: EvaIcons.settings_outline,
        //         ),
        //       ),
        //       PopupMenuItem(
        //         onTap: () {},
        //         child: const MenuItem(
        //           title: "Settings",
        //           icon: EvaIcons.settings_outline,
        //         ),
        //       ),
        //     ];
        //   },
        //   child: const Icon(EvaIcons.menu),
        // ),
        trailing: AppIconButton(
          icon: EvaIcons.menu,
          onPressed: () {
            context.pushNamedTo(SettingsAndMoreScreen.route);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            AppContainer(
              borderRadius: BorderRadius.circular(30),
              height: 100,
              width: 100,
              borderColor: tint,
              // borderWidth: 5,
              image: AssetImage(userOne.photo.toJpg),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              userOne.name,
              style: context.headlineMedium?.copyWith(fontSize: 18),
            ),
            ProfileStatItem(
              title: "Contacts",
              count: 278,
              onPressed: viewContacts,
            ),
            const SizedBox(
              height: 20,
            ),
            const AboutItem(title: "My Football Nickname", value: "Rooney"),
            const AboutItem(title: "My Goat", value: "Messi"),
            const AboutItem(title: "My Favorite Club", value: "Real Madrid"),
            const AboutItem(title: "My Favorite Country", value: "England"),
          ],
        ),
        // child: NestedScrollView(
        //     headerSliverBuilder: (context, innerScrolled) {
        //       return [
        //         SliverAppBar(
        //           expandedHeight: 180,
        //           // pinned: true,
        //           // floating: true,
        //           backgroundColor: transparent,
        //           flexibleSpace: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               const SizedBox(
        //                 height: 20,
        //               ),
        //               AppContainer(
        //                 borderRadius: BorderRadius.circular(30),
        //                 height: 100,
        //                 width: 100,
        //                 borderColor: lightTint,
        //                 borderWidth: 5,
        //                 image: AssetImage(userOne.photo.toJpg),
        //               ),
        //               const SizedBox(
        //                 height: 8,
        //               ),
        //               Text(
        //                 userOne.name,
        //                 style: context.headlineMedium?.copyWith(fontSize: 18),
        //               ),
        //               const SizedBox(
        //                 height: 20,
        //               ),
        //               const AboutItem(
        //                   title: "My Football Nickname", value: "Rooney"),
        //               const AboutItem(title: "My Goat", value: "Messi"),
        //               const AboutItem(title: "My Club", value: "Real Madrid"),
        //             ],
        //           ),
        //         )
        //       ];
        //     },
        //     body: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [

        //       ],
        //     )),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(EvaIcons.edit_outline),
      ),
    );
  }
}

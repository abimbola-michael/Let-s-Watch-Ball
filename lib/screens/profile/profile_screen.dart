import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/components/profile/profile_stat_item.dart';
import 'package:watchball/components/reuseable/app_container.dart';
import 'package:watchball/components/reuseable/menu_item.dart';
import 'package:watchball/screens/about/about_screen.dart';
import 'package:watchball/screens/contacts/contacts_screen.dart';
import 'package:watchball/screens/settings/settings_and_more_screen.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../components/about/about_item.dart';
import '../../components/logo/fm_logo.dart';
import '../../components/reuseable/app_appbar.dart';
import '../../components/reuseable/app_icon_button.dart';
import '../../components/reuseable/app_tabbar.dart';
import '../../utils/mockdatas/users.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> tabs = [
    "Competitions",
    "Matches",
    "Clubs",
    "Countries",
  ];
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppAppBar(
          leading: const FmLogo(),
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
          child: NestedScrollView(
              headerSliverBuilder: (context, innerScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 180,
                    // pinned: true,
                    // floating: true,
                    backgroundColor: transparent,
                    flexibleSpace: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        AppContainer(
                          borderRadius: BorderRadius.circular(30),
                          height: 100,
                          width: 100,
                          borderColor: lightTint,
                          borderWidth: 5,
                          image: AssetImage(userOne.photo.toJpg),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          userOne.name,
                          style: context.headlineMedium?.copyWith(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ];
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AboutItem(
                      title: "My Football Nickname", value: "Rooney"),
                  const AboutItem(title: "My Goat", value: "Messi"),
                  const AboutItem(title: "My Club", value: "Real Madrid"),
                  Row(
                    children: [
                      Text(
                        "Favorites",
                        style: context.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.center,
                          dividerColor: transparent,
                          tabs: List.generate(
                            tabs.length,
                            (index) {
                              final tab = tabs[index];
                              return Tab(
                                text: tab,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      //  controller: _pageController,
                      // onPageChanged: updatePage,
                      children: [
                        ContactsScreen(),
                        ContactsScreen(),
                        ContactsScreen(),
                        ContactsScreen()
                      ],
                    ),
                  ),
                ],
              )),
        ),
        // floatingActionButton: FloatingActionButton.small(
        //     child: const Icon(EvaIcons.plus), onPressed: () {}),
      ),
    );
  }
}

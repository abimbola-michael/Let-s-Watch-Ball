import 'package:flutter/material.dart';
import 'package:watchball/screens/wallet/wallet_screen.dart';
import 'package:watchball/screens/match/matches_screen.dart';
import 'package:watchball/screens/profile/profile_screen.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils/colors.dart';
import 'contacts/contacts_screen.dart';
import 'match/watched_matches_screen.dart';

class MainScreen extends StatefulWidget {
  static const route = "/main";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  void updateTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          MatchesScreen(),
          WatchedMatchesScreen(),
          WalletScreen(),
          ContactsScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: transparent,
          selectedItemColor: primaryColor,
          unselectedItemColor: lighterTint,
          currentIndex: currentIndex,
          onTap: updateTab,
          //BoxIcons.bx_football
          items: const [
            BottomNavigationBarItem(
              icon: Icon(MingCute.football_line),
              label: "Matches",
            ),
            BottomNavigationBarItem(
              icon: Icon(MingCute.tv_2_line),
              label: "Watched",
            ),
            BottomNavigationBarItem(
              icon: Icon(MingCute.wallet_2_line),
              label: "Wallet",
            ),
            BottomNavigationBarItem(
              icon: Icon(MingCute.group_line),
              label: "Contacts",
            ),
            BottomNavigationBarItem(
              icon: Icon(OctIcons.person),
              label: "Profile",
            ),
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../components/logo/fm_logo.dart';
import '../../components/reuseable/app_appbar.dart';
import '../../components/reuseable/app_icon_button.dart';
import '../../components/reuseable/app_tabbar.dart';
import 'transactions_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<String> tabs = ["All", "Watched", "Deposited", "Transfered", "Received"];

  final _pageController = PageController();

  int currentIndex = 0;

  void updateTab(int index) {
    _pageController.jumpToPage(index);
  }

  void updatePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        leading: FmLogo(),
        title: "Wallet",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            AppTabBar(
                selectedTab: currentIndex, tabs: tabs, onTabChanged: updateTab),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: updatePage,
                children: List.generate(tabs.length, (index) {
                  final tab = tabs[index];
                  return TransactionScreen(type: tab);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_text_field.dart';
import 'package:watchball/features/wallet/components/wallet_action_item.dart';
import 'package:watchball/features/wallet/screens/select_users_screen.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/features/user/mocks/users.dart';

import '../../../shared/components/logo.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_container.dart';
import '../../../shared/components/app_icon_button.dart';
import '../../../shared/components/app_tabbar.dart';
import '../../user/components/user_hor_item.dart';
import '../../user/models/user.dart';
import '../../../theme/colors.dart';
import 'transactions_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<String> tabs = ["All", "Watched", "Deposited", "Transfered", "Received"];

  int currentIndex = 0;
  double balance = 2000;
  String currency = "NGN";
  bool hidden = false;
  bool innerScrolled = false;

  List<User> selectedUsers = [];
  String mode = "";
  double totalAmount = 0;
  final _pageController = PageController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  void toggleBalanceVisibility() {
    setState(() {
      hidden = !hidden;
    });
  }

  void updateTab(int index) {
    _pageController.jumpToPage(index);
  }

  void updatePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void selectUsers() async {
    final result = await context.pushNamedTo(SelectedUsersScreen.route,
        args: {"type": "transfer", "users": selectedUsers});
    if (result != null) {
      selectedUsers = result["users"];
      enterTransferAmount();
    }
  }

  void goBack() {
    _amountController.clear();

    selectedUsers.clear();
    setState(() {
      mode = "";
    });
  }

  void enterDepositAmount() {
    selectedUsers.add(userOne);
    setState(() {
      mode = "deposit";
    });
  }

  void enterTransferAmount() {
    setState(() {
      mode = "transfer";
    });
  }

  void depositOrTransfer() {
    if (mode == "transfer") {
    } else {}
    _amountController.clear();
    mode = "";
    setState(() {});
  }

  void removeUser(User user) {
    selectedUsers.remove(user);
    if (selectedUsers.isEmpty) {
      mode = "";
    }

    setState(() {});
  }

  void updateTotalAmount(String value) {
    final amount = value.toDouble * selectedUsers.length;
    totalAmount = amount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppAppBar(
          leading: const Logo(),
          title: "Wallet",
          subtitle: innerScrolled ? "$currency$balance" : null,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NestedScrollView(
            headerSliverBuilder: (context, scroll) {
              if (innerScrolled != scroll) {
                innerScrolled = scroll;
              }

              return [
                SliverAppBar(
                  expandedHeight: mode.isEmpty ? 100 : 60,
                  collapsedHeight: mode.isEmpty ? 100 : 60,
                  backgroundColor: transparent,
                  flexibleSpace: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Balance",
                            style: context.bodySmall,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: toggleBalanceVisibility,
                            child: Icon(
                              hidden ? EvaIcons.eye : EvaIcons.eye_off,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      Text(
                        hidden ? "*******" : "$currency$balance",
                        style: context.headlineMedium,
                      ),
                      if (mode.isEmpty)
                        const SizedBox(
                          height: 10,
                        ),
                      if (mode.isEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            WalletActionItem(
                              title: "Transfer",
                              onPressed: selectUsers,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            WalletActionItem(
                              title: "Deposit",
                              color: primaryColor,
                              onPressed: enterDepositAmount,
                            ),
                          ],
                        )
                    ],
                  ),
                )
              ];
            },
            body: Column(
              children: [
                if (mode.isEmpty) ...[
                  TabBar(
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
                  Expanded(
                    child: TabBarView(
                      children: List.generate(tabs.length, (index) {
                        final tab = tabs[index];
                        return TransactionScreen(type: tab);
                      }),
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: goBack,
                        icon: const Icon(
                          EvaIcons.arrow_back_outline,
                        ),
                      ),
                      Text(
                        mode.capitalize,
                        style: context.headlineSmall?.copyWith(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: selectUsers,
                        icon: const Icon(
                          EvaIcons.person_add_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Selected People",
                      style: context.headlineMedium?.copyWith(fontSize: 14),
                    ),
                  ),
                  AppContainer(
                    height: 100,
                    child: selectedUsers.isEmpty
                        ? GestureDetector(
                            onTap: selectUsers,
                            child: Text(
                              "Select users",
                              style: context.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // shrinkWrap: true,
                            itemCount: selectedUsers.length,
                            itemBuilder: (context, index) {
                              final user = selectedUsers[index];
                              return UserHorItem(
                                user: user,
                                onClose: () => removeUser(user),
                              );
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Enter ${mode.capitalize} Amount",
                      style: context.headlineMedium?.copyWith(fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppContainer(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(30),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(bottom: 10),
                    color: lightestTint,
                    child: Row(children: [
                      Text("NGN",
                          style:
                              context.headlineMedium?.copyWith(fontSize: 18)),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          style: context.headlineMedium?.copyWith(fontSize: 18),
                          keyboardType: TextInputType.number,
                          onChanged: updateTotalAmount,
                          decoration: InputDecoration(
                            hintText: "${mode.capitalize} Amount",
                            hintStyle: context.headlineMedium
                                ?.copyWith(fontSize: 18, color: lighterTint),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (totalAmount > 0)
                    AppButton(
                      title: "${mode.capitalize} $totalAmount",
                      onPressed: depositOrTransfer,
                    )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

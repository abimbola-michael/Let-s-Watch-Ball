import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/match/components/live_match_item.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/payment/screens/payment_item.dart';
import 'package:watchball/features/payment/screens/payment_type_item.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/app_container.dart';
import '../../wallet/components/wallet_action_item.dart';
import '../../../theme/colors.dart';

class MatchPaymentScreen extends StatefulWidget {
  static const route = "/match-payment";
  const MatchPaymentScreen({super.key});

  @override
  State<MatchPaymentScreen> createState() => _MatchPaymentScreenState();
}

class _MatchPaymentScreenState extends State<MatchPaymentScreen> {
  late LiveMatch match;
  double balance = 2000;
  String currency = "NGN";
  bool hidden = false;
  List<String> resolutions = ["360p", "480p", "720p", "1080p"];
  List<double> withoutDataPrices = [200, 400, 700, 1000];
  List<double> withDataPrices = [400, 800, 1200, 1500];

  int selectedResolution = -1;
  bool withData = true;
  String mode = "";
  final _amountController = TextEditingController();
  double totalAmount = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    match = context.args["match"];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _amountController.dispose();

    super.dispose();
  }

  void toggleBalanceVisibility() {
    setState(() {
      hidden = !hidden;
    });
  }

  void selectType() {
    setState(() {
      withData = !withData;
    });
  }

  void selectResolution(int index) {
    setState(() {
      selectedResolution = index;
    });
  }

  void updateTotalAmount(String value) {
    final amount = value.toDouble;
    totalAmount = amount;
    setState(() {});
  }

  void goBack() {
    _amountController.clear();
    setState(() {
      mode = "";
    });
  }

  void enterDepositAmount() {
    setState(() {
      mode = "deposit";
    });
  }

  void deposit() {
    _amountController.clear();
    mode = "";
    setState(() {});
  }

  void pay() {
    if (selectedResolution == -1) return;
    final price = withData
        ? withDataPrices[selectedResolution]
        : withoutDataPrices[selectedResolution];
    if (price > balance) {
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: "Match Payment",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LiveMatchItem(match: match),
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
              const SizedBox(
                height: 10,
              ),
              if (mode == "deposit") ...[
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
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Enter Deposit Amount",
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
                        style: context.headlineMedium?.copyWith(fontSize: 18)),
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
                    title: "Deposit $totalAmount",
                    onPressed: deposit,
                  )
              ] else ...[
                WalletActionItem(
                  title: "Deposit",
                  color: primaryColor,
                  onPressed: enterDepositAmount,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Select Type",
                    style: context.headlineMedium?.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PaymentTypeItem(
                        type: "With Data",
                        onPressed: selectType,
                        selected: withData,
                        message: "We will provide streaming data",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: PaymentTypeItem(
                        type: "Without Data",
                        onPressed: selectType,
                        selected: !withData,
                        message: "We won't provide streaming data",
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
                    "Select Resolution",
                    style: context.headlineMedium?.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  children: List.generate(resolutions.length, (index) {
                    final resolution = resolutions[index];
                    final price = withData
                        ? withDataPrices[index]
                        : withoutDataPrices[index];
                    return PaymentItem(
                      price: price,
                      resolution: resolution,
                      currency: currency,
                      onPressed: () => selectResolution(index),
                      selected: selectedResolution == index,
                    );
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (selectedResolution != -1)
                  AppButton(
                    title: "Pay",
                    onPressed: pay,
                  ),
                const SizedBox(
                  height: 50,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

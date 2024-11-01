import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watchball/features/subscription/utils/subscription_utils.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../../shared/components/app_button.dart';
import '../components/subscription_info_item.dart';
import '../enums/enums.dart';
import '../models/subscription_info.dart';
import '../services/services.dart';

class SubscriptionScreen extends StatefulWidget {
  static const route = "/subscription";
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool loading = false;
  StreamSubscription? subscriptionStatusSub;
  late SubscriptionUtils subscriptionUtils;
  SubscriptionPlan? previousPlan;
  SubscriptionPlan? currentPlan;
  List<SubscriptionInfo> subscriptionInfos = [
    SubscriptionInfo(
      type: SubscriptionType.free,
      infos: [
        "See lastest matches and their live scores",
        "Seamless streaming of matches",
        "Ads while watching match",
        "30 mins of Audio and Video watching daily",
        "You won't be able to see available watchs and join easily by requesting"
      ],
    ),
    SubscriptionInfo(
      type: SubscriptionType.paid,
      plan: SubscriptionPlan.daily,
      infos: [
        "See lastest matches and their live scores",
        "Seamless streaming of matches",
        "No Ads while watching match",
        "Unlimited Audio and Video watching",
        "You would be able to see available watchs and join easily by requesting"
      ],
      dollarPrice: 1,
    ),
    SubscriptionInfo(
      type: SubscriptionType.paid,
      plan: SubscriptionPlan.weekly,
      infos: [],
      dollarPrice: 5,
    ),
    SubscriptionInfo(
      type: SubscriptionType.paid,
      plan: SubscriptionPlan.monthly,
      infos: [],
      dollarPrice: 15,
    ),
    SubscriptionInfo(
      type: SubscriptionType.paid,
      plan: SubscriptionPlan.yearly,
      infos: [],
      dollarPrice: 165,
    ),
  ];
  @override
  void initState() {
    super.initState();
    listenToSubscriptionStatus();
    readSubscriptionPlan();
  }

  @override
  void dispose() {
    subscriptionUtils.dispose();
    subscriptionStatusSub?.cancel();
    super.dispose();
  }

  void listenToSubscriptionStatus() {
    subscriptionUtils = SubscriptionUtils();

    subscriptionStatusSub =
        subscriptionUtils.subscriptionStatusStream?.listen((subStatus) {
      final subscribed = subStatus.subscribed;
      final plan = subStatus.plan;
      final purchaseStatus = subStatus.purchaseStatus;
      if (subscribed) {
        setState(() {
          previousPlan = plan;
        });
      }
      context.showSnackBar(
          "${plan?.name.capitalize ?? ""} subscription ${purchaseStatus.name}",
          !subscribed);
    });
  }

  void readSubscriptionPlan() async {
    loading = true;
    setState(() {});

    previousPlan = await getSubscriptionPlan();
    currentPlan = previousPlan;
    loading = false;

    setState(() {});
  }

  void togglePlanChange(SubscriptionPlan? plan) {
    currentPlan = plan;
    setState(() {});
  }

  bool get isValidSelection {
    final prevPlanIndex = previousPlan == null ? 0 : previousPlan!.index + 1;
    final currentPlanIndex = currentPlan == null ? 0 : currentPlan!.index + 1;
    return currentPlan != previousPlan && currentPlanIndex > prevPlanIndex;
  }

  void selectPlan() async {
    if (!isAndroidAndIos) {
      context.pop();
      return;
    }
    await subscriptionUtils.subscribe(currentPlan!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: "Subscription",
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: subscriptionInfos.length,
              itemBuilder: (context, index) {
                final info = subscriptionInfos[index];
                final prevInfo =
                    index == 0 ? null : subscriptionInfos[index - 1];
                return SubscriptionInfoItem(
                    info: info,
                    prevInfo: prevInfo,
                    previousPlan: previousPlan,
                    currentPlan: currentPlan,
                    onChanged: togglePlanChange);
              },
            ),
      bottomNavigationBar: isValidSelection
          ? Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                  child: AppButton(
                      title: "Select Plan",
                      //wrapped: true,
                      onPressed: selectPlan)),
            )
          : null,
    );
  }
}

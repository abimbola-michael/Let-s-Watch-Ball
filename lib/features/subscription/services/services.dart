import 'package:hive_flutter/hive_flutter.dart';
import 'package:watchball/features/subscription/enums/enums.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../utils/utils.dart';
import '../../user/services/user_service.dart';
import '../constants/constants.dart';
import '../models/available_watch.dart';

FirestoreMethods fm = FirestoreMethods();

Future<SubscriptionPlan?> getSubscriptionPlan() async {
  final user = await getUser(myId, useCache: false);

  final index = user == null ||
          user.sub == null ||
          (user.subExpiryTime != null &&
              timeNow.datetime.isAfter(user.subExpiryTime!.datetime))
      ? -1
      : SubscriptionPlan.values
          .indexWhere((element) => element.name == user.sub!);
  return index == -1 ? null : SubscriptionPlan.values[index];
}

Future<AvailableWatch> getAvailableWatchDuration() async {
  final user = await getUser(myId, useCache: false);
  if (user == null) return AvailableWatch(duration: 0, isSubscription: false);

  if (user.sub != null && user.subExpiryTime != null) {
    if (DateTime.now().isBefore(user.subExpiryTime!.datetime)) {
      return AvailableWatch(
          duration:
              DateTime.now().difference(user.subExpiryTime!.datetime).inSeconds,
          isSubscription: true);
    } else {
      await resetSubscription();
      return AvailableWatch(duration: 0, isSubscription: false);
    }
  } else if (user.dailyLimitDate == null ||
      user.dailyLimit == null ||
      DateTime.now().difference(user.dailyLimitDate!.datetime).inDays > 0) {
    await updateDailyLimit(MAX_DAILY_LIMIT);
    return AvailableWatch(duration: MAX_DAILY_LIMIT, isSubscription: false);
  }

  final storedDailyLimit =
      int.parse(Hive.box<String>("details").get("dailyLimit") ?? "0");
  final storedDailyLimitDate =
      Hive.box<String>("details").get("dailyLimitDate")?.datetime ??
          DateTime.now();
  int dailyLimit = 0;

  if (storedDailyLimitDate.isAfter(user.dailyLimitDate!.datetime) &&
      storedDailyLimit > user.dailyLimit!) {
    dailyLimit = storedDailyLimit;
    updateDailyLimit(storedDailyLimit);
  } else {
    dailyLimit = user.dailyLimit!;
  }

  return AvailableWatch(duration: dailyLimit, isSubscription: false);
}

Future resetSubscription() async {
  return fm.updateValue([
    "users",
    myId
  ], value: {
    "sub": null,
    "subExpiryTime": null,
    "dailyLimit": MAX_DAILY_LIMIT,
    "dailyLimitDate": timeNow
  });
}

Future updateDailyLimit(int limit) async {
  return fm.updateValue(["users", myId],
      value: {"dailyLimit": limit, "dailyLimitDate": timeNow});
}

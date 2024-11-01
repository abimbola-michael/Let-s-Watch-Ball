import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/watch/models/watcher.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/features/match/utils/match_utils.dart';
import 'package:watchball/utils/extensions.dart';
import '../../../firebase/firebase_notification.dart';
import '../../user/models/user.dart';
import '../models/watch.dart';
import '../../../utils/utils.dart';

final FirestoreMethods fm = FirestoreMethods();

Future<List<Watcher>> readRequestedWatchers(String? lastTime) async {
  return fm.getValues(
      (map) => Watcher.fromMap(map), ["users", myId, "requested_watchers"],
      where: lastTime != null ? ["time", ">", lastTime] : [], order: ["time"]);
}

Future<List<Watcher>> readMyWatchers(String? lastTime) async {
  return fm.getValues(
      (map) => Watcher.fromMap(map), ["users", myId, "watchers"],
      where: lastTime != null ? ["time", ">", lastTime] : [], order: ["time"]);
}

Future<List<Watcher>> addMyWatcher(List<String> ids) async {
  List<Watcher> watchers = [];
  for (int i = 0; i < ids.length; i++) {
    final id = ids[i];
    final watcher = Watcher(id: id, time: timeNow);
    await fm.setValue(["users", myId, "watchers", id],
        value: watcher.toMap().removeNulls());
    watchers.add(watcher);
  }
  return watchers;
}

Future removeMyWatcher(List<String> ids) async {
  for (int i = 0; i < ids.length; i++) {
    final id = ids[i];
    await fm.removeValue(["users", myId, "watchers", id]);
  }
}

Future addRequestedWatcher(List<String> phones) async {
  for (int i = 0; i < phones.length; i++) {
    final phone = phones[i];
    final watcher = Watcher(id: phone, time: timeNow);
    await fm.setValue(["users", myId, "requested_watchers", phone],
        value: watcher.toMap().removeNulls());
  }
}

Future removeRequestedWatcher(List<String> phones) async {
  for (int i = 0; i < phones.length; i++) {
    final phone = phones[i];
    await fm.removeValue(["users", myId, "requested_watchers", phone]);
  }
}

Future updateWatchsUsers(List<Watch> watchs) async {
  for (int i = 0; i < watchs.length; i++) {
    final watch = watchs[i];
    await updateWatchUsers(watch);
  }
}

Future updateWatchUsers(Watch watch) async {
  if (watch.users.isEmpty) {
    for (int i = 0; i < watch.watchersIds.length; i++) {
      final watchersId = watch.watchersIds[i];
      final user = await getUser(watchersId);
      if (user != null) {
        watch.users.add(user);
      }
    }
  }
  watch.creatorUser ??=
      watch.users.where((element) => element.id == watch.creatorId).firstOrNull;
}

Future<List<Watch>> readWatchs(List<String> ids) async {
  return fm.getValues((map) => Watch.fromMap(map), ["watchs"],
      where: ["watchersIds", "contains", myId], order: ["modifiedAt"]);
}

Stream<List<ValueChange<Watch>>> readWatchsStream(List<String> ids) async* {
  yield* fm.getValuesChangeStream((map) => Watch.fromMap(map), ["watchs"],
      where: ["watchersIds", "containsany", ids], order: ["modifiedAt"]);
  //, "creatorId", "!=", myId
}

Future<Watch?> createWatch(
    LiveMatch match, List<User> users, String callMode) async {
  final watchId = fm.getId(["watchs"]);
  //privacy options-nobody, invited, selected, anyone

  if (users.indexWhere((element) => element.id == myId) == -1) {
    final user = await getUser(myId);
    if (user != null) {
      users.insert(0, user);
    }
  }
  final time = timeNow;
// joinPrivacy: "invited",
  // invitePrivacy: "everyone",
  final watch = Watch(
      id: watchId,
      matchId: match.id,
      match: getMatchString(match),
      creatorId: myId,
      callMode: callMode,
      watchersIds: users.map((e) => e.id).toList(),
      joinedWatchersIds: [myId],
      createdAt: time,
      modifiedAt: time,
      records: []);

  await fm.setValue(["watchs", watchId], value: watch.toMap());
  await addWatchers(watch, users, [], callMode);

  return watch;
}

void deleteWatch(Watch watch) {}

Future addWatchers(
    Watch watch, List<User> users, List<String> watchersIds, String? callMode,
    [bool isRequest = false]) async {
  final watchId = watch.id;
  // final matchId = watch.matchId;
  // final match = watch.match;

  List<String> newlyAddedWatchersIds = [];

  final length = watchersIds.isNotEmpty ? watchersIds.length : users.length;
  for (int i = 0; i < length; i++) {
    String watcherId = "";
    if (watchersIds.isNotEmpty) {
      watcherId = watchersIds[i];
    } else {
      final user = users[i];
      watcherId = user.id;

      if (user.id != myId) {
        sendWatchNotification(user.token, watch);
      }
    }
    final time = timeNow;

    final watcher = Watcher(
        id: watcherId,
        status: isRequest
            ? "request"
            : watcherId == myId
                ? "current"
                : "invite",
        action: "calling",
        time: time,
        callMode: watcherId == myId ? callMode : null,
        match: watch.match);

    if (users.isNotEmpty && watcher.user == null) {
      watcher.user = users[i];
    }
    if (watchersIds.isNotEmpty && watcher.user == null) {
      watcher.user = await getUser(watcherId);
    }
    watch.joinedWatchersIds.add(watcherId);
    watch.watchers.add(watcher);

    await fm.setValue(["watchs", watchId, "watchers", watcherId],
        value: watcher.toMap().removeNulls());

    if (!watch.watchersIds.contains(watcherId)) {
      watch.watchersIds.add(watcherId);
      newlyAddedWatchersIds.add(watcherId);
    }
  }
  if (newlyAddedWatchersIds.isNotEmpty) {
    await fm.updateValue(["watchs", watchId],
        value: {"watchersIds": FieldValue.arrayUnion(newlyAddedWatchersIds)});
  }
}

Future removeWatchers(
    Watch watch, List<String> watchersIds, String userId) async {
  final watchId = watch.id;

  for (int i = 0; i < watchersIds.length; i++) {
    final watcherId = watchersIds[i];

    final watcherIndex =
        watch.watchers.indexWhere((element) => element.id == watcherId);
    if (watcherIndex != -1) {
      final watcher = watch.watchers[watcherIndex];
      watch.watchers.removeAt(watcherIndex);
      //startedAt: watcher.time, endedAt: timeNow
      final newWatch = watch.copyWith();
      newWatch.status = watcher.status == "invite"
          ? userId == myId
              ? "rejected"
              : "missed"
          : watcher.status == "request"
              ? userId == myId
                  ? "canceled"
                  : "declined"
              : "accepted";
      if (watcher.user != null && watcher.user!.id != myId) {
        sendWatchNotification(watcher.user!.token, newWatch);
      }

      await fm.setValue(["users", watcherId, "watchs", watchId],
          value: newWatch.toMap());
    }
    final currentWatchers =
        watch.watchers.where((element) => element.status == "current");

    if (currentWatchers.isEmpty) {
      await fm.removeValue(["watchs", watchId]);
    } else {
      await fm.removeValue(["watchs", watchId, "watchers", watcherId]);
    }
  }
}

Future sendWatchNotification(String token, Watch watch) async {
  return sendPushNotification(token,
      notificationType: "watch", title: "Match", body: "", data: watch.toMap());
}

// Future updateWatchJoinPrivacy(Watch watch, String privacy) async {
//   if (watch.joinPrivacy == privacy) return;

//   return fm.updateValue(["watchs", watch.id], value: {"joinPrivacy": privacy});
// }

// Future updateWatchPrivacy(Watch watch, String privacy) async {
//   if (watch.invitePrivacy == privacy) return;

//   return fm
//       .updateValue(["watchs", watch.id], value: {"invitePrivacy": privacy});
// }

Future requestToJoinWatch(Watch watch) async {
  return addWatchers(watch, [], [myId], watch.callMode, true);
}

Future acceptOrJoinWatch(Watch watch, String? userId, String callMode) async {
  userId ??= myId;
  return addWatchers(watch, [], [userId], callMode);
}

Future rejectOrLeaveWatch(Watch watch, [String? userId]) async {
  userId ??= myId;

  return removeWatchers(watch, [userId], myId);
}

Future<Watcher?> getWatcher(String watchId, String userId) async {
  return fm.getValue(
      (map) => Watcher.fromMap(map), ["watchs", watchId, "watchers", userId]);
}

Stream<Watcher?> streamWatcher(String watchId, String userId) async* {
  yield* fm.getValueStream(
      (map) => Watcher.fromMap(map), ["watchs", watchId, "watchers", userId]);
}

Future<List<Watcher>> readWatchers(String watchId) async {
  return fm.getValues(
      (map) => Watcher.fromMap(map), ["watchs", watchId, "watchers"]);
}

Stream<List<Watcher>> streamWatchers(String watchId) async* {
  yield* fm.getValuesStream(
      (map) => Watcher.fromMap(map), ["watchs", watchId, "watchers"]);
}

Stream<List<ValueChange<Watcher>>> streamChangeWatchers(String watchId) async* {
  yield* fm.getValuesChangeStream(
      (map) => Watcher.fromMap(map), ["watchs", watchId, "watchers"],
      order: ["time"], where: ["id", "!=", myId]);
}

// Stream<List<WatchedMatch>> streamWatchedMatch() async* {
//   yield* fm.getValuesStream(
//       (map) => WatchedMatch.fromMap(map), ["users", myId, "watch_history"]);
// }

// Future<List<Watched>> readWatcheds(String? lastTime) async {
//   return fm.getValues(
//       (map) => Watched.fromMap(map), ["users", myId, "watch_history"],
//       order: ["createdAt"],
//       where: lastTime == null ? null : ["createdAt", ">", lastTime]);
// }

Stream<List<ValueChange<Watcher>>> streamChangeWatchWatchs(
    String? lastTime) async* {
  yield* fm.getValuesChangeStream(
      (map) => Watcher.fromMap(map), ["users", myId, "watchs"],
      order: ["createdAt"],
      where: lastTime == null ? null : ["createdAt", ">", lastTime]);
}

// Future<Watch?> getUserWatch(String userId) async {
//   final user = await fm.getValue((map) => User.fromMap(map), ["users", userId]);
//   if (user?.currentWatch != null) {
//     return getWatch(user!.currentWatch!);
//   } else {
//     return null;
//   }
// }

Stream<Watch?> streamWatch(String watchId) async* {
  yield* fm.getValueStream((map) => Watch.fromMap(map), ["watchs", watchId]);
}

Future<Watch?> getWatch(String watchId) async {
  return fm.getValue((map) => Watch.fromMap(map), ["watchs", watchId]);
}

Future updateWatch(String watchId, Map<String, dynamic> value) async {
  return fm.updateValue(["watchs", watchId], value: value);
}

Future removeWatch(String watchId) async {
  return fm.removeValue(["watchs", watchId]);
}

Future<User?> addWatcherUser(List<Watcher> watchers, String creatorId) async {
  User? creatorUser;
  for (int i = 0; i < watchers.length; i++) {
    final watcher = watchers[i];
    final user = await getUser(watcher.id);
    watcher.user = user;
    if (creatorId.isNotEmpty && creatorId == watcher.id) {
      creatorUser = user;
    }
  }
  if (creatorId.isNotEmpty && creatorUser == null) {
    final user = await getUser(creatorId);
    creatorUser = user;
  }
  return creatorUser;
}

Future startCall(String watchId, String callMode) {
  return fm.updateValue([
    "watchs",
    watchId,
    "watchers",
    myId
  ], value: {
    "callMode": callMode,
    "isAudioOn": true,
    "isFrontCamera": true,
    "isOnHold": true,
    // "id": myId,
  });
}

Future endCall(String watchId) {
  return fm.updateValue([
    "watchs",
    watchId,
    "watchers",
    myId
  ], value: {
    "callMode": null,
    "isAudioOn": null,
    "isFrontCamera": null,
    "isOnHold": null
  });
}

Future updateCallMode(String watchId, String? callMode) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"callMode": callMode});
}

Future updateWatchSync(String watchId, String? userId) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"syncUserId": userId});
}

Future updateWatchPosition(String watchId, int? watchPosition) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"watchPosition": watchPosition});
}

Future updateWatchAction(String watchId, String action) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"action": action});
}

Future updateWatchMatch(String watchId, String match) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"match": match});
}

Future updateCallAudio(String watchId, bool isAudioOn) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"isAudioOn": isAudioOn});
}

Future updateCallHold(String watchId, bool isOnHold) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"isOnHold": isOnHold});
}

Future updateCallCamera(String watchId, bool isFrontCamera) {
  return fm.updateValue(["watchs", watchId, "watchers", myId],
      value: {"isFrontCamera": isFrontCamera});
}

Stream<List<ValueChange<Map<String, dynamic>>>> streamChangeSignals(
    String watchId) async* {
  yield* fm.getValuesChangeStream(
      (map) => map, ["watchs", watchId, "watchers", myId, "signal"]);
}

Future addSignal(
    String watchId, String userId, Map<String, dynamic> value) async {
  return fm.setValue(["watchs", watchId, "watchers", userId, "signal", myId],
      value: {...value, "id": myId});
}

Future removeSignal(String watchId, String userId) {
  return fm.removeValue(["watchs", watchId, "watchers", userId, "signal"]);
}

Future<List<Watch>> readWatchHistory(
    {String? lastTime, String? firstTime, int? limit, bool dsc = false}) {
  return fm.getValues((map) => Watch.fromMap(map), ["users", myId, "watchs"],
      start: lastTime == null ? [] : [lastTime, true],
      end: firstTime == null ? [] : [firstTime, true],
      order: ["modifiedAt", dsc],
      limit: limit == null ? [] : [limit, firstTime != null]);
}

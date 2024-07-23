import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/watch/models/watched_match.dart';
import 'package:watchball/features/watch/models/watcher.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/features/match/utils/match_utils.dart';

import '../../notification/models/notif.dart';
import '../../user/models/user.dart';
import '../models/watch.dart';
import '../models/watch_invite.dart';
import '../models/watched.dart';
import '../../../utils/utils.dart';

final FirestoreMethods firestoreMethods = FirestoreMethods();

Future<Watch?> createWatch(LiveMatch match) async {
  final watchId = firestoreMethods.getId(["watch"]);
  final matchId = match.id;
  //privacy options-nobody, invited, selected, anyone
  //watch
  //watcher
  //watched
  //final watched = Watched(id: myId, startTime: time, endTime: "");

  final watch = Watch(
    id: watchId,
    match: match,
    creatorId: myId,
    joinPrivacy: "invited",
    invitePrivacy: "everyone",
    // startTime: time,
    // endTime: "",
    // watchers: [watcher],
    // watcheds: [watched]
  );

  await firestoreMethods.setValue(["watch", watchId], value: watch.toMap());
  final watcher = Watcher(id: myId, status: "current", time: timeNow);
  watch.watchers.add(watcher);

  await firestoreMethods
      .setValue(["watch", watchId, "watchers", myId], value: watcher.toMap());

  // await firestoreMethods
  //     .setValue(["watch", watchId, "watchers", myId], value: watcher.toMap());

  // final watchedTime = DateTime.now().millisecondsSinceEpoch.toString();
  // await firestoreMethods
  //     .setValue(["watch", watchId, "watched", myId], value: watched.toMap());

  //user watch
  await firestoreMethods
      .updateValue(["users", myId], value: {"currentWatch": watch.id});
  // watch.watchers.add(watcher);

  //user watcheds
  final watched = Watched(
      watchId: watchId,
      userId: myId,
      watchedUserIds: myId,
      matchId: matchId,
      match: getMatchString(match),
      createdAt: timeNow,
      endedAt: "");
  await firestoreMethods
      .setValue(["users", myId, "watcheds", watchId], value: watched.toMap());
  // final result = await firestoreMethods
  //     .getValue((map) => map, ["users", myId, "watcheds", matchId]);
  // if (result == null) {
  //   await firestoreMethods.setValue(
  //     ["users", myId, "watcheds", matchId],
  //     value: WatchedMatch(
  //         matchId: matchId,
  //         league: match.league,
  //         date: match.date,
  //         time: time,
  //         homeName: match.homeName,
  //         homeLogo: match.homeLogo,
  //         awayName: match.awayName,
  //         awayLogo: match.awayLogo,
  //         watchIds: [watchId]).toMap(),
  //   );
  // } else {
  //   await firestoreMethods.updateValue([
  //     "users",
  //     myId,
  //     "watcheds",
  //     matchId
  //   ], value: {
  //     "watchIds": FieldValue.arrayUnion([watchId])
  //   });
  // }
  return watch;
}

Future updateWatchJoinPrivacy(Watch watch, String privacy) async {
  if (watch.joinPrivacy == privacy) return;

  return firestoreMethods
      .updateValue(["watch", watch.id], value: {"joinPrivacy": privacy});
}

Future updateWatchInvitePrivacy(Watch watch, String privacy) async {
  if (watch.invitePrivacy == privacy) return;

  return firestoreMethods
      .updateValue(["watch", watch.id], value: {"invitePrivacy": privacy});
}

Future<List<Watch>> findWatchsToJoin(List<User> users) async {
  List<Watch> watches = [];
  // for (int i = 0; i < users.length; i++) {
  //   final user = users[i];
  //   //final watch = await getUserWatch(user.id);
  //   final currentWatch = user.currentWatch;
  //   if (currentWatch != null) {
  //     final watch = await getWatch(currentWatch);
  //     if (watch != null &&
  //         watch.creatorId == user.id &&
  //         watch.joinPrivacy != "invited") {
  //       // final watchers = await getWatchers(watch.id);
  //       // watch.watchers = watchers;
  //       watches.add(watch);
  //     }
  //   }
  // }
  return watches;
}

//<List<Watcher>>
Future<List<WatchInvite>> inviteWatchers(Watch watch, List<User> users) async {
  List<WatchInvite> watchInvites = [];
  final watchId = watch.id;
  // final match = watch.match;
  //final time = DateTime.now().millisecondsSinceEpoch.toString();
  final inviteUserIds = users.map((user) => user.id).toList();
  //final matchName = "${watch.match.homeName} vs ${watch.match.awayName}";
  final match = getMatchString(watch.match);
  final watchInvite = WatchInvite(
      matchId: watch.match.id,
      watchId: watchId,
      userId: myId,
      invitedUserIds: inviteUserIds.join(","),
      match: match,
      createdAt: timeNow,
      status: "request");
  //watchInvites.add(watchInvite);
  for (int i = 0; i < users.length; i++) {
    final user = users[i];
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final watcher = Watcher(id: user.id, time: time, status: "invite");
    await firestoreMethods.setValue(["watch", watchId, "watchers", user.id],
        value: watcher.toMap());
    // await firestoreMethods.updateValue([
    //   "watch",
    //   watchId
    // ], value: {
    //   "watchers": FieldValue.arrayUnion([watcher.toMap()])
    // });
    // await firestoreMethods.setValue(["watch", watchId, "watchers", user.id],
    //     value: watcher.toMap());
    // await firestoreMethods.updateValue([
    //   "users",
    //   user.id
    // ], value: {
    //   "invitedWatchs": FieldValue.arrayUnion([watchInvite.toMap()])
    // });

    await firestoreMethods.setValue(
      [
        "users",
        user.id,
        "invites",
        watchId,
      ],
      value: watchInvite.toMap(),
    );

    // String message =
    //     "is inviting you${users.length == 1 ? "" : " and ${users.length - 1} others"} to watch the match between ${match.homeName} and ${match.awayName}";
    // final notifId = firestoreMethods.getId(["users", user.id, "notifications"]);
    // final notif = Notif(
    //   notifId: notifId,
    //   id: watchId,
    //   userId: myId,
    //   type: "invite",
    //   message: message,
    //   time: time,
    //   seen: false,
    // );
    // await firestoreMethods.setValue(
    //   ["users", user.id, "notifications", notifId],
    //   value: notif.toMap(),
    // );
  }
  // await firestoreMethods.setValue(
  //   [
  //     "users",
  //     myId,
  //     "invites",
  //     watchId,
  //   ],
  //   value: watchInvite.toMap(),
  // );
  return watchInvites;
}

// Future removeWatchers(String watchId, List<User> users) async {
//   for (int i = 0; i < users.length; i++) {
//     final user = users[i];
//     await firestoreMethods.removeValue(
//       ["watch", watchId, "watchers", user.id],
//     );
//     await firestoreMethods
//         .updateValue(["users", user.id], value: {"watch": null});
//   }
// }

Future requestToJoinWatch(Watch watch) async {
  String watchId = watch.id;
  // final watchers = watch.watchers;
  // final match = watch.match;
  // final time = DateTime.now().millisecondsSinceEpoch.toString();

  final watcher = Watcher(id: myId, time: timeNow, status: "request");

  await firestoreMethods
      .setValue(["watch", watchId, "watchers", myId], value: watcher.toMap());
  // await firestoreMethods.updateValue([
  //   "watch",
  //   watchId
  // ], value: {
  //   "watchers": FieldValue.arrayUnion([watcher.toMap()])
  // });
  // await firestoreMethods
  //     .setValue(["watch", watchId, "watchers", myId], value: watcher.toMap());
  // await firestoreMethods
  //     .updateValue(["users", myId], value: {"requestedWatch": watch.id});
}

//Watch? currentWatch,
Future acceptOrJoinWatch(Watch watch, String? userId) async {
  final watchId = watch.id;
  userId ??= myId;

  final match = watch.match;
  final matchId = match.id;

  List<Watcher> currentWatchers = [];
  List<Watcher> currentAndLeftWatchers = [];

  String status = "";

  for (int i = 0; i < watch.watchers.length; i++) {
    final watcher = watch.watchers[i];
    if (watcher.id == userId) {
      status = watcher.status;
    }

    if (watcher.status == "current") {
      currentWatchers.add(watcher);
    }
    if (watcher.status == "current" || watcher.status == "left") {
      currentAndLeftWatchers.add(watcher);
    }
  }
  // if (userId != myId && currentWatch == null) {
  //   final currentUser = await firestoreMethods
  //       .getValue((map) => User.fromMap(map), ["users", userId]);
  //   final watchId = currentUser?.currentWatch;
  //   if (watchId != null) {
  //     currentWatch = await getWatch(watchId);
  //   }
  // }

  // if (currentWatch != null) {
  //   await rejectOrLeaveWatch(currentWatch, isRequest, userId: userId);
  // }

  //final time = DateTime.now().millisecondsSinceEpoch.toString();

  //watcher
  // final prevWatcher =
  //     watch.watchers.firstWhere((watcher) => watcher.id == userId);

  bool isRequest = status.isEmpty || status == "request";
  if (status == "invite") {
    await firestoreMethods.updateValue(["users", userId, "invites", watchId],
        value: {"status": "accept"});
  }

  final watcher = Watcher(id: userId, time: timeNow, status: "current");
  await firestoreMethods
      .setValue(["watch", watchId, "watchers", userId], value: watcher.toMap());

  if (!isRequest) {
    await firestoreMethods
        .updateValue(["users", userId], value: {"currentWatch": watchId});
  }

  final watched = Watched(
    watchId: watchId,
    userId: userId,
    watchedUserIds: currentAndLeftWatchers
        .map((watcher) => watcher.id)
        .join(",")
        .toString(),
    matchId: matchId,
    match: getMatchString(match),
    createdAt: timeNow,
    endedAt: "",
  );

  await firestoreMethods
      .setValue(["users", myId, "watcheds", watchId], value: watched.toMap());

  // final result = await firestoreMethods
  //     .getValue((map) => map, ["users", myId, "watcheds", matchId]);
  // if (result == null) {
  //   await firestoreMethods.setValue(
  //     ["users", myId, "watcheds", matchId],
  //     value: WatchedMatch(
  //         matchId: matchId,
  //         league: match.league,
  //         date: match.date,
  //         time: time,
  //         homeName: match.homeName,
  //         homeLogo: match.homeLogo,
  //         awayName: match.awayName,
  //         awayLogo: match.awayLogo,
  //         watchIds: [watchId]).toMap(),
  //   );
  // } else {
  //   await firestoreMethods.updateValue([
  //     "users",
  //     myId,
  //     "watcheds",
  //     matchId
  //   ], value: {
  //     "watchIds": FieldValue.arrayUnion([watchId])
  //   });
  // }
}

Future rejectOrLeaveWatch(Watch watch, String? userId) async {
  final watchId = watch.id;
  userId ??= myId;

  //watcher
  // Watcher? prevWatcher;
  //Watched? prevWatched;

  List<Watcher> currentWatchers = [];
  List<Watcher> invitedWatchers = [];
  List<Watcher> requestedWatchers = [];
  List<Watcher> currentAndLeftWatchers = [];

  String status = "";

  for (int i = 0; i < watch.watchers.length; i++) {
    final watcher = watch.watchers[i];
    if (watcher.id == userId) {
      status = watcher.status;
    }

    if (watcher.status == "current") {
      currentWatchers.add(watcher);
      currentAndLeftWatchers.add(watcher);
      if (watcher.id == userId) {
        removeSignal(watchId, userId);
        //prevWatcher = watcher;
      }
    } else if (watcher.status == "left") {
      currentAndLeftWatchers.add(watcher);
    } else if (watcher.status == "invite") {
      invitedWatchers.add(watcher);
    } else {
      requestedWatchers.add(watcher);
    }
  }
  // for (int i = 0; i < watch.watcheds.length; i++) {
  //   final watched = watch.watcheds[i];
  //   if (watched.id == userId) {
  //     prevWatched = watched;
  //   }
  // }

  // if (prevWatcher != null) {
  //   await firestoreMethods.updateValue([
  //     "watch",
  //     watchId
  //   ], value: {
  //     "watchers": FieldValue.arrayRemove([prevWatcher.toMap()]),
  //   });
  // }
  bool isRequest = status.isEmpty || status == "request";

  if (status == "invite") {
    await firestoreMethods.updateValue(["users", userId, "invites", watchId],
        value: {"status": userId == myId ? "reject" : "cancel"});
  }

  if (status == "current") {
    await firestoreMethods.updateValue([
      "users",
      myId,
      "watcheds",
      watchId
    ], value: {
      "endedAt": timeNow,
      "watchedUserIds": currentAndLeftWatchers
          .map((watcher) => watcher.id)
          .join(",")
          .toString()
    });
    // if (currentWatchers.length == 1) {
    //   await firestoreMethods.removeValue(["watch", watchId]);
    // }
    await firestoreMethods.updateValue(["watch", watchId, "watchers", userId],
        value: {"status": "left", "time": timeNow});
  } else {
    await firestoreMethods.removeValue(
      ["watch", watchId, "watchers", userId],
    );
  }
  if (userId == myId) {
    if (watch.creatorId == userId) {
      await firestoreMethods
          .updateValue(["users", userId], value: {"currentWatch": null});
    } else {
      //await createWatch(watch.match);
    }
  }

  // bool isCurrent = prevWatcher.status == "current";
  // final watcherIndex =
  //     watch.watchers.indexWhere((watcher) => watcher.id == userId);
  // if (watcherIndex != -1 && watch.watchers[watcherIndex].status == "current") {
  //   isCurrent = true;
  // }
  // final currentWatchers =
  //     watch.watchers.where((watcher) => watcher.status == "current");

  // if (prevWatched != null) {
  //   final endTime = DateTime.now().millisecondsSinceEpoch.toString();

  //   await firestoreMethods.updateValue([
  //     "watch",
  //     watchId
  //   ], value: {
  //     "watcheds": FieldValue.arrayRemove([prevWatched.toMap()]),
  //   });

  //   await firestoreMethods.updateValue([
  //     "watch",
  //     watchId
  //   ], value: {
  //     "watcheds": FieldValue.arrayUnion(
  //         [prevWatched.copyWith(endTime: endTime).toMap()]),
  //   });

  // await firestoreMethods.updateValue(["watch", watchId, "watched", myId],
  //     value: {"endTime": endTime});
  // await removeSignal(watchId, userId);
  //}
  // if (currentWatchers.length <= 1) {
  //   final endTime = DateTime.now().millisecondsSinceEpoch.toString();

  //   await firestoreMethods
  //       .updateValue(["watch", watchId], value: {"endTime": endTime});
  // }
  // if (watchInvite == null && userId != myId) {
  //   final user = await firestoreMethods
  //       .getValue((map) => User.fromMap(map), ["users", userId]);
  //   if (user?.invitedWatchs != null) {
  //     final inviteIndex = user!.invitedWatchs!
  //         .indexWhere((invite) => invite.watchId == watchId);
  //     if (inviteIndex != -1) {
  //       watchInvite = user.invitedWatchs![inviteIndex];
  //     }
  //   }
  // }

  // if (watchInvite == null) {
  //   await firestoreMethods
  //       .updateValue(["users", userId], value: {"requestedWatch": null});
  // } else {
  //   await firestoreMethods.updateValue([
  //     "users",
  //     userId
  //   ], value: {
  //     "invitedWatchs": FieldValue.arrayRemove([watchInvite])
  //   });
  // }

  // if (watchInvite == null) {
  //   await firestoreMethods
  //       .updateValue(["users", userId], value: {"requestedWatch": null});
  // } else {
  //   await firestoreMethods.updateValue([
  //     "users",
  //     userId
  //   ], value: {
  //     "invitedWatchs": FieldValue.arrayRemove([watchInvite.toMap()])
  //   });
  // }
  if (currentWatchers.length <= 1) {
    for (int i = 0; i < invitedWatchers.length; i++) {
      final watcher = invitedWatchers[i];
      await firestoreMethods.updateValue(
          ["users", watcher.id, "invites", watchId],
          value: {"status": "cancel"});
    }
    await firestoreMethods.removeValue(["watch", watchId]);
    // await firestoreMethods
    //     .updateValue(["watch", watchId], value: {"watchers": []});
  } else {}
}

Future removeSignal(String watchId, String userId) {
  return firestoreMethods.removeValue(
    ["watch", watchId, "signal", userId],
  );
}

Future updateSignal(String watchId, String userId, Map<String, dynamic> value) {
  return firestoreMethods
      .updateValue(["watch", watchId, "signal", userId], value: value);
}

Future addSignal(String watchId, String userId, Map<String, dynamic> value) {
  return firestoreMethods.setValue(["watch", watchId, "signal", userId],
      value: value, merge: true);
}

Stream<List<ValueChange<Map<String, dynamic>>>> streamChangeSignals(
    String watchId) async* {
  yield* firestoreMethods
      .getValuesChangeStream((map) => map, ["watch", watchId, "signal"]);
}

Future removeUserWatch() async {
  await firestoreMethods.updateValue(["users", myId], value: {"watch": null});
}

Future<List<WatchInvite>> readWatchInvites(String watchId) async {
  return firestoreMethods
      .getValues((map) => WatchInvite.fromMap(map), ["users", myId, "invites"]);
}

// Future<List<Watched>> readWatcheds(String watchId) async {
//   return firestoreMethods
//       .getValues((map) => Watched.fromMap(map), ["users", watchId, "watcheds"]);
// }

Stream<Watcher?> streamWatcher(String watchId, String userId) async* {
  yield* firestoreMethods.getValueStream(
      (map) => Watcher.fromMap(map), ["watch", watchId, "watchers", userId]);
}

Future<List<Watcher>> readWatchers(String watchId) async {
  return firestoreMethods
      .getValues((map) => Watcher.fromMap(map), ["watch", watchId, "watchers"]);
}

Stream<List<Watcher>> streamWatchers(String watchId) async* {
  yield* firestoreMethods.getValuesStream(
      (map) => Watcher.fromMap(map), ["watch", watchId, "watchers"]);
}

Stream<List<ValueChange<Watcher>>> streamChangeWatchers(String watchId) async* {
  yield* firestoreMethods.getValuesChangeStream(
      (map) => Watcher.fromMap(map), ["watch", watchId, "watchers"],
      order: ["time"]);
}

Stream<List<WatchedMatch>> streamWatchedMatch() async* {
  yield* firestoreMethods.getValuesStream(
      (map) => WatchedMatch.fromMap(map), ["users", myId, "watcheds"]);
}

Future<List<Watched>> readWatcheds(String? lastTime) async {
  return firestoreMethods.getValues(
      (map) => Watched.fromMap(map), ["users", myId, "watcheds"],
      order: ["createdAt"],
      where: lastTime == null ? null : ["createdAt", ">", lastTime]);
}

Stream<List<ValueChange<Watcher>>> streamChangeWatchInvites(
    String? lastTime) async* {
  yield* firestoreMethods.getValuesChangeStream(
      (map) => Watcher.fromMap(map), ["users", myId, "invites"],
      order: ["createdAt"],
      where: lastTime == null ? null : ["createdAt", ">", lastTime]);
}

Future<Watch?> getUserWatch(String userId) async {
  final user = await firestoreMethods
      .getValue((map) => User.fromMap(map), ["users", userId]);
  if (user?.currentWatch != null) {
    return getWatch(user!.currentWatch!);
  } else {
    return null;
  }
}

Stream<Watch?> streamWatch(String watchId) async* {
  yield* firestoreMethods
      .getValueStream((map) => Watch.fromMap(map), ["watch", watchId]);
}

Future<Watch?> getWatch(String watchId) async {
  return firestoreMethods
      .getValue((map) => Watch.fromMap(map), ["watch", watchId]);
}

Future updateWatch(String watchId, Map<String, dynamic> value) async {
  return firestoreMethods.updateValue(["watch", watchId], value: value);
}

Future removeWatch(String watchId) async {
  return firestoreMethods.removeValue(["watch", watchId]);
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

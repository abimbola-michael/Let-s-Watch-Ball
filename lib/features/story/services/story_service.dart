import 'package:watchball/features/message/models/message.dart';
import 'package:watchball/shared/models/stat.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/features/message/services/message_service.dart';
import 'package:watchball/utils/utils.dart';

import '../../match/models/live_match.dart';
import '../models/story.dart';
import '../../match/utils/match_utils.dart';

final FirestoreMethods firestoreMethods = FirestoreMethods();

Future<Story> createStory(LiveMatch? match, String text, String color,
    String thumb, String url, String type) async {
  final time = DateTime.now().millisecondsSinceEpoch.toString();
  final timeEnd =
      (DateTime.now().millisecondsSinceEpoch + (24 * 60 * 60)).toString();
  final id = firestoreMethods.getId(["users", myId, "stories"]);
  final matchString = getMatchString(match);
  final matchId = match?.id ?? "";

  final status = Story(
    id: id,
    match: matchString,
    matchId: matchId,
    userId: myId,
    text: text,
    color: color,
    url: url,
    thumb: thumb,
    type: type,
    createdAt: time,
    modifiedAt: time,
    endAt: timeEnd,
    viewsCount: 0,
  );

  await firestoreMethods
      .setValue(["users", myId, "stories", id], value: status.toMap());
  return status;
}

// Future addMessage(
//     String storyId, String userId, LiveMatch? match, String text, String time) {
//   final matchString = getMatchString(match);
//   final replyMessage = Message(
//       id: storyId,
//       receiverId: userId,
//       matchId: match?.id ?? "",
//       match: matchString,
//       userId: myId,
//       message: text,
//       status: "seen",
//       createdAt: time,
//       modifiedAt: time);
//   return createMessage(match, userId, text, replyMessage, (message) {});
// }

Future addView(String storyId) {
  final stat = Stat(id: myId, time: timeNow);
  return firestoreMethods.setValue(["users", myId, "stories", storyId, "views"],
      value: stat.toMap());
}

// Future addLike(String storyId) {
//   final stat = Stat(id: myId, time: timeNow);
//   return firestoreMethods.setValue(["users", myId, "stories", storyId, "likes"],
//       value: stat.toMap());
// }

Future clearStories() {
  return firestoreMethods.removeValue(["users", myId, "stories"]);
}

Future<List<Story>> readAllStories(String userId) {
  return firestoreMethods
      .getValues((map) => Story.fromMap(map), ["users", userId, "stories"]);
}

Stream<List<Story>> streamStories(String userId) async* {
  yield* firestoreMethods.getValuesStream(
      (map) => Story.fromMap(map), ["users", userId, "stories"]);
}

Future deleteStaleStories() {
  return firestoreMethods
      .removeValue(["users", myId, "stories"], where: ["endAt", ">=", timeNow]);
}

Future<List<Story>> readDeletedStories() {
  return firestoreMethods.getValues(
      (map) => Story.fromMap(map), ["users", myId, "stories"],
      where: ["deletedAt", "!=", null]);
}

Future<List<Story>> readModifiedStories(String? lastTime) {
  return firestoreMethods.getValues((map) => Story.fromMap(map), [
    "users",
    myId,
    "stories"
  ], where: [
    "modifiedAt",
    "!=",
    null,
    if (lastTime != null) ...["modifiedAt", ">", lastTime]
  ]);
}

Stream<List<ValueChange<Story>>> streamChangeStories(
    List<String> contactIds, String? lastTime) async* {
  yield* firestoreMethods.getValuesChangeStream(
    (map) => Story.fromMap(map),
    ["stories"],
    order: ["modifiedAt"],
    where: [
      "userId",
      "in",
      contactIds,
      "endAt",
      "<",
      timeNow,
      if (lastTime != null) ...["modifiedAt", ">", lastTime]
    ],
    isSubcollection: true,
  );
}

// Stream<List<ValueChange<Story>>> streamChangeStories(
//     List<String> contactIds, String? lastTime) async* {
//   yield* firestoreMethods.getValuesChangeStream(
//     (map) => Story.fromMap(map),
//     ["stories"],
//     order: ["createdAt"],
//     where: [
//       "userId",
//       "in",
//       contactIds,
//       "endAt",
//       "<",
//       timeNow,
//       if (lastTime != null) ...["createdAt", ">", lastTime]
//     ],
//     isSubcollection: true,
//   );
// }

Stream<Story?> streamStory(String userId, String statusId) async* {
  yield* firestoreMethods.getValueStream(
      (map) => Story.fromMap(map), ["users", userId, "stories", statusId]);
}

Future<Story?> getStory(String userId, String statusId) {
  return firestoreMethods.getValue(
      (map) => Story.fromMap(map), ["users", userId, "stories", statusId]);
}

Future updateStory(String statusId, Map<String, dynamic> value) {
  return firestoreMethods
      .updateValue(["users", myId, "stories", statusId], value: value);
}

Future removeStory(String statusId) {
  return firestoreMethods.removeValue(["users", myId, "stories", statusId]);
}

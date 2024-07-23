import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/features/message/utils/message_utils.dart';
import 'package:watchball/utils/utils.dart';

import '../../match/models/live_match.dart';
import '../models/chatlist.dart';
import '../models/message.dart';
import '../../../shared/models/stat.dart';
import '../../match/utils/match_utils.dart';

final FirestoreMethods firestoreMethods = FirestoreMethods();

Future<Message> createMessage(
    String match,
    String matchId,
    String userId,
    String text,
    Message? replyMessage,
    void Function(Message message) onGetMessage) async {
  //final time = DateTime.now().millisecondsSinceEpoch.toString();
  final id = firestoreMethods.getId(["users", myId, "messages"]);
  // final matchString = getMatchString(match);
  //final matchId = match?.id ?? "";
  final receiverId = getChatId(userId);
  final time = timeNow;

  final message = Message(
    id: id,
    receiverId: receiverId,
    matchId: matchId,
    match: match,
    userId: myId,
    message: text,
    createdAt: time,
    modifiedAt: time,
    replyId: replyMessage?.id,
    replyUserId: replyMessage?.userId,
    replyMessage: replyMessage?.message,
    status: "sent",
  );
  onGetMessage(message);

  await firestoreMethods
      .setValue(["chats", receiverId, "messages", id], value: message.toMap());

  // final stat = Stat(id: receiverId, time: timeNow);
  final chatlist = Chatlist(id: receiverId, createdAt: timeNow);
  await firestoreMethods.setValue(["users", myId, "chatlist", receiverId],
      value: chatlist.toMap());

  await firestoreMethods.setValue(["users", userId, "chatlist", receiverId],
      value: chatlist.toMap());
  // await firestoreMethods.setValue(["users", myId, "messages", id],
  //     value: message.copyWith(receiverId: receiverId).toMap());

  // await firestoreMethods.setValue(["users", receiverId, "people", myId],
  //     value: {...message.toMap(), "unread": FieldValue.increment(1)},
  //     merge: true);
  // await firestoreMethods.setValue(["users", receiverId, "matches", matchId],
  //     value: {...message.toMap(), "unread": FieldValue.increment(1)},
  //     merge: true);

  // await firestoreMethods.setValue(["users", myId, "people", receiverId],
  //     value: {...message.toMap(), "unread": FieldValue.increment(1)},
  //     merge: true);
  // await firestoreMethods.setValue(["users", myId, "matches", matchId],
  //     value: {...message.toMap(), "unread": FieldValue.increment(1)},
  //     merge: true);
  return message;
}

Future updateUserUnread(String userId) async {
  return firestoreMethods
      .updateValue(["users", myId, "people", userId], value: {"unread": 0});
}

Future updateMatchUnread(String matchId) async {
  return firestoreMethods
      .updateValue(["users", myId, "matches", matchId], value: {"unread": 0});
}

Future updateMessageRead(String messageId) async {
  return firestoreMethods.updateValue(["users", myId, "messages", messageId],
      value: {"status": "seen"});
}

Future clearMessages() {
  return firestoreMethods.removeValue(["users", myId, "messages"]);
}

Future clearUserMessages(String userId) async {
  await firestoreMethods.setValue(["users", myId, "people", userId], value: {});
  return firestoreMethods.removeValue(["users", myId, "messages"],
      where: ["receiverId", "==", userId]);
}

Future clearMatchMessages(String matchId) async {
  await firestoreMethods
      .setValue(["users", myId, "matches", matchId], value: {});
  //return firestoreMethods.removeValue(["users", myId, "messages", userId]);
}

Future<List<Message>> readUserMessages(String userId) {
  return firestoreMethods.getValues(
      (map) => Message.fromMap(map), ["users", userId, "messages"],
      where: ["userId", "==", myId]);
}

Stream<List<Message>> streamLastUserMessages() async* {
  yield* firestoreMethods.getValuesStream(
      (map) => Message.fromMap(map), ["users", myId, "people"]);
}

Stream<List<Message>> streamLastMatchMessages() async* {
  yield* firestoreMethods.getValuesStream(
      (map) => Message.fromMap(map), ["users", myId, "matches"]);
}

Stream<List<Message>> streamUserMessages(String userId) async* {
  yield* firestoreMethods.getValuesStream(
      (map) => Message.fromMap(map), ["users", myId, "messages"],
      where: ["receiverId", "==", userId]);
}

Stream<List<Message>> streamMatchMessages(String matchId) async* {
  yield* firestoreMethods.getValuesStream(
      (map) => Message.fromMap(map), ["users", myId, "messages"],
      where: ["matchId", "==", matchId]);
}

Stream<List<ValueChange<Chatlist>>> streamChangeChatlist(
    String? lastTime) async* {
  yield* firestoreMethods.getValuesChangeStream(
    (map) => Chatlist.fromMap(map),
    ["users", myId, "chatlist"],
    where: lastTime == null ? null : ["createdAt", ">", lastTime],
  );
}

Stream<List<ValueChange<Message>>> streamChangeMessages(
    List<String> receiverIds, String? lastTime) async* {
  yield* firestoreMethods.getValuesChangeStream(
    (map) => Message.fromMap(map),
    ["messages"],
    order: ["createdAt"],
    where: [
      "receiverId",
      "in",
      receiverIds,
      if (lastTime != null) ...["createdAt", ">", lastTime]
    ],
    isSubcollection: true,
  );
}

Stream<Message?> streamMessage(String messageId) async* {
  yield* firestoreMethods.getValueStream(
      (map) => Message.fromMap(map), ["users", myId, "messages", messageId]);
}

Future<Message?> getMessage(String messageId) {
  return firestoreMethods.getValue(
      (map) => Message.fromMap(map), ["users", myId, "messages", messageId]);
}

Future updateMessage(String messageId, Map<String, dynamic> value) {
  return firestoreMethods
      .updateValue(["users", myId, "messages", messageId], value: value);
}

Future removeMessage(String messageId) {
  return firestoreMethods.removeValue(["users", myId, "messages", messageId]);
}

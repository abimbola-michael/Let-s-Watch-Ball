import 'package:watchball/utils/utils.dart';

import '../models/message.dart';

String getReceiverId(String userId) {
  List<String> ids = [myId, userId];
  ids.sort();
  return ids.join("_");
}

String getUserId(String receiverId) {
  List<String> ids = receiverId.split("_");
  ids.remove(myId);
  return ids[0];
}

Map<String, Message> getGroupedUserMessages(List<Message> messages) {
  Map<String, Message> messageMap = {};
  for (int i = 0; i < messages.length; i++) {
    final message = messages[i];
    if (messageMap[message.receiverId] == null) {
      messageMap[message.receiverId] = message;
    }
    // if (message.userId != myId && messageMap[message.userId] == null) {
    //   messageMap[message.userId] = message;
    // }
    if (message.status == "sent" && message.userId != myId) {
      messageMap[message.receiverId]!.unread =
          (messageMap[message.receiverId]!.unread ?? 0) + 1;
    }
    messageMap[message.receiverId]!.messages.add(message);
  }
  return messageMap;
}

Map<String, Message> getGroupedMatchMessages(List<Message> messages) {
  Map<String, Message> messageMap = {};
  for (int i = 0; i < messages.length; i++) {
    final message = messages[i];
    if (messageMap[message.matchId] == null) {
      messageMap[message.matchId] = message;
    }
    if (message.status == "sent") {
      messageMap[message.receiverId]!.unread =
          (messageMap[message.receiverId]!.unread ?? 0) + 1;
    }
    messageMap[message.receiverId]!.messages.add(message);
  }
  return messageMap;
}

List<Message> getGroupedMessages(List<Message> messages,
    {required bool isMatch}) {
  List<Message> messages = [];
  Map<String, int> messageMap = {};
  for (int i = 0; i < messages.length; i++) {
    var message = messages[i];
    final id = isMatch ? message.matchId : message.receiverId;
    var index = messageMap[id];
    if (index == null) {
      index = messages.length;
      messageMap[id] = index;
      messages.add(message);
    } else {
      final prevMessage = messages[index];
      final prevMessages = prevMessage.messages;
      final unread = prevMessage.unread;
      final user = prevMessage.user;
      prevMessages.add(message);

      messages[index] = message;
      messages[index].unread = unread;
      messages[index].messages = prevMessages;
      messages[index].user = user;
    }
    message = messages[index];

    if (message.status == "sent") {
      message.unread = (message.unread ?? 0) + 1;
    }
  }
  return messages;
}

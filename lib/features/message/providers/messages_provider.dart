import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/message/models/message.dart';

class MessagesNotifier extends StateNotifier<List<Message>> {
  MessagesNotifier(super.state);

  void clearMessages(List<Message> messages) {
    state = [];
  }

  void setMessages(List<Message> messages) {
    state = messages;
  }

  void addMessage(Message message) {
    state = [...state, message];
  }

  void removeMessage(Message message) {
    state = state.where((prevMessage) => prevMessage.id != message.id).toList();
  }
}

final messagesProvider = StateNotifierProvider<MessagesNotifier, List<Message>>(
  (ref) {
    return MessagesNotifier([]);
  },
);

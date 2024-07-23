import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/message/models/message.dart';

import '../../../firebase/firestore_methods.dart';

class MessagesChangesNotifier
    extends StateNotifier<List<ValueChange<Message>>> {
  MessagesChangesNotifier(super.state);

  void setMessagesChanges(List<ValueChange<Message>> messagesChanges) {
    state = messagesChanges;
  }
}

final messagesChangesProvider =
    StateNotifierProvider<MessagesChangesNotifier, List<ValueChange<Message>>>(
  (ref) {
    return MessagesChangesNotifier([]);
  },
);

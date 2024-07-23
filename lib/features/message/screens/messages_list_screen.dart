import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/message/components/message_item.dart';
import 'package:watchball/features/message/models/message.dart';
import 'package:watchball/features/message/providers/messages_provider.dart';
import 'package:watchball/features/message/screens/message_screen.dart';
import 'package:watchball/features/message/utils/message_utils.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/views/empty_list_view.dart';
import '../components/last_message_item.dart';

class MessagesListScreen extends ConsumerStatefulWidget {
  final bool isMatch;
  final Message? selectedMessage;
  //final void Function(Message message)? onSelected;
  const MessagesListScreen({
    super.key,
    required this.isMatch,
    this.selectedMessage,
    // this.onSelected
  });

  @override
  ConsumerState<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends ConsumerState<MessagesListScreen> {
  bool loading = false;

  List<Message> messages = [];
  @override
  void initState() {
    super.initState();
  }

  void updateMessagePressed(Message message) {
    context.pushNamedTo(MessageScreen.route, args: {
      "isMatch": widget.isMatch,
      "match": message.match,
      "matchId": message.matchId,
      "receiverId": message.receiverId,
      "messages": message.messages,
    });
  }

  @override
  Widget build(BuildContext context) {
    final allMessages = ref.watch(messagesProvider);
    messages = getGroupedMessages(allMessages, isMatch: widget.isMatch);
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (messages.isEmpty) {
      return const EmptyListView(message: "No message");
    }
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return LastMessageItem(
          isMatch: widget.isMatch,
          message: message,
          onPressed: () => updateMessagePressed(message),
        );
      },
    );
  }
}

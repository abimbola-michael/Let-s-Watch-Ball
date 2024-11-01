import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/match/utils/match_utils.dart';
import 'package:watchball/features/message/components/photoorflag_widget.dart';
import 'package:watchball/features/user/models/user.dart';
import 'package:watchball/features/message/providers/messages_provider.dart';
import 'package:watchball/features/message/services/message_service.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/utils/extensions.dart';

import '../../match/models/match_info.dart';
import '../components/last_message_item.dart';
import '../components/message_item.dart';
import '../../../shared/components/app_appbar.dart';
import '../../../shared/components/app_container.dart';
import '../../../shared/components/button.dart';
import '../models/message.dart';
import '../../../theme/colors.dart';
import '../utils/message_utils.dart';

class MessageScreen extends ConsumerStatefulWidget {
  static const route = "/message";
  final String? userId;
  final String? receiverId;
  final String? match;
  final String? matchId;
  final bool? isMatch;
  final User? user;
  const MessageScreen({
    super.key,
    this.userId,
    this.receiverId,
    this.match,
    this.matchId,
    this.isMatch,
    this.user,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  List<Message> messages = [];
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Message? replyMessage;
  User? user;
  //LiveMatch? match;
  String userId = "";
  String receiverId = "";
  String match = "";
  String matchId = "";
  bool isMatch = false;
  Message? selectedMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // });

    match = widget.match ?? "";
    matchId = widget.matchId ?? "";
    userId = widget.userId ?? "";
    receiverId = widget.receiverId ?? "";
    isMatch = widget.isMatch ?? matchId.isNotEmpty;
    user = widget.user;
    getUserIdOrReceiverId();
    scrollToBottom();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.match == null && context.args != null) {
      match = context.args["match"] ?? "";
      matchId = context.args["matchId"] ?? "";
      userId = context.args["userId"] ?? "";
      receiverId = context.args["receiverId"] ?? "";
      isMatch = context.args["isMatch"] ?? matchId.isNotEmpty;

      // messages = context.args["messages"] ?? [];
      user = context.args["user"];
      getUserIdOrReceiverId();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void getUserIdOrReceiverId() {
    if (userId.isEmpty && receiverId.isNotEmpty) {
      userId = getUserId(receiverId);
    }
    if (receiverId.isEmpty && userId.isNotEmpty) {
      receiverId = getReceiverId(userId);
    }
  }

  Future getUserInfo() async {
    user = await getUser(userId);
    setState(() {});
  }

  void readMessages() {}

  void sendMessage() async {
    String text = _messageController.text;
    int index = messages.length;
    final sentMessage = await createMessage(
        match, matchId, receiverId, text, replyMessage, (message) {
      messages.add(message.copyWith(status: "sending"));
      setState(() {});
    });

    messages[index] = sentMessage;
    _messageController.clear();

    scrollToBottom();
    setState(() {});
  }

  void scrollToBottom() async {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.ease);
  }

  void toggleEmojiKeyboard() {}
  void viewMessages(Message message) {
    selectedMessage = message;
    setState(() {});
  }

  void toggleBackPressed() {
    if (selectedMessage != null) {
      selectedMessage = null;
      setState(() {});
    } else {
      context.pop();
    }
  }

  Widget getThumbWidget(double size, bool isMatch,
      {MatchInfo? info, String? photo, double borderWidth = 0}) {
    return AppContainer(
      width: size,
      height: size,
      isCircular: true,
      borderWidth: borderWidth,
      borderColor: tint,
      child: isMatch && info != null
          ? Column(
              children: [
                CachedNetworkImage(
                  imageUrl: info.homeLogo,
                  height: size / 2,
                  width: size,
                ),
                CachedNetworkImage(
                  imageUrl: info.awayLogo,
                  height: size / 2,
                  width: size,
                ),
              ],
            )
          : photo != null
              ? CachedNetworkImage(
                  imageUrl: photo,
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                )
              : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allMessages = ref.watch(messagesProvider);
    if (selectedMessage != null) {
      messages = allMessages
          .where((message) => isMatch
              ? message.matchId == matchId &&
                  message.receiverId == selectedMessage!.receiverId
              : message.receiverId == receiverId &&
                  message.matchId == selectedMessage!.matchId)
          .toList();
    } else {
      final mainMessages = allMessages
          .where((message) => isMatch
              ? message.matchId == matchId
              : message.receiverId == receiverId)
          .toList();
      messages = getGroupedMessages(mainMessages, isMatch: !isMatch);
    }
    final matchInfo = getMatchInfo(match);
    final selectedMatchInfo =
        selectedMessage != null ? getMatchInfo(selectedMessage!.match) : null;

    return PopScope(
      canPop: selectedMessage == null,
      onPopInvoked: (pop) {
        toggleBackPressed();
      },
      child: Scaffold(
        appBar: AppAppBar(
          centered: false,
          title:
              isMatch ? getMatchTitle(matchInfo) : user?.name ?? "Select User",
          subtitle: !isMatch && selectedMatchInfo != null
              ? getMatchTitle(selectedMatchInfo)
              : user?.name ?? "Select Match",
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              PhotoOrFlagWidget(
                  size: 50,
                  isMatch: isMatch,
                  info: matchInfo,
                  photo: user?.photo),
              if (selectedMessage != null)
                PhotoOrFlagWidget(
                    size: 20,
                    isMatch: !isMatch,
                    info: selectedMatchInfo,
                    photo: user?.photo,
                    borderWidth: 2),
            ],
          ),
          onBackPressed: toggleBackPressed,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    if (selectedMessage != null) {
                      return MessageItem(message: message);
                    }
                    return LastMessageItem(
                      isMatch: isMatch,
                      message: message,
                      onPressed: () => viewMessages(message),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: selectedMessage == null
            ? null
            : AppContainer(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: toggleEmojiKeyboard,
                        icon: const Icon(OctIcons.smiley)),
                    Expanded(
                      child: TextField(
                        maxLines: 4,
                        minLines: 1,
                        controller: _messageController,
                        style: context.bodySmall,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          hintText: "Write your message...",
                          hintStyle: context.bodySmall
                              ?.copyWith(color: const Color(0xFF4F4E53)),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    if (_messageController.text.isNotEmpty) ...[
                      const SizedBox(
                        width: 10,
                      ),
                      Button(
                        width: 38,
                        height: 38,
                        isCircular: true,
                        color: primaryColor,
                        onPressed: sendMessage,
                        child: const Icon(
                          EvaIcons.paper_plane_outline,
                          color: white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ]
                  ],
                ),
              ),
      ),
    );
  }
}

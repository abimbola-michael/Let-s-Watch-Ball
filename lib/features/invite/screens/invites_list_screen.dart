import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/features/watch/screens/watch_match_request_screen.dart';
import 'package:watchball/utils/extensions.dart';

import '../components/watch_invite_item.dart';
import '../../watch/models/watch_invite.dart';
import '../../watch/screens/watch_match_screen.dart';

class InvitesListScreen extends StatefulWidget {
  final List<WatchInvite> invites;
  final bool isAwaiting;
  const InvitesListScreen(
      {super.key, required this.invites, required this.isAwaiting});

  @override
  State<InvitesListScreen> createState() => _InvitesListScreenState();
}

class _InvitesListScreenState extends State<InvitesListScreen> {
  void viewRequest(BuildContext context, WatchInvite invite) async {
    final result = await context
        .pushNamedTo(WatchMatchRequestScreen.route, args: {"invite": invite});
    if (result != null) {
      if (!context.mounted) return;
      context.pushNamedTo(WatchMatchScreen.route,
          args: {"match": (result as Watch?)?.match});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.invites.length,
      itemBuilder: (context, index) {
        final invite = widget.invites[index];
        return WatchInviteItem(
          invite: invite,
          onViewInvite: () => viewRequest(context, invite),
        );
      },
    );
  }
}

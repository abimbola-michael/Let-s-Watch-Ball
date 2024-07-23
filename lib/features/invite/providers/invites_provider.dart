import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watchball/features/watch/models/watch_invite.dart';

import '../../user/models/user.dart';

class InvitesNotifier extends StateNotifier<List<WatchInvite>> {
  InvitesNotifier(super.state);

  void clearWatchInvites(List<WatchInvite> invites) {
    state = [];
  }

  void setWatchInvites(List<WatchInvite> invites) {
    state = invites;
  }

  void addWatchInvite(WatchInvite invite) {
    state = [...state, invite];
  }

  void removeWatchInvite(WatchInvite invite) {
    state = state
        .where((prevInvite) => prevInvite.watchId != invite.watchId)
        .toList();
  }
}

final invitesProvider =
    StateNotifierProvider<InvitesNotifier, List<WatchInvite>>(
  (ref) {
    return InvitesNotifier([]);
  },
);

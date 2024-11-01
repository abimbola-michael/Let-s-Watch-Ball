import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import '../models/watch.dart';

class PlayerController {
  //BetterPlayerController? betterPlayerController;
  Player? desktopPlayer;
  VlcPlayerController? vlcPlayerController;
}

class PlayerNotifier extends StateNotifier<PlayerController> {
  PlayerNotifier(super.state);

  void updateVlcPlayerController(VlcPlayerController? vlcPlayerController) {
    state.vlcPlayerController = vlcPlayerController;
  }

  void updateDesktopPlayer(Player? desktopPlayer) {
    state.desktopPlayer = desktopPlayer;
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerController>(
  (ref) {
    return PlayerNotifier(PlayerController());
  },
);

import 'dart:async';
import 'package:cached_chewie_plus/cached_chewie_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
//import 'package:video_player_win/video_player_win.dart';
import 'package:watchball/features/match/components/live_match_item.dart';
import 'package:watchball/shared/components/app_alert_dialog.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/shared/components/app_back_button.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/features/watch/providers/requested_watch_provider.dart';
import 'package:watchball/features/watch/providers/watch_provider.dart';
import 'package:watchball/features/watch/screens/join_watch_screen.dart';
import 'package:watchball/features/watch/screens/invite_watchers_screen.dart';
import 'package:watchball/features/watch/screens/watchers_list_screen.dart';
import 'package:watchball/features/watch/services/live_stream_service.dart';
import 'package:watchball/features/user/services/user_service.dart';
import 'package:watchball/features/watch/services/watch_service.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/features/user/mocks/users.dart';

import '../../match/components/odds_item.dart';
import '../components/watcher_heading.dart';
import '../../../shared/models/list_change.dart';
import '../../user/models/user.dart';
import '../models/watch.dart';
import '../models/watch_invite.dart';
import '../models/watcher.dart';
import '../../user/providers/user_provider.dart';
import '../../../firebase/firestore_methods.dart';
import '../../../utils/utils.dart';

class WatchersScreen extends ConsumerStatefulWidget {
  static const route = "/watchers";

  const WatchersScreen({super.key});

  @override
  ConsumerState<WatchersScreen> createState() => _WatchersScreenState();
}

class _WatchersScreenState extends ConsumerState<WatchersScreen> {
  List<Watcher> watchers = [];
  List<Watcher> currentWatchers = [];
  List<Watcher> requestedWatchers = [];
  List<Watcher> invitedWatchers = [];
  String mode = "users";
  String view = "grid";
  bool muted = true;
  bool video = true;
  bool loading = true;
  bool loadingMatch = true;

  LiveMatch? match;

  String watchLink = "";

  bool isFirstTime = true;
  StreamSubscription? watcherSub;
  StreamSubscription? watchersSub;

  bool isCreator = false;
  User? actionUser, creatorUser;

  Watch? currentWatch;
  Watch? requestedWatch;

  String? currentWatchId;
  String? requestedWatchId;
  List<WatchInvite>? invitedWatchs;
  String joinPrivacy = "";
  String invitePrivacy = "";
  Map<String, User?> watcherUserMap = {};
  bool canPop = false;

  //Call

  // List<Watcher> callWatchers = [];
  // final _localRTCVideoRenderer = RTCVideoRenderer();
  // final Map<String, RTCVideoRenderer> _remoteRTCVideoRenderers = {};
  // MediaStream? _localStream;
  // final Map<String, RTCPeerConnection> _peerConnections = {};
  // final Map<String, List<RTCIceCandidate>> _rtcIceCandidates = {};

  StreamSubscription? signalSub;
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
  RTCVideoRenderer? _localRenderer;
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, RTCPeerConnection> _peerConnections = {};
  //final Map<String, List<RTCIceCandidate>> _rtcIceCandidates = {};
  MediaStream? _localStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initForCall();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // if (isFirstTime) {
    //   currentWatch = context.args["watch"];
    //   if (currentWatch != null) {
    //     currentWatchId = currentWatch!.id;
    //     listenForWatch();
    //     // match = watch!.match;
    //     // watchLink = "watchball.hms.com/${watch!.id}";
    //     // readWatchers();
    //   } else {
    //     match = context.args["match"];
    //     createNewWatch();
    //   }
    //   //getStreamLink();
    //   isFirstTime = false;
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    watchersSub?.cancel();
    watcherSub?.cancel();
    disposeForCall();
    super.dispose();
  }

  void disposeForCall() {
    signalSub?.cancel();
    _localRenderer?.dispose();
    for (var renderer in _remoteRenderers.values) {
      renderer.dispose();
    }
    for (var pc in _peerConnections.values) {
      pc.dispose();
    }
    _localStream?.dispose();

    _remoteRenderers.clear();
    _peerConnections.clear();
    signalSub = null;
    _localStream = null;
    _localRenderer = null;
  }

  void _disposeForUser(String peerId) {
    _remoteRenderers[peerId]?.dispose();
    _peerConnections[peerId]?.dispose();
    _remoteRenderers.remove(peerId);
    _peerConnections.remove(peerId);

    if (_peerConnections.isEmpty) {
      signalSub?.cancel();
      _localRenderer?.dispose();
      _localStream?.dispose();
      signalSub = null;
      _localStream = null;
      _localRenderer = null;
    }
  }

  Future initForCall() async {
    await _initializeRenderers();
    await _initializeLocalStream();
  }

  Future<void> _initializeRenderers() async {
    if (_localRenderer != null) return;
    _localRenderer = RTCVideoRenderer();
    await _localRenderer?.initialize();
  }

  Future<void> _initializeLocalStream() async {
    if (_localStream != null) return;
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
    });
    _localRenderer?.srcObject = _localStream;
  }

  void _registerWithFirestore() {
    // _selfId = _signalingCollection.doc().id;
    // _signalingCollection.doc(_selfId).set({'type': 'register'});
    if (currentWatchId == null) return;
    addSignal(currentWatchId!, myId, {'type': 'register', "id": myId});
    _listenForSignalingMessages();
  }

  void _listenForSignalingMessages() async {
    if (currentWatchId == null) return;
    await signalSub?.cancel();
    signalSub = streamChangeSignals(currentWatchId!).listen((signalsChanges) {
      for (int i = 0; i < signalsChanges.length; i++) {
        final signalChange = signalsChanges[i];
        final changeType = signalChange.type;
        final data = signalChange.value;
        final type = data["type"];
        final id = data["id"];

        if (id != myId) {
          if (changeType == DocumentChangeType.added) {
            switch (type) {
              case 'offer':
                _handleOffer(id, data['sdp']);
                break;
              case 'answer':
                _handleAnswer(id, data['sdp']);
                break;
              case 'candidate':
                _handleCandidate(id, data['candidate']);
                break;
              case 'register':
                _createPeerConnection(id);
                break;
            }
          } else if (changeType == DocumentChangeType.removed) {
            _disposeForUser(id);
          }
        }
      }
    });
    // _signalingCollection = FirebaseFirestore.instance
    //     .collection("watch")
    //     .doc(currentWatchId!)
    //     .collection("signaling");
    // _signalingCollection.snapshots().listen((snapshot) {
    //   for (var change in snapshot.docChanges) {
    //     if (change.type == DocumentChangeType.added &&
    //         change.doc.id != _selfId) {
    //       var data = change.doc.map;
    //       if (data == null) return;
    //       switch (data['type']) {
    //         case 'offer':
    //           _handleOffer(change.doc.id, data['sdp']);
    //           break;
    //         case 'answer':
    //           _handleAnswer(change.doc.id, data['sdp']);
    //           break;
    //         case 'candidate':
    //           _handleCandidate(change.doc.id, data['candidate']);
    //           break;
    //         case 'register':
    //           _createPeerConnection(change.doc.id);
    //           break;
    //       }
    //     }
    //   }
    // });
  }

  Future<void> _createPeerConnection(String peerId) async {
    await initForCall();
    var pc = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });
    _peerConnections[peerId] = pc;

    pc.onIceCandidate = (candidate) {
      if (currentWatchId == null) return;
      addSignal(currentWatchId!, peerId,
          {'type': 'candidate', "id": peerId, 'candidate': candidate.toMap()});
      // _signalingCollection.doc(peerId).set(
      //     {'type': 'candidate', 'candidate': candidate.toMap()},
      //     SetOptions(merge: true));
    };

    pc.onTrack = (event) {
      if (event.track.kind == 'video') {
        if (!_remoteRenderers.containsKey(peerId)) {
          var renderer = RTCVideoRenderer();
          renderer.initialize();
          _remoteRenderers[peerId] = renderer;
        }
        _remoteRenderers[peerId]?.srcObject = event.streams[0];
      }
    };

    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    if (_peerConnections.keys.length == 1) {
      var offer = await pc.createOffer();
      await pc.setLocalDescription(offer);
      if (currentWatchId == null) return;
      addSignal(currentWatchId!, peerId,
          {'type': 'offer', "id": peerId, 'sdp': offer.sdp});
      // _signalingCollection
      //     .doc(peerId)
      //     .set({'type': 'offer', 'sdp': offer.sdp}, SetOptions(merge: true));
    }
  }

  Future<void> _handleOffer(String from, String sdp) async {
    await initForCall();
    var pc = _peerConnections[from];
    if (pc == null) {
      await _createPeerConnection(from);
      pc = _peerConnections[from];
    }
    await pc?.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
    var answer = await pc?.createAnswer();
    await pc?.setLocalDescription(answer!);

    if (currentWatchId == null) return;
    addSignal(currentWatchId!, from,
        {'type': 'answer', "id": from, 'sdp': answer!.sdp});
    // _signalingCollection
    //     .doc(from)
    //     .set({'type': 'answer', 'sdp': answer!.sdp}, SetOptions(merge: true));
  }

  Future<void> _handleAnswer(String from, String sdp) async {
    await initForCall();
    var pc = _peerConnections[from];
    await pc?.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
  }

  Future<void> _handleCandidate(
      String from, Map<String, dynamic> candidate) async {
    await initForCall();
    var pc = _peerConnections[from];
    var rtcCandidate = RTCIceCandidate(candidate['candidate'],
        candidate['sdpMid'], candidate['sdpMLineIndex']);
    await pc?.addCandidate(rtcCandidate);
  }

  _leaveCall() {
    context.pop();
  }

  _toggleMic() {
    isAudioOn = !isAudioOn;
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  _toggleCamera() {
    isVideoOn = !isVideoOn;
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  _switchCamera() {
    isFrontCameraSelected = !isFrontCameraSelected;
    _localStream?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
    setState(() {});
  }

  //////////Bridge//////

  // void disposeForCall() {
  //   _localRTCVideoRenderer.dispose();
  //   _localStream?.dispose();
  //   _peerConnections.forEach((id, pc) {
  //     pc.dispose();
  //   });
  //   _remoteRTCVideoRenderers.forEach((id, renderer) {
  //     renderer.dispose();
  //   });
  // }

  // void initForCall() {
  //   _localRTCVideoRenderer.initialize();
  //   for (var watcher in callWatchers) {
  //     final id = watcher.id;
  //     _remoteRTCVideoRenderers[id] = RTCVideoRenderer();
  //     _remoteRTCVideoRenderers[id]!.initialize();
  //     _rtcIceCandidates[id] = [];
  //   }
  //   _setupPeerConnections();
  // }

  // Future<void> _setupPeerConnections() async {
  //   _localStream = await navigator.mediaDevices.getUserMedia({
  //     'audio': isAudioOn,
  //     'video': isVideoOn
  //         ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
  //         : false,
  //   });

  //   _localRTCVideoRenderer.srcObject = _localStream;
  //   setState(() {});

  //   for (Watcher watcher in callWatchers) {
  //     final calleeId = watcher.id;
  //     _peerConnections[calleeId] = await _createPeerConnection(calleeId);

  //     if (watcher.sdpOffer != null) {
  //       socket!.on("IceCandidate", (data) {
  //         String id = data["id"];
  //         String candidate = data["iceCandidate"]["candidate"];
  //         String sdpMid = data["iceCandidate"]["id"];
  //         int sdpMLineIndex = data["iceCandidate"]["label"];
  //         if (_peerConnections.containsKey(id)) {
  //           _peerConnections[id]!.addCandidate(
  //               RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
  //         }
  //       });

  //       await _peerConnections[calleeId]!.setRemoteDescription(
  //         RTCSessionDescription(widget.offer["sdp"], widget.offer["type"]),
  //       );

  //       RTCSessionDescription answer =
  //           await _peerConnections[calleeId]!.createAnswer();
  //       await _peerConnections[calleeId]!.setLocalDescription(answer);

  //       socket!.emit("answerCall", {
  //         "callerId": widget.callerId,
  //         "calleeId": calleeId,
  //         "sdpAnswer": answer.toMap(),
  //       });
  //     } else {
  //       _peerConnections[calleeId]!.onIceCandidate =
  //           (RTCIceCandidate candidate) =>
  //               _rtcIceCandidates[calleeId]!.add(candidate);

  //       socket!.on("callAnswered", (data) async {
  //         String id = data["id"];
  //         if (_peerConnections.containsKey(id)) {
  //           await _peerConnections[id]!.setRemoteDescription(
  //             RTCSessionDescription(
  //                 data["sdpAnswer"]["sdp"], data["sdpAnswer"]["type"]),
  //           );
  //           for (RTCIceCandidate candidate in _rtcIceCandidates[id]!) {
  //             socket!.emit("IceCandidate", {
  //               "calleeId": id,
  //               "iceCandidate": {
  //                 "id": candidate.sdpMid,
  //                 "label": candidate.sdpMLineIndex,
  //                 "candidate": candidate.candidate
  //               }
  //             });
  //           }
  //         }
  //       });

  //       RTCSessionDescription offer =
  //           await _peerConnections[calleeId]!.createOffer();
  //       await _peerConnections[calleeId]!.setLocalDescription(offer);
  //       await sendSdpOffer(currentWatch!, offer.toMap());

  //       // socket!.emit('makeCall', {
  //       //   "calleeId": calleeId,
  //       //   "sdpOffer": offer.toMap(),
  //       // });
  //     }
  //   }
  // }

  // Future<RTCPeerConnection> _createPeerConnection(String calleeId) async {
  //   RTCPeerConnection pc = await createPeerConnection({
  //     'iceServers': [
  //       {
  //         'urls': [
  //           'stun:stun1.l.google.com:19302',
  //           'stun:stun2.l.google.com:19302'
  //         ]
  //       }
  //     ]
  //   });

  //   pc.onTrack = (event) {
  //     _remoteRTCVideoRenderers[calleeId]!.srcObject = event.streams[0];
  //     setState(() {});
  //   };

  //   _localStream!.getTracks().forEach((track) {
  //     pc.addTrack(track, _localStream!);
  //   });

  //   return pc;
  // }

  void updateWatch(Watch? newWatch) async {
    requestedWatch = null;
    currentWatch = newWatch;
    watchersSub?.cancel();
    watchers.clear();

    if (newWatch != null) {
      match = newWatch.match;
      watchLink = "watchball.hms.com/${currentWatch!.id}";
      match = newWatch.match;
      watchersSub =
          streamChangeWatchers(newWatch.id).listen((watchersChanges) async {
        watchersChanges.mergeResult(watchers, (watcher) => watcher.id,
            changeCallback: (change) async {
          final watcher = change.value;
          String action = "";
          if (change.type == DocumentChangeType.removed ||
              watcher.status == "left") {
            action = "left";
          } else if (watcher.status == "current") {
            action = "joined";
          } else if (watcher.status == "request") {
            action = "requested";
          } else if (watcher.status == "invite") {
            action = "invited";
          }
          if (change.type == DocumentChangeType.added) {
            if (watcherUserMap[watcher.id] == null) {
              final user = await getUser(watcher.id);
              watcherUserMap[watcher.id] = user;
              if (creatorUser == null && watcher.id == newWatch.creatorId) {
                creatorUser = user;
              }
            }
          }
          // else if (change.type == DocumentChangeType.modified) {
          // }
          // else if (change.type == DocumentChangeType.removed) {
          // }
          final actionUser = watcherUserMap[watcher.id];
          if (actionUser == null || !mounted) return;
          context.showSnackBar("${actionUser.name} $action", false);

          if (action == "left") {
            watcherUserMap.remove(watcher.id);
          }
        });
        currentWatch!.watchers = watchers;
        if (currentWatch!.creatorId != myId &&
            watchers.indexWhere((watcher) => watcher.id == myId) == -1) {
          createWatch(match!);
        }
        setState(() {});
      });
    } else {
      watchLink = "";
    }
    if (newWatch == null || newWatch.watchers.isEmpty) {
      disposeForCall();
    }
    setState(() {});
    // if (newWatch != null) {
    //   List<Watcher> currentWatchers = newWatch.watchers
    //       .where((watcher) => watcher.status == "current")
    //       .toList();
    //   if (currentWatchers.length <= 1) {
    //     disposeForCall();
    //   } else {
    //     initForCall();
    //   }
    // } else {
    //   disposeForCall();
    // }

    if (currentWatch?.joinPrivacy != newWatch?.joinPrivacy) {
      joinPrivacy = newWatch?.joinPrivacy ?? "";
    }
    if (currentWatch?.invitePrivacy != newWatch?.invitePrivacy) {
      invitePrivacy = newWatch?.invitePrivacy ?? "";
    }

    // List<String> messages = [];
    isCreator = newWatch?.creatorId == myId;
    // final watchersChanges = getListChanges<Watcher>(
    //     currentWatch?.watchers ?? [],
    //     newWatch?.watchers ?? [],
    //     (watcher) => watcher.id);
    // print(
    //     "currentWatch = $currentWatch\n\nnewWatch = $newWatch\n\nWatcherChanges = $watchersChanges");
    // watchers.clear();
    // currentWatchers.clear();
    // invitedWatchers.clear();
    // requestedWatchers.clear();

    // if (newWatch?.watchers != null) {
    //   for (int i = 0; i < newWatch!.watchers.length; i++) {
    //     final watcher = newWatch.watchers[i];
    //     if (!watcherUserMap.containsKey(watcher.id)) {
    //       final user = await getUser(watcher.id);
    //       watcherUserMap[watcher.id] = user;
    //       if (creatorUser == null && watcher.id == newWatch.creatorId) {
    //         creatorUser = user;
    //       }
    //     }
    //     watcher.user = watcherUserMap[watcher.id];
    //     watchers.add(watcher);
    //     if (watcher.status == "current") {
    //       currentWatchers.add(watcher);
    //     } else if (watcher.status == "invite") {
    //       invitedWatchers.add(watcher);
    //     } else {
    //       requestedWatchers.add(watcher);
    //     }
    //   }
    // }

    // for (int i = 0; i < watchersChanges.length; i++) {
    //   final watcherChange = watchersChanges[i];
    //   final watcher = watcherChange.value;
    //   final oldWatcher = watcherChange.oldValue;

    //   actionUser = watcher.user;

    //   if (watcherChange.type == ListChangeType.added) {
    //     // watchers.add(watcher);
    //     if (watcher.status == "current") {
    //       messages.add("${actionUser?.name} joined");

    //       // currentWatchers.add(watcher);
    //     } else if (watcher.status == "invite") {
    //       messages.add("${actionUser?.name} invited");

    //       // invitedWatchers.add(watcher);
    //     } else {
    //       messages.add("${actionUser?.name} requested");

    //       // requestedWatchers.add(watcher);
    //       showRequestBottomSheet(watcher);
    //     }
    //   } else if (watcherChange.type == ListChangeType.modified) {
    //     if (oldWatcher!.status != watcher.status) {
    //       final action = watcher.status == "current"
    //           ? "joined"
    //           : watcher.status == "invite"
    //               ? "invited"
    //               : "requested";
    //       messages.add("${actionUser?.name} $action");
    //     }
    //     // final currentIndex =
    //     //     currentWatchers.indexWhere((wat) => wat.id == watcher.id);
    //     // if (currentIndex != -1) {
    //     //   currentWatchers[currentIndex] = watcher;
    //     // } else {
    //     //   final invitedIndex =
    //     //       invitedWatchers.indexWhere((wat) => wat.id == watcher.id);
    //     //   if (invitedIndex != -1) {
    //     //     currentWatchers[invitedIndex] = watcher;
    //     //   } else {
    //     //     final requestedIndex =
    //     //         requestedWatchers.indexWhere((wat) => wat.id == watcher.id);
    //     //     if (requestedIndex != -1) {
    //     //       requestedWatchers[requestedIndex] = watcher;
    //     //     }
    //     //   }
    //     // }
    //   } else {
    //     // final oldWatcher = watchers[watcherChange.oldIndex];

    //     // actionUser = oldWatcher.user;
    //     // watchers.removeAt(watcherChange.index);
    //     //watchers.remove(watcher);
    //     messages.add("${actionUser?.name} left");

    //     // if (watcher.status == "current") {
    //     //   currentWatchers.remove(watcher);
    //     // } else if (watcher.status == "invite") {
    //     //   invitedWatchers.remove(watcher);
    //     // } else {
    //     //   requestedWatchers.remove(watcher);
    //     // }
    //   }
    // }
    // if (currentWatch == null || currentWatch?.id != newWatch?.id) {
    //   currentWatch = newWatch;
    //   match = newWatch!.match;
    //   watchLink = "watchball.hms.com/${currentWatch!.id}";
    // }
    // // watch?.watchers = watchers;
    // if (messages.isNotEmpty) {
    //   if (!mounted) return;
    //   context.showSnackBar(messages.join(", "), false);
    // }
    // currentWatch = newWatch;
    // setState(() {});
  }

  // void listenForWatch() {
  //   if (currentWatchId == null) return;
  //   _registerWithFirestore();
  //   final watchId = currentWatchId!;
  //   watchersSub?.cancel();
  //   watchersSub = streamWatch(watchId).listen((newWatch) async {

  //   });
  // }

  Future<bool> showComfirmationDialog(String title, String message) async {
    final result = await context.showAlertDialog((context) {
      return AppAlertDialog(title: title, message: message, actions: const [
        "No",
        "Yes"
      ], onPresseds: [
        () {
          context.pop(false);
        },
        () {
          context.pop(true);
        }
      ]);
    });
    if (result != null) {
      return result;
    }
    return false;
  }

  void showRequestBottomSheet(Watcher watcher) {
    final user = watcher.user;
    if (user == null) return;
    context.showAppBottomSheet((context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: user.photo.isNotEmpty
                ? CachedNetworkImageProvider(user.photo)
                : null,
            backgroundColor: lightestTint,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.name,
            style: context.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Request to join watch",
            style: context.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  bgColor: lightestTint,
                  title: "Reject",
                  onPressed: () => rejectWatchRequest(user.id),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: AppButton(
                  title: "Accept",
                  onPressed: () => acceptWatchRequest(user.id),
                ),
              ),
            ],
          )
        ],
      );
    });
  }

  // void readWatchers() async {
  //   if (watch == null) return;
  //   isCreator = watch!.creatorId == myId;
  //   await watchersSub?.cancel();
  //   watchersSub =
  //       streamChangeWatchers(watch!.id).listen((watchersChanges) async {
  //     List<String> messages = [];

  //     for (int i = 0; i < watchersChanges.length; i++) {
  //       final watcherChange = watchersChanges[i];
  //       final watcher = watcherChange.value;
  //       final newIndex = watcherChange.newIndex;
  //       final oldIndex = watcherChange.oldIndex;

  //       if (watcherChange.type == DocumentChangeType.added) {
  //         final user = await getUser(watcher.id);
  //         watcher.user = user;
  //         actionUser = watcher.user;
  //         watchers.add(watcher);
  //         if (watcher.status == "current") {
  //           messages.add("${actionUser?.name} joined");

  //           currentWatchers.add(watcher);
  //         } else if (watcher.status == "invite") {
  //           messages.add("${actionUser?.name} invited");

  //           invitedWatchers.add(watcher);
  //         } else {
  //           messages.add("${actionUser?.name} requested");

  //           requestedWatchers.add(watcher);
  //         }
  //       } else if (watcherChange.type == DocumentChangeType.modified) {
  //         final beforeWatcher = watchers[newIndex];
  //         watcher.user = beforeWatcher.user;
  //         watchers[newIndex] = watcher;
  //         actionUser = watcher.user;
  //         if (beforeWatcher.status != watcher.status) {
  //           final action = watcher.status == "current"
  //               ? "joined"
  //               : watcher.status == "invite"
  //                   ? "invited"
  //                   : "requested";
  //           messages.add("${actionUser?.name} $action");
  //         }
  //         final currentIndex =
  //             currentWatchers.indexWhere((wat) => wat.id == watcher.id);
  //         if (currentIndex != -1) {
  //           currentWatchers[currentIndex] = watcher;
  //         } else {
  //           final invitedIndex =
  //               invitedWatchers.indexWhere((wat) => wat.id == watcher.id);
  //           if (invitedIndex != -1) {
  //             currentWatchers[invitedIndex] = watcher;
  //           } else {
  //             final requestedIndex =
  //                 requestedWatchers.indexWhere((wat) => wat.id == watcher.id);
  //             if (requestedIndex != -1) {
  //               requestedWatchers[requestedIndex] = watcher;
  //             }
  //           }
  //         }
  //       } else {
  //         final beforeWatcher = watchers[oldIndex];
  //         actionUser = beforeWatcher.user;
  //         watchers.remove(watcher);
  //         messages.add("${actionUser?.name} left");

  //         if (watcher.status == "current") {
  //           currentWatchers.remove(watcher);
  //         } else if (watcher.status == "invite") {
  //           invitedWatchers.remove(watcher);
  //         } else {
  //           requestedWatchers.remove(watcher);
  //         }
  //       }
  //     }
  //     watch?.watchers = watchers;
  //     if (messages.isNotEmpty) {
  //       if (!mounted) return;
  //       context.showSnackBar(messages.join(", "), false);
  //     }
  //     // this.watchers = watchers;
  //     // watch?.watchers = watchers;
  //     // for (int i = 0; i < watchers.length; i++) {
  //     //   final watcher = watchers[i];
  //     //   if (watcher.status == "current") {
  //     //     currentWatchers.add(watcher);
  //     //   } else if (watcher.status == "invite") {
  //     //     invitedWatchers.add(watcher);
  //     //   } else {
  //     //     requestedWatchers.add(watcher);
  //     //   }
  //     // }
  //     setState(() {});
  //     if (watchers.isEmpty) {
  //       if (!mounted) return;
  //       context.pop();
  //     }
  //   });
  //   setState(() {});
  // }

  // void createNewWatch() async {
  //   // final user = userOne;
  //   if (!mounted) return;
  //   final storedWatch = await createWatch(match);
  //   if (storedWatch != null) {
  //     currentWatch = storedWatch;
  //     watchLink = "watchball.hms.com/${currentWatch!.id}";
  //   }
  //   if (!mounted) return;
  //   setState(() {});
  // }

  // void addMeToWatchers() {
  //   final user = userOne;
  //   currentWatchers.add(user);
  // }

  void inviteSelectedWatchers(List<User> users) async {
    if (currentWatch == null) return;
    inviteWatchers(currentWatch!, users);
    // invitedWatchers.clear();
    // invitedWatchers.addAll(users);
    // final ids = users.map((val) => val.id).toList();
    // setState(() {});
  }

  void gotoInviteWatchers() async {
    // if (!isCreator) {
    //   invitedWatchers.clear();
    // }
    final result = await context.pushNamedTo(InviteWatchersScreen.route,
        args: {"users": invitedWatchers, "link": watchLink});
    if (result != null) {
      inviteSelectedWatchers(result["contacts"]);
    }
  }

  void gotoJoinWatch() async {
    // if (isCreator) {
    //   invitedWatchers.clear();
    // }
    final result = await context.pushNamedTo(JoinWatchScreen.route);
    if (result != null) {
      joinWatch(result["watch"]);
    }
  }

  void copyWatchLink() {}
  void shareWatchLink() {}

  void cancelJoinRequest() async {
    if (requestedWatch == null) return;
    final result = await showComfirmationDialog("Cancel Join Request",
        "Are you sure you want to cancel this join request?");
    if (!result) return;
    rejectOrLeaveWatch(requestedWatch!, null);
  }

  void joinWatch(Watch watch) async {
    if (watch.joinPrivacy == "invited") {
      return;
    }
    if (watch.joinPrivacy == "accepted") {
      await requestToJoinWatch(watch);
      requestedWatch = watch;
      watcherSub = streamWatcher(watch.id, myId).listen((watcher) async {
        if (watcher == null) {
          watcherSub?.cancel();
          watcherSub = null;
          requestedWatch = null;
        } else {
          if (watcher.status == "current" && currentWatch != null) {
            requestedWatch = null;
            await rejectOrLeaveWatch(currentWatch!, myId);
            await acceptOrJoinWatch(watch, myId);
          }
        }

        setState(() {});
      });
    } else {
      acceptOrJoinWatch(watch, myId);
    }
    // final users = watch.users;
    // invitedWatchers.clear();
    // invitedWatchers.addAll(users);
    // final ids = users.map((val) => val.id).toList();
    // setState(() {});
  }

  void leaveWatch() async {
    if (currentWatch == null) {
      context.pop();
      return;
    }

    final result = await showComfirmationDialog(
        "Leave ${isMyWatchAndNotRequesting ? "Match" : "Watch"}",
        "Are you sure you want to leave this ${isMyWatchAndNotRequesting ? "match" : "watch"}?");
    if (!result) return;

    await rejectOrLeaveWatch(currentWatch!, myId);
    if (isMyWatchAndNotRequesting) {
      if (!mounted) return;
      context.pop();
    }

    // if (canPop) {
    //   if (currentWatch == null) return;
    //   rejectOrLeaveWatch(currentWatch!, myId);
    //   return;
    // }
    // if (currentWatch == null) {
    //   await showComfirmationDialog(
    //       "Leave Match", "Are you sure you want to leave this match?");
    //   return;
    // }
    // final isOnlyMe =
    //     currentWatch!.creatorId == myId && currentWatch!.watchers.length <= 1;
    // final result = await showComfirmationDialog(
    //     "Leave ${isOnlyMe ? "Match" : "Watch"}",
    //     "Are you sure you want to leave this ${isOnlyMe ? "match" : "watch"}?");
    // if (!result) return;
    // canPop = result && isOnlyMe;
    // rejectOrLeaveWatch(currentWatch!, myId);
    // if (canPop) {
    //   if (!mounted) return;
    //   context.pop();
    // }
  }

  void rejectWatchRequest(String userId) async {
    if (currentWatch == null) return;
    // final result = await showComfirmationDialog(
    //     "Reject Watch", "Are you sure you want to reject this request?");
    // if (!result) return;
    rejectOrLeaveWatch(currentWatch!, userId);
  }

  void acceptWatchRequest(String userId) async {
    if (currentWatch == null) return;
    // final result = await showComfirmationDialog(
    //     "Accept Watch", "Are you sure you want to accept this request?");
    // if (!result) return;
    acceptOrJoinWatch(currentWatch!, userId);
  }

  // void rejectWatchInvite(Watch watch, WatchInvite invite) {
  //   rejectOrLeaveWatch(watch, invite);
  // }

  // void acceptWatchInvite(Watch watch, WatchInvite invite) {
  //   acceptOrJoinWatch(watch, currentWatch, invite);
  // }

  void updateCreatorActionPressed(String type, String userId) {
    if (currentWatch == null) return;
    rejectOrLeaveWatch(currentWatch!, userId);

    // if (type == "current") {
    // } else if (type == "invite") {
    //   rejectOrLeaveWatch(currentWatch!, null, userId: userId);
    // } else {
    //   rejectOrLeaveWatch(currentWatch!, null, userId: userId);
    // }
  }

  void updateCreatorRightActionPressed(String type, String userId) {
    if (currentWatch == null) return;
    acceptOrJoinWatch(currentWatch!, userId);
  }

  void toggleMode() {
    if (mode == "users") {
      mode = "comments";
    } else {
      mode = "users";
    }
    setState(() {});
  }

  void toggleView() {
    if (view == "grid") {
      view = "list";
    } else {
      view = "grid";
    }
    setState(() {});
  }

  void toggleVideo() {
    video = !video;
    setState(() {});
  }

  void toggleSound() {
    muted = !muted;
    setState(() {});
  }

  // void updateWatch() async {
  //   watch = await getWatch(currentWatch!);
  //   match = watch!.match;

  //   streamLink = null;
  //   watchLink = "watchball.hms.com/${watch!.id}";
  //   readWatchers();
  //   getStreamLink();

  //   setState(() {});
  // }

  bool get isMyWatchAndNotRequesting =>
      requestedWatch == null &&
      currentWatch != null &&
      currentWatch!.creatorId == myId;

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);
    final newWatch = ref.watch(watchProvider);
    //final requestedWatchId = ref.watch(requestedWatchProvider);
    // if (newWatch == null) {
    //   createNewWatch();
    // }
    if (currentWatch?.id != newWatch?.id) {
      _registerWithFirestore();
    }

    // if (requestedWatchId == null) {
    //   requestedWatch = null;
    //   setState(() {});
    // }
    updateWatch(newWatch);

    // if (user != null) {
    //   print("incomingUser = $user");
    //   if (user.currentWatch == null) {
    //     createNewWatch();
    //   }

    //   if (currentWatchId != user.currentWatch) {
    //     currentWatchId = user.currentWatch;
    //     if (currentWatchId != null) {
    //       listenForWatch();
    //     } else {
    //       watchersSub?.cancel();
    //     }
    //   } else if (requestedWatchId != user.requestedWatch) {
    //     requestedWatchId = user.requestedWatch;
    //     if (requestedWatchId == null) {
    //       requestedWatch = null;
    //       setState(() {});
    //     } else {}
    //   } else if (invitedWatchs != user.invitedWatchs) {
    //     invitedWatchs = user.invitedWatchs;
    //     if (invitedWatchs == null || invitedWatchs!.isEmpty) {
    //     } else {}
    //   }
    //   if (currentWatchId == null) {
    //     disposeForCall();
    //     createNewWatch();
    //   }
    // }

    return PopScope(
      canPop: currentWatch == null || isMyWatchAndNotRequesting,
      onPopInvoked: (pop) {
        //if (pop) return;
        if (requestedWatch != null) {
          cancelJoinRequest();
        } else {
          leaveWatch();
        }
      },
      child: Scaffold(
        // appBar: AppAppBar(
        //   title:
        //       match != null ? "${match!.homeName} vs ${match!.awayName}" : "",
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AspectRatio(
            //   aspectRatio: 16 / 9,
            //   // child: loadingMatch
            //   //     ? const Center(
            //   //         child: CircularProgressIndicator(),
            //   //       )
            //   //     : streamLink != null && streamLink!.isNotEmpty
            //   //         ? _chewieController != null
            //   //             ? Chewie(
            //   //                 controller: _chewieController!,
            //   //               )
            //   //             : null

            //   //         // ? BetterPlayer.network(
            //   //         //     streamLink!,
            //   //         //     //  betterPlayerConfiguration: BetterPlayerConfiguration(),
            //   //         //   )
            //   //         : Center(
            //   //             child: Padding(
            //   //             padding: const EdgeInsets.all(8.0),
            //   //             child: streamLink == null
            //   //                 ? Text(
            //   //                     "Stream link not available yet. Watch out for the match",
            //   //                     style: context.bodySmall,
            //   //                     textAlign: TextAlign.center)
            //   //                 : const CircularProgressIndicator(),
            //   //           )),
            //   child: AppContainer(
            //     color: lighterTint,
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   match.league,
                      //   style: context.headlineSmall?.copyWith(fontSize: 18),
                      //   textAlign: TextAlign.center,
                      // ),
                      // LiveMatchItem(match: match),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      WatcherHeading(
                          type: "current", size: currentWatchers.length),
                      WatchersListScreen(
                        remoteRenderers: _remoteRenderers,
                        isCreator: isCreator,
                        watchers: currentWatchers,
                        view: view,
                        type: "current",
                        onPressed: (userId) =>
                            updateCreatorActionPressed("current", userId),
                        onRightPressed: (userId) =>
                            updateCreatorRightActionPressed("current", userId),
                      ),
                      if (requestedWatchers.isNotEmpty) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        WatcherHeading(
                            type: "requested", size: requestedWatchers.length),
                        WatchersListScreen(
                          isCreator: isCreator,
                          watchers: requestedWatchers,
                          view: view,
                          type: "request",
                          onPressed: (userId) =>
                              updateCreatorActionPressed("request", userId),
                          onRightPressed: (userId) =>
                              updateCreatorRightActionPressed(
                                  "request", userId),
                        ),
                      ],
                      if (invitedWatchers.isNotEmpty) ...[
                        const SizedBox(
                          height: 10,
                        ),
                        WatcherHeading(
                            type: "invited", size: invitedWatchers.length),
                        WatchersListScreen(
                          isCreator: isCreator,
                          watchers: invitedWatchers,
                          view: view,
                          type: "invite",
                          onPressed: (userId) =>
                              updateCreatorActionPressed("invite", userId),
                          onRightPressed: (userId) =>
                              updateCreatorRightActionPressed("invite", userId),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            AppContainer(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppContainer(
                    // height: 50,
                    width: double.infinity,
                    child: requestedWatchers.isNotEmpty
                        ? AppContainer(
                            child: Text(
                              "${requestedWatchers[0].user?.name}${requestedWatchers.length == 1 ? "" : " and ${requestedWatchers.length - 1}others"} is requesting to watch this match with you",
                              style: context.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : currentWatchers.length > 1
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: toggleVideo,
                                    icon: Icon(
                                      !video
                                          ? EvaIcons.video_outline
                                          : EvaIcons.video_off_outline,
                                      size: 20,
                                      color: white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: toggleSound,
                                    icon: Icon(
                                      muted
                                          ? EvaIcons.mic_outline
                                          : EvaIcons.mic_off_outline,
                                      size: 20,
                                      color: white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: toggleMode,
                                    icon: Icon(
                                      mode == "comments"
                                          ? EvaIcons.people_outline
                                          : EvaIcons.message_circle_outline,
                                      size: 20,
                                      color: white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: toggleView,
                                    icon: Icon(
                                      view == "grid"
                                          ? EvaIcons.list_outline
                                          : EvaIcons.grid_outline,
                                      size: 20,
                                      color: white,
                                    ),
                                  ),
                                ],
                              )
                            : isCreator
                                ? AppContainer(
                                    borderRadius: BorderRadius.circular(30),
                                    //height: 50,
                                    padding: const EdgeInsets.only(left: 10),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    color: lightestTint,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            watchLink,
                                            style:
                                                context.bodyMedium?.copyWith(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: copyWatchLink,
                                          icon: const Icon(
                                            EvaIcons.copy_outline,
                                            size: 20,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: shareWatchLink,
                                          icon: const Icon(
                                            EvaIcons.share_outline,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : requestedWatch != null
                                    ? AppContainer(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 10),
                                        child: Text(
                                          "Waiting to be let in...",
                                          style: context.bodyMedium,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : null,
                  ),
                  Row(
                    children: [
                      if (requestedWatch != null)
                        Expanded(
                          child: AppButton(
                            bgColor: lightestTint,
                            title: "Cancel Watch",
                            onPressed: cancelJoinRequest,
                          ),
                        )
                      else if (currentWatchers.length > 1)
                        Expanded(
                          child: AppButton(
                            bgColor: lightestTint,
                            title: "Leave Watch",
                            onPressed: leaveWatch,
                          ),
                        )
                      else
                        Expanded(
                          child: AppButton(
                            bgColor: lightestTint,
                            title: "Join Watch",
                            onPressed: gotoJoinWatch,
                          ),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (isCreator ||
                          invitePrivacy.contains(myId) ||
                          invitePrivacy == "everyone")
                        Expanded(
                          child: AppButton(
                            title: "Invite Watchers",
                            onPressed: gotoInviteWatchers,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

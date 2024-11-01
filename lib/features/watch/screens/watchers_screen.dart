// import 'dart:async';
// import 'package:cached_chewie_plus/cached_chewie_plus.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:video_player/video_player.dart';
// //import 'package:video_player_win/video_player_win.dart';
// import 'package:watchball/features/match/components/live_match_item.dart';
// import 'package:watchball/features/match/providers/match_provider.dart';
// import 'package:watchball/shared/components/app_alert_dialog.dart';
// import 'package:watchball/shared/components/app_appbar.dart';
// import 'package:watchball/shared/components/app_back_button.dart';
// import 'package:watchball/shared/components/app_button.dart';
// import 'package:watchball/shared/components/app_container.dart';
// import 'package:watchball/features/match/models/live_match.dart';
// import 'package:watchball/features/watch/providers/requested_watch_provider.dart';
// import 'package:watchball/features/watch/providers/watch_provider.dart';
// import 'package:watchball/features/watch/screens/join_watch_screen.dart';
// import 'package:watchball/features/watch/screens/add_watchers_screen.dart';
// import 'package:watchball/features/watch/screens/watchers_list_screen.dart';
// import 'package:watchball/features/watch/services/live_stream_service.dart';
// import 'package:watchball/features/user/services/user_service.dart';
// import 'package:watchball/features/watch/services/watch_service.dart';
// import 'package:watchball/theme/colors.dart';
// import 'package:watchball/utils/extensions.dart';
// import 'package:watchball/features/user/mocks/users.dart';

// import '../../match/components/odds_item.dart';
// import '../components/watcher_heading.dart';
// import '../../../shared/models/list_change.dart';
// import '../../user/models/user.dart';
// import '../models/watch.dart';
// import '../models/watcher.dart';
// import '../../user/providers/user_provider.dart';
// import '../../../firebase/firestore_methods.dart';
// import '../../../utils/utils.dart';
// import '../utils/utils.dart';

// class WatchersScreen extends ConsumerStatefulWidget {
//   static const route = "/watchers";

//   const WatchersScreen({super.key});

//   @override
//   ConsumerState<WatchersScreen> createState() => _WatchersScreenState();
// }

// class _WatchersScreenState extends ConsumerState<WatchersScreen> {
//   List<Watcher> watchers = [];
//   List<Watcher> currentWatchers = [];
//   List<Watcher> requestedWatchers = [];
//   List<Watcher> invitedWatchers = [];
//   String mode = "users";
//   String view = "grid";
//   bool muted = true;
//   bool video = true;
//   bool loading = true;
//   bool loadingMatch = true;

//   LiveMatch? match;

//   String watchLink = "";

//   bool isFirstTime = true;
//   StreamSubscription? watcherSub;
//   StreamSubscription? watchersSub;

//   bool isCreator = false;
//   User? actionUser, creatorUser;

//   Watch? currentWatch;
//   Watch? requestedWatch;

//   String watchId = "";
//   String? currentWatchId;
//   String? requestedWatchId;
//   String joinPrivacy = "";
//   String invitePrivacy = "";
//   Map<String, User?> watcherUserMap = {};
//   bool canPop = false;

//   //Call
//   String? callMode;
//   bool calling = false;
//   bool isAudioOn = true,
//       isVideoOn = true,
//       isFrontCameraSelected = true,
//       isOnSpeaker = false;
//   RTCVideoRenderer? _localRenderer;
//   final Map<String, RTCVideoRenderer> _remoteRenderers = {};
//   final Map<String, RTCPeerConnection> _peerConnections = {};
//   final Map<String, String> videoOverlayVisibility = {};
//   //final Map<String, List<RTCIceCandidate>> _rtcIceCandidates = {};
//   MediaStream? _localStream;
//   StreamSubscription? signalSub;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //initForCall();
//   }

//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();

//     // if (isFirstTime) {
//     //   currentWatch = context.args["watch"];
//     //   if (currentWatch != null) {
//     //     currentWatchId = currentWatch!.id;
//     //     listenForWatch();
//     //     // match = watch!.match;
//     //     // watchLink = "watchball.hms.com/${watch!.id}";
//     //     // readWatchers();
//     //   } else {
//     //     match = context.args["match"];
//     //     createNewWatch();
//     //   }
//     //   //getStreamLink();
//     //   isFirstTime = false;
//     // }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose

//     watchersSub?.cancel();
//     watcherSub?.cancel();
//     disposeForCall();
//     super.dispose();
//   }

//   Future executeCallAction(Watcher watcher, [bool isRemoved = false]) async {
//     final myCallMode = getMyCallMode(watchers);

//     if (isRemoved && callMode != null) {
//       if (watcher.id == myId) {
//         await _leaveCall();
//         callMode = null;
//         calling = false;
//       } else {
//         _disposeForUser(watcher.id);
//         if (watchers
//             .where((element) =>
//                 element.id != myId && element.callMode == myCallMode)
//             .isEmpty) {
//           calling = false;
//         }
//       }
//       return;
//     }
//     if (myCallMode == null) {
//       if (callMode != null) {
//         await _leaveCall();
//         callMode = null;
//         calling = false;
//       }
//     } else {
//       if (watcher.id == myId && watcher.callMode != null) {
//         if (callMode != null && callMode != watcher.callMode) {
//           callMode = watcher.callMode;
//           await updateCallMode(watchId, callMode);
//         } else {
//           if (callMode == null) {
//             callMode = watcher.callMode;
//             await _startCall();
//             final callers = watchers
//                 .where((element) =>
//                     element.id != myId && element.callMode == watcher.callMode)
//                 .toList();

//             calling = callers.isNotEmpty;
//           }
//           //  else {
//           //   _toggleCallMode();
//           // }
//         }
//       } else {
//         if (watcher.callMode == myCallMode) {
//           //_disposeForUser(watcher.id);
//           sendOffer(watcher.id);
//           calling = true;
//         } else {
//           if (callMode != null) {
//             if (watcher.callMode == null) {
//               _disposeForUser(watcher.id);
//               if (watchers
//                   .where((element) =>
//                       element.id != myId && element.callMode == myCallMode)
//                   .isEmpty) {
//                 calling = false;
//               }
//             }
//             // else {
//             //   callMode = watcher.callMode;
//             // }
//           }
//         }
//       }
//     }
//   }

//   void updateMyCallMode({String? callMode}) async {
//     final index = watchers.indexWhere((element) => element.id == myId);
//     if (index == -1) return;
//     final watcher = watchers[index];
//     watcher.callMode = callMode;
//     await executeCallAction(watchers[index]);
//     setState(() {});
//   }

//   void toggleCall(String? callMode) async {
//     updateMyCallMode(callMode: callMode);
//   }

//   void toggleCamera() async {
//     _switchCamera();
//   }

//   void toggleMute() async {
//     _toggleMic();
//   }

//   // Future<void> selectAudioOutput(String deviceId) async {
//   //   await navigator.mediaDevices
//   //       .selectAudioOutput(AudioOutputOptions(deviceId: deviceId));
//   // }

//   // Future<void> selectAudioInput(String deviceId) =>
//   //     NativeAudioManagement.selectAudioInput(deviceId);

//   // Future<void> setSpeakerphoneOn(bool enable) =>
//   //     NativeAudioManagement.setSpeakerphoneOn(enable);

//   void _listenForSignalingMessages() async {
//     if (signalSub != null) return;
//     //await signalSub?.cancel();
//     signalSub = streamChangeSignals(watchId).listen((signalsChanges) {
//       for (int i = 0; i < signalsChanges.length; i++) {
//         final signalChange = signalsChanges[i];
//         final data = signalChange.value;
//         final type = data["type"];
//         final id = data["id"];
//         //print("signalChange = $signalChange");

//         if (signalChange.added || signalChange.modified) {
//           switch (type) {
//             case 'offer':
//               _handleOffer(id, data['sdp']);
//               break;
//             case 'answer':
//               _handleAnswer(id, data['sdp']);
//               break;
//             case 'candidate':
//               _handleCandidate(id, data['candidate']);
//               break;
//           }
//         } else if (signalChange.removed) {
//           _disposeForUser(id);
//         }
//       }
//     });
//   }

//   void disposeForCall([bool disposeWithSignal = true]) async {
//     if (disposeWithSignal) {
//       signalSub?.cancel();
//     }

//     _localRenderer?.dispose();
//     videoOverlayVisibility.remove(myId);
//     for (var renderer in _remoteRenderers.values) {
//       renderer.dispose();
//     }
//     for (var pc in _peerConnections.values) {
//       pc.dispose();
//     }
//     _localStream?.dispose();

//     _remoteRenderers.clear();
//     _peerConnections.clear();
//     videoOverlayVisibility.clear();
//     signalSub = null;
//     _localStream = null;
//     _localRenderer = null;
//   }

//   void _disposeForUser(String peerId) async {
//     _remoteRenderers[peerId]?.dispose();
//     _peerConnections[peerId]?.dispose();
//     _remoteRenderers.remove(peerId);
//     _peerConnections.remove(peerId);
//     videoOverlayVisibility.remove(peerId);

//     if (_peerConnections.isEmpty) {
//       signalSub?.cancel();
//       _localRenderer?.dispose();
//       videoOverlayVisibility.remove(myId);
//       _localStream?.dispose();
//       signalSub = null;
//       _localStream = null;
//       _localRenderer = null;
//     }
//   }

//   Future initForCall() async {
//     await _initializeLocalStream();
//   }

//   Future<void> _initializeLocalRenderer() async {
//     if (_localRenderer != null) return;
//     _localRenderer = RTCVideoRenderer();
//     videoOverlayVisibility[myId] = "show";
//     await _localRenderer?.initialize();
//   }

//   Future<void> _initializeLocalStream() async {
//     isVideoOn = callMode == "video";

//     if (_localStream != null &&
//         ((_localRenderer != null && isVideoOn) ||
//             (_localRenderer == null && !isVideoOn))) {
//       return;
//     }
//     await _localStream?.dispose();
//     //print("newisAudioOn = $isAudioOn");
//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': isAudioOn,
//       'video': isVideoOn
//           ? {
//               'mandatory': {
//                 'minWidth': '640', // Adjust as needed
//                 'minHeight': '480', // Adjust as needed
//                 'minFrameRate': '15',
//                 'maxFrameRate': '30',
//               },
//               'facingMode': isFrontCameraSelected ? 'user' : 'environment',
//               'optional': [],
//             }
//           //? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
//           : false,
//     });
//     if (isVideoOn) {
//       await _initializeLocalRenderer();
//     } else {
//       if (_localRenderer != null) {
//         _localRenderer!.dispose();
//         _localRenderer = null;
//         videoOverlayVisibility.remove(myId);
//       }
//     }
//     _localRenderer?.srcObject = _localStream;
//     setState(() {});
//   }

//   Future<void> _createPeerConnection(String peerId) async {
//     await initForCall();
//     if (_peerConnections[peerId] != null &&
//         ((_remoteRenderers[peerId] != null && isVideoOn) ||
//             (_remoteRenderers[peerId] == null && !isVideoOn))) return;

//     await _peerConnections[peerId]?.dispose();

//     var pc = await createPeerConnection({
//       'iceServers': [
//         {
//           'urls': [
//             'stun:stun1.l.google.com:19302',
//             'stun:stun2.l.google.com:19302'
//           ]
//         }
//       ]
//     });
//     _peerConnections[peerId] = pc;

//     pc.onTrack = (event) async {
//       if (event.track.kind == 'video') {
//         if (!_remoteRenderers.containsKey(peerId)) {
//           var renderer = RTCVideoRenderer();
//           _remoteRenderers[peerId] = renderer;
//           videoOverlayVisibility[peerId] = "faint";
//           await _remoteRenderers[peerId]?.initialize();
//         }
//         _remoteRenderers[peerId]?.srcObject = event.streams[0];
//         setState(() {});
//       } else {
//         if (_remoteRenderers.containsKey(peerId)) {
//           _remoteRenderers[peerId]?.dispose();
//           _remoteRenderers.remove(peerId);
//           videoOverlayVisibility.remove(peerId);
//           setState(() {});
//         }
//       }
//     };

//     _localStream?.getTracks().forEach((track) {
//       pc.addTrack(track, _localStream!);
//     });
//     setState(() {});
//   }

//   String _setMediaBitrate(String sdp, {int? audioBitrate, int? videoBitrate}) {
//     var lines = sdp.split('\n');
//     var newSdp = <String>[];

//     bool videoBitrateSet = false;
//     bool audioBitrateSet = false;

//     for (var i = 0; i < lines.length; i++) {
//       if (lines[i].startsWith('m=video')) {
//         newSdp.add(lines[i]);
//         videoBitrateSet = true;
//       } else if (lines[i].startsWith('m=audio')) {
//         newSdp.add(lines[i]);
//         audioBitrateSet = true;
//       } else if (lines[i].startsWith('b=AS:') && lines[i].contains('video')) {
//         // Skip existing video bitrate line to avoid duplication
//         videoBitrateSet = false;
//       } else if (lines[i].startsWith('b=AS:') && lines[i].contains('audio')) {
//         // Skip existing audio bitrate line to avoid duplication
//         audioBitrateSet = false;
//       } else {
//         newSdp.add(lines[i]);
//       }
//     }

//     // Add or update bitrate lines
//     if (videoBitrateSet) {
//       newSdp.add('b=AS:${videoBitrate ?? 1000}'); // Add video bitrate line
//     }
//     if (audioBitrateSet) {
//       newSdp.add('b=AS:${audioBitrate ?? 64}'); // Add audio bitrate line
//     }

//     return newSdp.join('\n');
//   }

//   Future _startCall() async {
//     if (watchId == "") return;
//     await startCall(watchId, callMode!);
//     _listenForSignalingMessages();
//   }

//   _leaveCall() async {
//     await endCall(watchId);
//     await removeSignal(watchId, myId);
//     disposeForCall();
//     //context.pop();
//   }

//   _toggleMic() async {
//     isAudioOn = !isAudioOn;

//     _localStream?.getAudioTracks().forEach((track) {
//       track.enabled = isAudioOn;
//     });
//     setState(() {});
//     updateCallAudio(watchId, isAudioOn);
//   }

//   // _toggleCallMode() {
//   //   isVideoOn = !isVideoOn;
//   //   _localStream?.getVideoTracks().forEach((track) {
//   //     track.enabled = isVideoOn;
//   //   });
//   //   setState(() {});
//   // }

//   _switchCamera() {
//     isFrontCameraSelected = !isFrontCameraSelected;
//     _localStream?.getVideoTracks().forEach((track) {
//       // // ignore: deprecated_member_use
//       // track.switchCamera();
//       Helper.switchCamera(track);
//     });
//     setState(() {});
//     updateCallCamera(watchId, isFrontCameraSelected);
//   }

//   toggleSpeaker() async {
//     isOnSpeaker = !isOnSpeaker;
//     await Helper.setSpeakerphoneOn(isOnSpeaker);
//     setState(() {});
//   }

//   toggleVideoOverlayVisibility(String? userId) {
//     if (userId == null) return;
//     final visibility = videoOverlayVisibility[userId];
//     switch (visibility) {
//       case "show":
//         videoOverlayVisibility[userId] = "faint";
//         break;
//       case "faint":
//         videoOverlayVisibility[userId] = "hide";
//         break;
//       case "hide":
//         videoOverlayVisibility[userId] = "show";
//         break;
//     }
//     setState(() {});
//   }

//   double getVideoOverlayOpacity(String? userId) {
//     if (userId == null) return 1;
//     final visibility = videoOverlayVisibility[userId];
//     switch (visibility) {
//       case "show":
//         return 1;
//       case "faint":
//         return 0.5;
//       case "hide":
//         return 0;
//     }
//     return 1;
//   }

//   Future sendIceCandidates(String peerId) async {
//     await _createPeerConnection(peerId);
//     final pc = _peerConnections[peerId]!;
//     pc.onIceCandidate = (candidate) {
//       addSignal(watchId, peerId,
//           {'type': 'candidate', 'candidate': candidate.toMap()});
//     };
//   }

//   Future sendOffer(String peerId) async {
//     //_listenForSignalingMessages();
//     bool justCreating = _peerConnections[peerId] == null;

//     await _createPeerConnection(peerId);
//     final pc = _peerConnections[peerId]!;

//     var offer = await pc.createOffer();
//     //RTCSessionDescription offer = await pc.createOffer();
//     //offer.sdp = _setMediaBitrate(offer.sdp!, videoBitrate: 500); // 500 kbps

//     await pc.setLocalDescription(offer);
//     await addSignal(watchId, peerId, {'type': 'offer', 'sdp': offer.sdp});
//     if (justCreating) {
//       sendIceCandidates(peerId);
//     }
//   }

//   Future sendAnswer(String peerId, String sdp) async {
//     //_listenForSignalingMessages();
//     bool justCreating = _peerConnections[peerId] == null;

//     await _createPeerConnection(peerId);

//     final pc = _peerConnections[peerId]!;

//     await pc.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));

//     var answer = await pc.createAnswer();
//     //RTCSessionDescription answer = await pc.createAnswer();
//     //answer.sdp = _setMediaBitrate(answer.sdp!, videoBitrate: 500); // 500 kbps
//     await pc.setLocalDescription(answer);

//     await addSignal(watchId, peerId, {'type': 'answer', 'sdp': answer.sdp});

//     if (justCreating) {
//       sendIceCandidates(peerId);

//       await sendOffer(peerId);
//     }
//   }

//   Future<void> _handleOffer(String peerId, String sdp) async {
//     await sendAnswer(peerId, sdp);
//   }

//   Future<void> _handleAnswer(String peerId, String sdp) async {
//     await _createPeerConnection(peerId);
//     final pc = _peerConnections[peerId]!;
//     await pc.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
//   }

//   Future<void> _handleCandidate(
//       String peerId, Map<String, dynamic> candidate) async {
//     await _createPeerConnection(peerId);
//     final pc = _peerConnections[peerId]!;
//     var rtcCandidate = RTCIceCandidate(candidate['candidate'],
//         candidate['sdpMid'], candidate['sdpMLineIndex']);
//     await pc.addCandidate(rtcCandidate);
//   }

//   String? getWatcherId(int index) {
//     return index < watchers.length ? watchers[index].id : null;
//   }

//   Watcher? getWatcher(int index) {
//     return index < watchers.length ? watchers[index] : null;
//   }

//   Widget? buildVideoView(int index) {
//     if (watchId.isEmpty || watchers.isEmpty) return null;
//     final watcherId = getWatcherId(index);
//     if (watcherId == null ||
//         (watcherId == myId && _localRenderer == null) ||
//         (watcherId != myId && _remoteRenderers[watcherId] == null)) {
//       return null;
//     }
//     return RTCVideoView(
//       watcherId == myId ? _localRenderer! : _remoteRenderers[watcherId]!,
//       objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//       // mirror: watcherId == myId && isFrontCameraSelected,
//     );
//   }

//   void updateWatch(Watch? newWatch) async {
//     watchId = newWatch?.id ?? "";

//     requestedWatch = null;

//     if (newWatch != null &&
//         (currentWatch == null || currentWatch?.id != newWatch.id)) {
//       currentWatch = newWatch;
//       watchersSub?.cancel();
//       watchers.clear();

//       match = newWatch.match;
//       watchLink = "watchball.hms.com/${currentWatch!.id}";
//       watchersSub =
//           streamChangeWatchers(newWatch.id).listen((watchersChanges) async {
//         watchersChanges.mergeResult(watchers, (watcher) => watcher.id,
//             changeCallback: (change) async {
//           final watcher = change.value;
//           String action = "";
//           if (change.type == DocumentChangeType.removed ||
//               watcher.status == "left") {
//             action = "left";
//           } else if (watcher.status == "current") {
//             action = "joined";
//           } else if (watcher.status == "request") {
//             action = "requested";
//           } else if (watcher.status == "invite") {
//             action = "invited";
//           }
//           executeCallAction(watcher, change.removed);

//           if (change.type == DocumentChangeType.added) {
//             if (watcherUserMap[watcher.id] == null) {
//               final user = await getUser(watcher.id);
//               watcherUserMap[watcher.id] = user;
//               if (creatorUser == null && watcher.id == newWatch.creatorId) {
//                 creatorUser = user;
//               }
//             }
//           }
//           // else if (change.type == DocumentChangeType.modified) {
//           // }
//           // else if (change.type == DocumentChangeType.removed) {
//           // }
//           final actionUser = watcherUserMap[watcher.id];
//           if (actionUser == null || !mounted) return;
//           context.showSnackBar("${actionUser.name} $action", false);

//           if (action == "left") {
//             watcherUserMap.remove(watcher.id);
//           }
//         });
//         currentWatch!.watchers = watchers;
//         // if (currentWatch!.creatorId != myId &&
//         //     watchers.indexWhere((watcher) => watcher.id == myId) == -1) {
//         //   createWatch(match!);
//         // }
//         setState(() {});
//       });
//     } else {
//       currentWatch = newWatch;
//       watchLink = "";
//     }
//     if (newWatch == null || newWatch.watchers.isEmpty) {
//       disposeForCall();
//     }
//     setState(() {});

//     if (currentWatch?.joinPrivacy != newWatch?.joinPrivacy) {
//       joinPrivacy = newWatch?.joinPrivacy ?? "";
//     }
//     if (currentWatch?.invitePrivacy != newWatch?.invitePrivacy) {
//       invitePrivacy = newWatch?.invitePrivacy ?? "";
//     }

//     // List<String> messages = [];
//     isCreator = newWatch?.creatorId == myId;
//   }

//   void showRequestBottomSheet(Watcher watcher) {
//     final user = watcher.user;
//     if (user == null) return;
//     context.showAppBottomSheet((context) {
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: user.photo.isNotEmpty
//                 ? CachedNetworkImageProvider(user.photo)
//                 : null,
//             backgroundColor: lightestTint,
//           ),
//           const SizedBox(
//             height: 4,
//           ),
//           Text(
//             user.name,
//             style: context.bodyMedium,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           Text(
//             "Request to join watch",
//             style: context.bodyMedium,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: AppButton(
//                   bgColor: lightestTint,
//                   title: "Reject",
//                   onPressed: () => rejectWatchRequest(user.id),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: AppButton(
//                   title: "Accept",
//                   onPressed: () => acceptWatchRequest(user.id),
//                 ),
//               ),
//             ],
//           )
//         ],
//       );
//     });
//   }

//   void createNewWatch(String callMode) async {
//     if (match == null) return;
//     final result = await context.pushNamedTo(InviteContactsScreen.route,
//         args: {"users": watchers, "link": watchLink});
//     if (result != null) {
//       final selectedUsers = result["contacts"] as List<User>;
//       if (selectedUsers.isNotEmpty) {
//         createWatch(match!, selectedUsers, callMode);
//       }
//     }
//   }

//   void inviteSelectedWatchers(List<User> users) async {
//     if (currentWatch == null) return;
//     final newUsers = users
//         .where((user) =>
//             watchers.indexWhere((element) => element.id == user.id) == -1)
//         .toList();
//     if (newUsers.isNotEmpty) {
//       addWatchers(currentWatch!, users);
//     }
//   }

//   void gotoaddWatchers() async {
//     // if (!isCreator) {
//     //   invitedWatchers.clear();
//     // }
//     final result = await context.pushNamedTo(InviteContactsScreen.route,
//         args: {"users": watchers, "link": watchLink});
//     if (result != null) {
//       inviteSelectedWatchers(result["contacts"]);
//     }
//   }

//   void gotoJoinWatch() async {
//     // if (isCreator) {
//     //   invitedWatchers.clear();
//     // }
//     final result = await context.pushNamedTo(JoinWatchScreen.route);
//     if (result != null) {
//       joinWatch(result["watch"]);
//     }
//   }

//   void copyWatchLink() {}
//   void shareWatchLink() {}

//   void cancelJoinRequest() async {
//     if (requestedWatch == null) return;
//     final result = await context.showComfirmationDialog("Cancel Join Request",
//         "Are you sure you want to cancel this join request?");
//     if (!result) return;
//     rejectOrLeaveWatch(requestedWatch!, null);
//   }

//   void joinWatch(Watch watch) async {
//     if (watch.joinPrivacy == "invited") {
//       return;
//     }
//     if (watch.joinPrivacy == "accepted") {
//       await requestToJoinWatch(watch);
//       requestedWatch = watch;
//       watcherSub = streamWatcher(watch.id, myId).listen((watcher) async {
//         if (watcher == null) {
//           watcherSub?.cancel();
//           watcherSub = null;
//           requestedWatch = null;
//         } else {
//           if (watcher.status == "current" && currentWatch != null) {
//             requestedWatch = null;
//             await rejectOrLeaveWatch(currentWatch!, myId);
//             await acceptOrJoinWatch(watch, myId, getCallMode(watchers));
//           }
//         }

//         setState(() {});
//       });
//     } else {
//       acceptOrJoinWatch(watch, myId, getCallMode(watchers));
//     }
//   }

//   void leaveWatch() async {
//     if (currentWatch == null) {
//       context.pop();
//       return;
//     }

//     final result = await context.showComfirmationDialog(
//         "Leave ${isMyWatchAndNotRequesting ? "Match" : "Watch"}",
//         "Are you sure you want to leave this ${isMyWatchAndNotRequesting ? "match" : "watch"}?");
//     if (!result) return;

//     await rejectOrLeaveWatch(currentWatch!, myId);
//     if (isMyWatchAndNotRequesting) {
//       if (!mounted) return;
//       context.pop();
//     }

//     // if (canPop) {
//     //   if (currentWatch == null) return;
//     //   rejectOrLeaveWatch(currentWatch!, myId);
//     //   return;
//     // }
//     // if (currentWatch == null) {
//     //   await context.showComfirmationDialog(
//     //       "Leave Match", "Are you sure you want to leave this match?");
//     //   return;
//     // }
//     // final isOnlyMe =
//     //     currentWatch!.creatorId == myId && currentWatch!.watchers.length <= 1;
//     // final result = await context.showComfirmationDialog(
//     //     "Leave ${isOnlyMe ? "Match" : "Watch"}",
//     //     "Are you sure you want to leave this ${isOnlyMe ? "match" : "watch"}?");
//     // if (!result) return;
//     // canPop = result && isOnlyMe;
//     // rejectOrLeaveWatch(currentWatch!, myId);
//     // if (canPop) {
//     //   if (!mounted) return;
//     //   context.pop();
//     // }
//   }

//   void rejectWatchRequest(String userId) async {
//     if (currentWatch == null) return;
//     // final result = await context.showComfirmationDialog(
//     //     "Reject Watch", "Are you sure you want to reject this request?");
//     // if (!result) return;
//     rejectOrLeaveWatch(currentWatch!, userId);
//   }

//   void acceptWatchRequest(String userId) async {
//     if (currentWatch == null) return;
//     // final result = await context.showComfirmationDialog(
//     //     "Accept Watch", "Are you sure you want to accept this request?");
//     // if (!result) return;
//     acceptOrJoinWatch(currentWatch!, userId, getCallMode(watchers));
//   }

//   // void rejectWatch(Watch watch, Watch invite) {
//   //   rejectOrLeaveWatch(watch, invite);
//   // }

//   // void acceptWatch(Watch watch, Watch invite) {
//   //   acceptOrJoinWatch(watch, currentWatch, invite);
//   // }

//   void updateCreatorActionPressed(String type, String userId) {
//     if (currentWatch == null) return;
//     rejectOrLeaveWatch(currentWatch!, userId);

//     // if (type == "current") {
//     // } else if (type == "invite") {
//     //   rejectOrLeaveWatch(currentWatch!, null, userId: userId);
//     // } else {
//     //   rejectOrLeaveWatch(currentWatch!, null, userId: userId);
//     // }
//   }

//   void updateCreatorRightActionPressed(String type, String userId) {
//     if (currentWatch == null) return;
//     acceptOrJoinWatch(currentWatch!, userId, getCallMode(watchers));
//   }

//   void toggleMode() {
//     if (mode == "users") {
//       mode = "comments";
//     } else {
//       mode = "users";
//     }
//     setState(() {});
//   }

//   void toggleView() {
//     if (view == "grid") {
//       view = "list";
//     } else {
//       view = "grid";
//     }
//     setState(() {});
//   }

//   void toggleVideo() {
//     video = !video;
//     setState(() {});
//   }

//   void toggleSound() {
//     muted = !muted;
//     setState(() {});
//   }

//   bool get isMyWatchAndNotRequesting =>
//       requestedWatch == null &&
//       currentWatch != null &&
//       currentWatch!.creatorId == myId;

//   @override
//   Widget build(BuildContext context) {
//     // final user = ref.watch(userProvider);
//     final watch = ref.watch(watchProvider);
//     final match = ref.watch(matchProvider);

//     if (watch == null) {
//       this.match = match;
//     }
//     if (currentWatch?.id != watch?.id) {
//       updateWatch(watch);
//     }

//     return PopScope(
//       canPop: currentWatch == null || isMyWatchAndNotRequesting,
//       onPopInvoked: (pop) {
//         if (pop) return;
//         if (requestedWatch != null) {
//           cancelJoinRequest();
//         } else {
//           leaveWatch();
//         }
//       },
//       child: Scaffold(
//         // appBar: AppAppBar(
//         //   title:
//         //       match != null ? "${match!.homeName} vs ${match!.awayName}" : "",
//         // ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // AspectRatio(
//             //   aspectRatio: 16 / 9,
//             //   // child: loadingMatch
//             //   //     ? const Center(
//             //   //         child: CircularProgressIndicator(),
//             //   //       )
//             //   //     : streamLink != null && streamLink!.isNotEmpty
//             //   //         ? _chewieController != null
//             //   //             ? Chewie(
//             //   //                 controller: _chewieController!,
//             //   //               )
//             //   //             : null

//             //   //         // ? BetterWatcher.network(
//             //   //         //     streamLink!,
//             //   //         //     //  betterWatcherConfiguration: BetterWatcherConfiguration(),
//             //   //         //   )
//             //   //         : Center(
//             //   //             child: Padding(
//             //   //             padding: const EdgeInsets.all(8.0),
//             //   //             child: streamLink == null
//             //   //                 ? Text(
//             //   //                     "Stream link not available yet. Watch out for the match",
//             //   //                     style: context.bodySmall,
//             //   //                     textAlign: TextAlign.center)
//             //   //                 : const CircularProgressIndicator(),
//             //   //           )),
//             //   child: AppContainer(
//             //     color: lighterTint,
//             //   ),
//             // ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       WatcherHeading(
//                           type: "current", size: currentWatchers.length),
//                       WatchersListScreen(
//                         remoteRenderers: _remoteRenderers,
//                         isCreator: isCreator,
//                         watchers: currentWatchers,
//                         view: view,
//                         type: "current",
//                         onPressed: (userId) =>
//                             updateCreatorActionPressed("current", userId),
//                         onRightPressed: (userId) =>
//                             updateCreatorRightActionPressed("current", userId),
//                       ),
//                       if (requestedWatchers.isNotEmpty) ...[
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         WatcherHeading(
//                             type: "requested", size: requestedWatchers.length),
//                         WatchersListScreen(
//                           isCreator: isCreator,
//                           watchers: requestedWatchers,
//                           view: view,
//                           type: "request",
//                           onPressed: (userId) =>
//                               updateCreatorActionPressed("request", userId),
//                           onRightPressed: (userId) =>
//                               updateCreatorRightActionPressed(
//                                   "request", userId),
//                         ),
//                       ],
//                       if (invitedWatchers.isNotEmpty) ...[
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         WatcherHeading(
//                             type: "invited", size: invitedWatchers.length),
//                         WatchersListScreen(
//                           isCreator: isCreator,
//                           watchers: invitedWatchers,
//                           remoteRenderers: _remoteRenderers,
//                           view: view,
//                           type: "invite",
//                           onPressed: (userId) =>
//                               updateCreatorActionPressed("invite", userId),
//                           onRightPressed: (userId) =>
//                               updateCreatorRightActionPressed("invite", userId),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             AppContainer(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               alignment: Alignment.bottomCenter,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   AppContainer(
//                     // height: 50,
//                     width: double.infinity,
//                     child: requestedWatchers.isNotEmpty
//                         ? AppContainer(
//                             child: Text(
//                               "${requestedWatchers[0].user?.name}${requestedWatchers.length == 1 ? "" : " and ${requestedWatchers.length - 1}others"} is requesting to watch this match with you",
//                               style: context.bodyMedium,
//                               textAlign: TextAlign.center,
//                             ),
//                           )
//                         : currentWatchers.length > 1
//                             ? Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   IconButton(
//                                     onPressed: toggleVideo,
//                                     icon: Icon(
//                                       !video
//                                           ? EvaIcons.video_outline
//                                           : EvaIcons.video_off_outline,
//                                       size: 20,
//                                       color: white,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: toggleSound,
//                                     icon: Icon(
//                                       muted
//                                           ? EvaIcons.mic_outline
//                                           : EvaIcons.mic_off_outline,
//                                       size: 20,
//                                       color: white,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: toggleMode,
//                                     icon: Icon(
//                                       mode == "comments"
//                                           ? EvaIcons.people_outline
//                                           : EvaIcons.message_circle_outline,
//                                       size: 20,
//                                       color: white,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: toggleView,
//                                     icon: Icon(
//                                       view == "grid"
//                                           ? EvaIcons.list_outline
//                                           : EvaIcons.grid_outline,
//                                       size: 20,
//                                       color: white,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : isCreator
//                                 ? AppContainer(
//                                     borderRadius: BorderRadius.circular(30),
//                                     //height: 50,
//                                     padding: const EdgeInsets.only(left: 10),
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 4),
//                                     color: lightestTint,
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             watchLink,
//                                             style:
//                                                 context.bodyMedium?.copyWith(),
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                         IconButton(
//                                           onPressed: copyWatchLink,
//                                           icon: const Icon(
//                                             EvaIcons.copy_outline,
//                                             size: 20,
//                                           ),
//                                         ),
//                                         IconButton(
//                                           onPressed: shareWatchLink,
//                                           icon: const Icon(
//                                             EvaIcons.share_outline,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : requestedWatch != null
//                                     ? AppContainer(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8, horizontal: 10),
//                                         child: Text(
//                                           "Waiting to be let in...",
//                                           style: context.bodyMedium,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       )
//                                     : null,
//                   ),
//                   Row(
//                     children: [
//                       if (currentWatch == null)
//                         AppButton(
//                           bgColor: lightestTint,
//                           title: "Start Audio Watch",
//                           onPressed: () => createNewWatch("audio"),
//                         )
//                       else if (requestedWatch != null)
//                         Expanded(
//                           child: AppButton(
//                             bgColor: lightestTint,
//                             title: "Cancel Watch",
//                             onPressed: cancelJoinRequest,
//                           ),
//                         )
//                       else if (currentWatchers.length > 1)
//                         Expanded(
//                           child: AppButton(
//                             bgColor: lightestTint,
//                             title: "Leave Watch",
//                             onPressed: leaveWatch,
//                           ),
//                         ),
//                       // else
//                       //   Expanded(
//                       //     child: AppButton(
//                       //       bgColor: lightestTint,
//                       //       title: "Join Watch",
//                       //       onPressed: gotoJoinWatch,
//                       //     ),
//                       //   ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       if (currentWatch == null)
//                         AppButton(
//                           bgColor: lightestTint,
//                           title: "Start Video Watch",
//                           onPressed: () => createNewWatch("video"),
//                         )
//                       else if (isCreator ||
//                           invitePrivacy.contains(myId) ||
//                           invitePrivacy == "everyone")
//                         Expanded(
//                           child: AppButton(
//                             title: "Add Watchers",
//                             onPressed: gotoaddWatchers,
//                           ),
//                         ),
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

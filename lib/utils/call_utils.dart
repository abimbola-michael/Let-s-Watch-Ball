import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:watchball/utils/extensions.dart';

import '../features/watch/models/watcher.dart';
import '../features/watch/services/watch_service.dart';
import 'utils.dart';

class CallUtils {
  // videoRenderer for localPeer
  RTCVideoRenderer? _localRTCVideoRenderer;

  // videoRenderer for remotePeer
  final Map<String, RTCVideoRenderer> _remoteRTCVideoRenderers = {};

  // mediaStream for localPeer
  MediaStream? _localStream;

  // RTC peer connection
  final Map<String, RTCPeerConnection> _rtcPeerConnections = {};

  // list of rtcCandidates to be sent over signalling
  final Map<String, List<Map<String, dynamic>>> _rtcIceCandidates = {};
  final Map<String, List<Map<String, dynamic>>> _myrtcIceCandidates = {};

  final Map<String, String> _peersOffersOrAnswers = {};

  // media status
  String? callMode;
  bool isAudioOn = true,
      isVideoOn = false,
      isFrontCameraSelected = true,
      isOnHold = false,
      isOnSpeaker = false;

  //signal
  StreamSubscription? signalSub;

  //state

  StreamController<VoidCallback>? _setStateController;
  Stream<VoidCallback>? setStateStream;

  //Watch

  String _watchId = "";
  final List<Watcher> _watchers = [];

  CallUtils() {
    _setStateController = StreamController.broadcast();
  }

  Future executeCallAction(Watcher watcher, [bool removed = false]) async {
    void removeWatcher() {
      if (watcher.id == myId) {
        disposeCall();
      } else {
        _disposePeer(watcher.id);
        //_disposeForUser(watcher.id);
      }
      setState(() {});
    }

    void addOrUpdateWatcher([Watcher? prevWatcher]) async {
      final callMode = watcher.callMode;
      final isVideoOn = callMode == "video";
      final isAudioOn = watcher.isAudioOn ?? true;
      final isFrontCameraSelected = watcher.isFrontCamera ?? true;
      final isOnHold = watcher.isOnHold ?? false;

      final currentWatchers =
          _watchers.where((element) => element.callMode != null).toList();
      if (currentWatchers.length <= 1) return;

      if (watcher.id != myId) {
        if (prevWatcher != null) {
          if (prevWatcher.callMode != watcher.callMode ||
              (prevWatcher.status != watcher.status &&
                  watcher.status == "current")) {
            print("newCallMode");
            _sendOffer(watcher.id, watcher.callMode == "video");
            // if (_peerConnections[watcher.id] == null) {
            //   sendOffer(watcher.id);
            // } else {
            //   togglePeerVideo(watcher.id, watcher.callMode == "video");
            // }
          }
          // else if (prevWatcher.isOnHold != watcher.isOnHold) {
          //   togglePeerHold(watcher.id, isOnHold);
          // } else if (prevWatcher.isAudioOn != watcher.isAudioOn) {
          //   togglePeerMute(watcher.id, isAudioOn);
          // }
        }
        // else {
        //_listenForSignalingMessages();
        // }
      } else {
        if (prevWatcher != null) {
          if (prevWatcher.callMode != watcher.callMode) {
            //setUpLocal();
            if (_localStream == null) {
              //initCall();
            } else {
              //_initializeLocalStream();
              //toggleVideoTrack(watcher.callMode == "video");
            }
          }
          // else if (prevWatcher.isOnHold != watcher.isOnHold) {
          //   toggleHold();
          // } else if (prevWatcher.isAudioOn != watcher.isAudioOn) {
          //   toggleMute();
          // }
        }

        this.callMode = callMode;
        this.isVideoOn = isVideoOn;
        this.isAudioOn = isAudioOn;
        this.isFrontCameraSelected = isFrontCameraSelected;
        this.isOnHold = isOnHold;
        setState(() {});
      }
    }

    if (removed) {
      final prevWatcher =
          _watchers.firstWhere((element) => element.id == watcher.id);
      _watchers.removeWhere((element) => element.id == watcher.id);

      if (prevWatcher.callMode != null) {
        removeWatcher();
      }
    } else {
      final prevWatcherIndex =
          _watchers.indexWhere((element) => element.id == watcher.id);
      if (prevWatcherIndex != -1) {
        final prevWatcher = _watchers[prevWatcherIndex];
        _watchers[prevWatcherIndex] = watcher;
        if (watcher.callMode != null) {
          addOrUpdateWatcher(prevWatcher);
        } else {
          removeWatcher();
        }
      } else {
        _watchers.add(watcher);
        if (watcher.callMode != null) {
          addOrUpdateWatcher();
        }
      }
    }
  }

  void initCall(String watchId) {
    _watchId = watchId;
    // setUpLocal();
    // setup Peer Connection
    //_setupPeerConnection();
    _listenForSignalingMessages();
    print("initCall = $_watchId");
  }

  void disposeCall() {
    _watchId = "";
    _localRTCVideoRenderer?.dispose();
    _remoteRTCVideoRenderers.forEach((key, value) {
      value.dispose();
    });
    _localStream?.dispose();
    _rtcPeerConnections.forEach((key, value) {
      value.dispose();
    });
    _myrtcIceCandidates.clear();
    _rtcIceCandidates.clear();
    _peersOffersOrAnswers.clear();
    signalSub?.cancel();
    _localRTCVideoRenderer = null;
    _remoteRTCVideoRenderers.clear();
    _rtcPeerConnections.clear();
    _localStream = null;
    signalSub = null;
  }

  Future _disposePeer(String peerId) async {
    _rtcPeerConnections[peerId]?.dispose();
    _remoteRTCVideoRenderers[peerId]?.dispose();
    _rtcPeerConnections.remove(peerId);
    _remoteRTCVideoRenderers.remove(peerId);
    _rtcIceCandidates.remove(peerId);
    _myrtcIceCandidates.remove(peerId);
    _peersOffersOrAnswers.remove(peerId);
  }

  void dispose() {
    _setStateController?.close();
    disposeCall();
  }

  void setState(VoidCallback fn) {
    _setStateController?.sink.add(fn);
  }

  void _listenForSignalingMessages() async {
    if (signalSub != null) return;
    signalSub = streamChangeSignals(_watchId).listen((signalsChanges) async {
      for (int i = 0; i < signalsChanges.length; i++) {
        final signalChange = signalsChanges[i];
        final value = signalChange.value;
        // final type = data["type"];
        final id = value["id"];
        final isVideoOn = value["isVideoOn"];
        //print("signalChangeValue = $value");

        if (signalChange.added || signalChange.modified) {
          if (value["offer"] != null) {
            await _handleOffer(id, value["offer"], isVideoOn);
          } else if (value["answer"] != null) {
            await _handleAnswer(id, value["answer"]);
          }
          if (value["candidates"] != null) {
            await _handleCandidates(id, value["candidates"]);
          }
          // switch (type) {
          //   case 'offer':
          //     _handleOffer(id, data);
          //     break;
          //   case 'answer':
          //     _handleAnswer(id, data);
          //     break;
          //   case 'candidate':
          //     _handleCandidate(id, data["candidate"]);
          //     break;
          //   case 'candidates':
          //     _handleCandidates(id, data);
          //     break;
          // }
        } else if (signalChange.removed) {
          //_disposeForUser(id);
        }
      }
    });
  }

  RTCVideoRenderer? getMyRenderer() {
    return _localRTCVideoRenderer;
  }

  RTCVideoRenderer? getPeerRenderer(String peerId) {
    return _remoteRTCVideoRenderers[peerId];
  }

  Future setUpLocal() async {
    Watcher watcher = _watchers.firstWhere((element) => element.id == myId);
    final isVideoOn = watcher.callMode == "video";
    if (_localStream != null &&
        ((_localRTCVideoRenderer != null && isVideoOn) ||
            (_localRTCVideoRenderer == null && !isVideoOn))) {
      return;
    }

    await _localStream?.dispose();

    // get localStream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {
              'mandatory': {
                'minWidth':
                    '640', // Provide your own width, height and frame rate here
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'optional': [],
              'facingMode': isFrontCameraSelected ? 'user' : 'environment'
            }
          : false,
    });

    await _localRTCVideoRenderer?.dispose();
    _localRTCVideoRenderer = null;
    if (isVideoOn) {
      // initializing renderers
      _localRTCVideoRenderer = RTCVideoRenderer();
      await _localRTCVideoRenderer!.initialize();
      // set source for local video renderer
      _localRTCVideoRenderer!.srcObject = _localStream;
    }
    setState(() {});
  }

  Future _setupPeerConnection(String peerId, bool isVideoOn) async {
    await setUpLocal();

    // Watcher watcher = _watchers.firstWhere((element) => element.id == peerId);
    // final isVideoOn = watcher.callMode == "video";
    print("peerIsVideoOn = $isVideoOn");

    if (_rtcIceCandidates[peerId] == null) {
      _rtcIceCandidates[peerId] = [];
    }

    if (_rtcPeerConnections[peerId] != null) {
      await _rtcPeerConnections[peerId]!.dispose();
      _rtcPeerConnections.remove(peerId);
    }
    // create peer connection
    final rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': 'relay1.expressturn.com:3478',
          'username': 'efXSL61V62OGA1EXMU',
          'credential': 'l2gmKlFgQCZ8cSBm'
        },
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ],
      // 'iceCandidatePoolSize': 10,
      // 'iceTransportPolicy':
      //     'relay', // Or 'all' if you want all types of candidates
    });

    _rtcPeerConnections[peerId] = rtcPeerConnection;
    _storeCandidates(peerId);

    if (_remoteRTCVideoRenderers[peerId] != null) {
      await _remoteRTCVideoRenderers[peerId]!.dispose();
      _remoteRTCVideoRenderers.remove(peerId);
    }

    if (isVideoOn) {
      // initializing renderers
      final remoteRTCVideoRenderer = RTCVideoRenderer();
      await remoteRTCVideoRenderer.initialize();
      _remoteRTCVideoRenderers[peerId] = remoteRTCVideoRenderer;
      // set source for local video renderer
    }

    // listen for remotePeer mediaTrack event
    rtcPeerConnection.onTrack = (event) {
      if (event.track.kind == 'video') {
        _remoteRTCVideoRenderers[peerId]?.srcObject = event.streams[0];
      }
      setState(() {});
    };

    // // add mediaTrack to peerConnection
    _localStream!.getTracks().forEach((track) {
      rtcPeerConnection.addTrack(track, _localStream!);
    });

    setState(() {});
  }

  Future _storeCandidates(String peerId) async {
    print("_storeCandidates");
    if (_myrtcIceCandidates[peerId] == null) {
      _myrtcIceCandidates[peerId] = [];
    }
    // listen for local iceCandidate and add it to the list of IceCandidate
    final rtcPeerConnection = _rtcPeerConnections[peerId]!;
    //final iceCandidates = _rtcIceCandidates[peerId]!;

    rtcPeerConnection.onIceCandidate = (RTCIceCandidate candidate) async {
      //iceCandidates.add(candidate);
      _myrtcIceCandidates[peerId]!.add(candidate.toMap());
      await _sendCandidates(peerId);

      print("allCandidates = ${_myrtcIceCandidates[peerId]!.length}");
    };

    rtcPeerConnection.onIceGatheringState = (iceGatheringState) async {
      print("iceGatheringState = $iceGatheringState");

      if (iceGatheringState ==
          RTCIceGatheringState.RTCIceGatheringStateComplete) {}
    };

    rtcPeerConnection.onConnectionState = (onConnectionState) async {
      print("connectionState = $onConnectionState");

      if (onConnectionState ==
          RTCIceConnectionState.RTCIceConnectionStateFailed) {}
    };
  }

  Future _sendOffer(String peerId, bool isVideoOn) async {
    print("_sendOffer = $peerId");
    await _setupPeerConnection(peerId, isVideoOn);

    final rtcPeerConnection = _rtcPeerConnections[peerId]!;

    // // create SDP Offer
    RTCSessionDescription offer = await rtcPeerConnection.createOffer();

    // set SDP offer as localDescription for peerConnection
    await rtcPeerConnection.setLocalDescription(offer);

    // make a call to remote peer over signalling
    await addSignal(_watchId, peerId,
        {"offer": offer.toMap(), "isVideoOn": this.isVideoOn});
  }

  Future _handleOffer(
      String peerId, Map<String, dynamic> offer, bool isVideoOn) async {
    if (_peersOffersOrAnswers[peerId] == offer["sdp"]) {
      return;
    }
    _peersOffersOrAnswers[peerId] = offer["sdp"];

    print("_handleOffer = $peerId");

    await _setupPeerConnection(peerId, isVideoOn);
    final rtcPeerConnection = _rtcPeerConnections[peerId]!;

    // set SDP offer as remoteDescription for peerConnection
    await rtcPeerConnection.setRemoteDescription(
        RTCSessionDescription(offer["sdp"], offer["type"]));
    await _sendAnswer(peerId);
  }

  Future _sendAnswer(String peerId) async {
    print("_sendAnswer = $peerId");
    final rtcPeerConnection = _rtcPeerConnections[peerId]!;

    // create SDP answer
    RTCSessionDescription answer = await rtcPeerConnection.createAnswer();

    // set SDP answer as localDescription for peerConnection
    await rtcPeerConnection.setLocalDescription(answer);

    // send SDP answer to remote peer over signalling

    await addSignal(
        _watchId, peerId, {"answer": answer.toMap(), "isVideoOn": isVideoOn});
  }

  Future _handleAnswer(String peerId, Map<String, dynamic> answer) async {
    if (_peersOffersOrAnswers[peerId] == answer["sdp"]) {
      return;
    }
    _peersOffersOrAnswers[peerId] = answer["sdp"];

    print("_handleAnswer = $peerId");
    final rtcPeerConnection = _rtcPeerConnections[peerId]!;

    // set SDP answer as remoteDescription for peerConnection
    await rtcPeerConnection.setRemoteDescription(
      RTCSessionDescription(answer["sdp"], answer["type"]),
    );
  }

  Future _sendCandidates(String peerId) async {
    print("_sendCandidates = $peerId");
    final candidates = _myrtcIceCandidates[peerId]!;
    if (candidates.isEmpty) return;

    await addSignal(_watchId, peerId, {'candidates': candidates});
  }

  // _handleCandidate(String peerId, Map<String, dynamic> data) {
  //   print("_handleCandidate = $peerId");
  //   final rtcPeerConnection = _rtcPeerConnections[peerId]!;

  //   String? candidate = data["candidate"];
  //   String? sdpMid = data["sdpMid"];
  //   int? sdpMLineIndex = data["sdpMLineIndex"];

  //   // add iceCandidate
  //   rtcPeerConnection
  //       .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
  //   setState(() {});
  // }

  Future _handleCandidates(String peerId, List<dynamic> datas) async {
    print("_handleCandidates = $peerId, ${datas.length}");
    final rtcPeerConnection = _rtcPeerConnections[peerId];
    if (rtcPeerConnection == null) return;

    final start = _rtcIceCandidates[peerId]!.length;

    for (int i = start; i < datas.length; i++) {
      final data = datas[i];

      String? candidate = data["candidate"];
      String? sdpMid = data["sdpMid"];
      int? sdpMLineIndex = data["sdpMLineIndex"];

      // add iceCandidate
      await rtcPeerConnection
          .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
      _rtcIceCandidates[peerId]!.add(data);
    }
    setState(() {});
  }

  // _setupPeerConnection({Map<String, dynamic>? offer}) async {
  //   // create peer connection
  //   _rtcPeerConnection = await createPeerConnection({
  //     'iceServers': [
  //       {
  //         'urls': [
  //           'stun:stun1.l.google.com:19302',
  //           'stun:stun2.l.google.com:19302'
  //         ]
  //       }
  //     ]
  //   });

  //   // listen for remotePeer mediaTrack event
  //   _rtcPeerConnection!.onTrack = (event) {
  //     _remoteRTCVideoRenderer.srcObject = event.streams[0];
  //     setState(() {});
  //   };

  //   // get localStream
  //   _localStream = await navigator.mediaDevices.getUserMedia({
  //     'audio': isAudioOn,
  //     'video': isVideoOn
  //         ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
  //         : false,
  //   });

  //   // add mediaTrack to peerConnection
  //   _localStream!.getTracks().forEach((track) {
  //     _rtcPeerConnection!.addTrack(track, _localStream!);
  //   });

  //   // set source for local video renderer
  //   _localRTCVideoRenderer.srcObject = _localStream;
  //   setState(() {});

  //   // for Incoming call
  //   if (offer != null) {
  //     // listen for Remote IceCandidate
  //     socket!.on("IceCandidate", (data) {
  //       String candidate = data["iceCandidate"]["candidate"];
  //       String sdpMid = data["iceCandidate"]["id"];
  //       int sdpMLineIndex = data["iceCandidate"]["label"];

  //       // add iceCandidate
  //       _rtcPeerConnection!.addCandidate(RTCIceCandidate(
  //         candidate,
  //         sdpMid,
  //         sdpMLineIndex,
  //       ));
  //     });

  //     // set SDP offer as remoteDescription for peerConnection
  //     await _rtcPeerConnection!.setRemoteDescription(
  //       RTCSessionDescription(offer["sdp"], offer["type"]),
  //     );

  //     // create SDP answer
  //     RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

  //     // set SDP answer as localDescription for peerConnection
  //     _rtcPeerConnection!.setLocalDescription(answer);

  //     // send SDP answer to remote peer over signalling
  //     socket!.emit("answerCall", {
  //       "callerId": callerId,
  //       "sdpAnswer": answer.toMap(),
  //     });
  //   }
  //   // for Outgoing Call
  //   else {
  //     // listen for local iceCandidate and add it to the list of IceCandidate
  //     _rtcPeerConnection!.onIceCandidate =
  //         (RTCIceCandidate candidate) => _rtcIceCandidates.add(candidate);

  //     // when call is accepted by remote peer
  //     socket!.on("callAnswered", (data) async {
  //       // set SDP answer as remoteDescription for peerConnection
  //       await _rtcPeerConnection!.setRemoteDescription(
  //         RTCSessionDescription(
  //           data["sdpAnswer"]["sdp"],
  //           data["sdpAnswer"]["type"],
  //         ),
  //       );

  //       // send iceCandidate generated to remote peer over signalling
  //       for (RTCIceCandidate candidate in _rtcIceCandidates) {
  //         socket!.emit("IceCandidate", {
  //           "calleeId": calleeId,
  //           "iceCandidate": {
  //             "id": candidate.sdpMid,
  //             "label": candidate.sdpMLineIndex,
  //             "candidate": candidate.candidate
  //           }
  //         });
  //       }
  //     });

  //     // create SDP Offer
  //     RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();

  //     // set SDP offer as localDescription for peerConnection
  //     await _rtcPeerConnection!.setLocalDescription(offer);

  //     // make a call to remote peer over signalling
  //     socket!.emit('makeCall', {
  //       "calleeId": calleeId,
  //       "sdpOffer": offer.toMap(),
  //     });
  //   }
  // }

  // _leaveCall() {
  //   Navigator.pop(context);
  // }

  void leaveCall() async {
    //removeSignal(_watchId, myId);
    disposeCall();
    _watchers.clear();
    //await removeSignal(_watchId, myId);
    //executeCallAction(watcher, true);
  }

  toggleHold() {
    // change status
    isOnHold = !isOnHold;
    updateCallHold(_watchId, isOnHold);
    // enable or disable audio track
    _localStream?.getTracks().forEach((track) {
      track.enabled = isOnHold;
    });
    setState(() {});
  }

  toggleMic() {
    // change status
    isAudioOn = !isAudioOn;
    updateCallAudio(_watchId, isAudioOn);
    // enable or disable audio track
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  toggleCallMode() {
    // change status
    callMode = callMode == "audio" ? "video" : "audio";
    isVideoOn = !isVideoOn;
    updateCallMode(_watchId, callMode);

    // enable or disable video track
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  switchCamera() {
    // change status
    isFrontCameraSelected = !isFrontCameraSelected;
    updateCallCamera(_watchId, isFrontCameraSelected);

    // switch camera
    _localStream?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
    setState(() {});
  }

  toggleSpeaker() {
    isOnSpeaker = !isOnSpeaker;
    Helper.setSpeakerphoneOn(isOnSpeaker);
    setState(() {});
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Theme.of(context).colorScheme.background,
  //     appBar: AppBar(
  //       title: const Text("P2P Call App"),
  //     ),
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: Stack(children: [
  //               RTCVideoView(
  //                 _remoteRTCVideoRenderer,
  //                 objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
  //               ),
  //               Positioned(
  //                 right: 20,
  //                 bottom: 20,
  //                 child: SizedBox(
  //                   height: 150,
  //                   width: 120,
  //                   child: RTCVideoView(
  //                     _localRTCVideoRenderer,
  //                     mirror: isFrontCameraSelected,
  //                     objectFit:
  //                         RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
  //                   ),
  //                 ),
  //               )
  //             ]),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 IconButton(
  //                   icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
  //                   onPressed: _toggleMic,
  //                 ),
  //                 IconButton(
  //                   icon: const Icon(Icons.call_end),
  //                   iconSize: 30,
  //                   onPressed: _leaveCall,
  //                 ),
  //                 IconButton(
  //                   icon: const Icon(Icons.cameraswitch),
  //                   onPressed: _switchCamera,
  //                 ),
  //                 IconButton(
  //                   icon: Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
  //                   onPressed: _toggleCallMode,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

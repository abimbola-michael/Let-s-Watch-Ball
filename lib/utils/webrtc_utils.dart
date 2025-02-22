import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../features/watch/models/watcher.dart';
import '../features/watch/services/watch_service.dart';

class WebRTCCallUtils {
  //time
  Timer? audioProgressTimer;

//Call
  bool isSpeakerOn = false;
  bool isOnHold = false;
  String? callMode;
  bool calling = false;
  bool isAudioOn = true,
      isVideoOn = true,
      isFrontCameraSelected = true,
      isOnSpeaker = false;
  RTCVideoRenderer? _localRenderer;
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, List<Map<String, dynamic>>> _peerIceCandidates = {};

  final Map<String, String> videoOverlayVisibility = {};
  //final Map<String, List<RTCIceCandidate>> _rtcIceCandidates = {};
  MediaStream? _localStream;
  StreamSubscription? signalSub;

  final List<Watcher> _watchers = [];
  String _watchId = "";
  StreamController<VoidCallback>? _setStateController;
  Stream<VoidCallback>? setStateStream;

  WebRTCCallUtils() {
    _setStateController = StreamController.broadcast();
    setStateStream = _setStateController?.stream;
    //initCall();
  }
  void init(String watchId) {
    disposeCall();
    _watchId = watchId;
  }

  void dispose() {
    _setStateController?.close();
    disposeCall();
  }

  void setState(VoidCallback onSetState) {
    _setStateController?.sink.add(onSetState);
  }

  Future initCall() async {
    startAudioProgressTimer();
    _listenForSignalingMessages();
    await _initializeLocalStream();
  }

  void disposeCall() async {
    _localRenderer?.dispose();
    _localRenderer?.srcObject = null;
    videoOverlayVisibility.remove(myId);

    for (var renderer in _remoteRenderers.values) {
      renderer.dispose();
    }
    for (var pc in _peerConnections.values) {
      pc.dispose();
    }
    if (kIsWeb) {
      _localStream?.getTracks().forEach((track) => track.stop());
    }
    _localStream?.dispose();

    _remoteRenderers.clear();
    _peerConnections.clear();
    _peerIceCandidates.clear();

    videoOverlayVisibility.clear();
    signalSub?.cancel();
    signalSub = null;
    _localStream = null;
    _localRenderer = null;

    audioProgressTimer?.cancel();
    audioProgressTimer = null;
  }

  void _disposeForMe() {
    signalSub?.cancel();
    audioProgressTimer?.cancel();
    _localRenderer?.dispose();
    videoOverlayVisibility.remove(myId);
    _localStream?.dispose();
    signalSub = null;
    _localStream = null;
    _localRenderer = null;
    audioProgressTimer = null;
    _setStateController?.close();
    _setStateController = null;
  }

  Future _disposeForUser(String peerId) async {
    await _remoteRenderers[peerId]?.dispose();
    await _peerConnections[peerId]?.dispose();
    _remoteRenderers.remove(peerId);
    _peerConnections.remove(peerId);

    videoOverlayVisibility.remove(peerId);

    if (_peerConnections.isEmpty) {
      _disposeForMe();
    }
  }

  void startAudioProgressTimer() {
    if (audioProgressTimer != null) return;
    //audioProgressTimer?.cancel();
    audioProgressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      monitorAudioLevels();
    });
  }

  void monitorAudioLevels() async {
    for (var entry in _peerConnections.entries) {
      final pc = entry.value;
      final id = entry.key;
      var stats = await pc.getStats(null);
      for (var report in stats) {
        if (report.type == 'inbound-rtp' &&
            report.values['mediaType'] == 'audio') {
          var audioLevel = report.values['audioLevel'];
          final index = _watchers.indexWhere((element) => element.id == id);
          if (index != -1) {
            _watchers[index].audioLevel = audioLevel ?? 0;
          }
        }
      }
    }
    setState(() {});
  }

  Future executeCallAction(Watcher watcher, [bool removed = false]) async {
    void removeWatcher() {
      if (watcher.id == myId) {
        disposeCall();
      } else {
        _disposeForUser(watcher.id);
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
            //await _disposeForUser(watcher.id, false);
            if (_peerConnections[watcher.id] == null) {
              sendOffer(watcher.id);
            } else {
              togglePeerVideo(watcher.id, watcher.callMode == "video");
            }
          } else if (prevWatcher.isOnHold != watcher.isOnHold) {
            togglePeerHold(watcher.id, isOnHold);
          } else if (prevWatcher.isAudioOn != watcher.isAudioOn) {
            togglePeerMute(watcher.id, isAudioOn);
          }
        } else {
          _listenForSignalingMessages();
        }
      } else {
        if (prevWatcher != null) {
          if (prevWatcher.callMode != watcher.callMode) {
            if (_localStream == null) {
              initCall();
            } else {
              //_initializeLocalStream();
              toggleVideoTrack(watcher.callMode == "video");
            }
          } else if (prevWatcher.isOnHold != watcher.isOnHold) {
            toggleHold();
          } else if (prevWatcher.isAudioOn != watcher.isAudioOn) {
            toggleMute();
          }
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
        // _watchers[prevWatcherIndex] = watcher;
      } else {
        _watchers.add(watcher);
        if (watcher.callMode != null) {
          addOrUpdateWatcher();
        }
      }
    }
  }

  void startCall({String? callMode}) async {
    if (_watchId == "") return;
    final index = _watchers.indexWhere((element) => element.id == myId);
    if (index == -1) return;
    final watcher = _watchers[index];
    callMode ??= watcher.callMode == "audio" ? "video" : "audio";
    await updateCallMode(_watchId, callMode);
    executeCallAction(watcher.copyWith(callMode: callMode));
  }

  void leaveCall() async {
    if (_watchId == "") return;
    final index = _watchers.indexWhere((element) => element.id == myId);
    if (index == -1) return;
    final watcher = _watchers[index];
    //await endCall(_watchId);
    await removeSignal(_watchId, myId);
    executeCallAction(watcher, true);
  }

  void updateMyCallAction(String type,
      {String? callMode, bool? isAudioOn, bool? isOnHold}) async {
    final index = _watchers.indexWhere((element) => element.id == myId);
    if (index == -1) return;
    final watcher = _watchers[index];
    switch (type) {
      case "callMode":
        final newCallMode =
            callMode ?? (callMode == "audio" ? "video" : "audio");
        await updateCallMode(_watchId, newCallMode);
        executeCallAction(watcher.copyWith(callMode: newCallMode));
        print("newCallMode = $newCallMode");

      case "isAudioOn":
        final newIsAudioOn = isAudioOn ?? !(watcher.isAudioOn ?? false);
        await updateCallAudio(_watchId, newIsAudioOn);
        executeCallAction(watcher.copyWith(isAudioOn: newIsAudioOn));

      case "isOnHold":
        final newIsOnHold = isOnHold ?? !(watcher.isOnHold ?? false);

        await updateCallHold(_watchId, newIsOnHold);
        executeCallAction(watcher.copyWith(isOnHold: newIsOnHold));
    }
  }

  void updateMyCallMode([String? callMode]) async {
    updateMyCallAction("callMode", callMode: callMode);
  }

  void updateMyCallAudio([bool? isAudioOn]) async {
    updateMyCallAction("isAudioOn", isAudioOn: isAudioOn);
  }

  void updateMyCallHold([bool? isOnHold]) async {
    updateMyCallAction("isOnHold", isOnHold: isOnHold);
  }

  // Future executeCallAction(Watcher watcher, [bool isRemoved = false]) async {
  //   if (watch == null) return;
  //   final myCallMode = getMyCallMode(_watchers);

  //   if (isRemoved && callMode != null) {
  //     if (watcher.id == myId) {
  //       await _leaveCall();
  //       callMode = null;
  //       calling = false;
  //     } else {
  //       _disposeForUser(watcher.id);
  //       if (_watchers
  //           .where((element) =>
  //               element.id != myId && element.callMode == myCallMode)
  //           .isEmpty) {
  //         calling = false;
  //       }
  //     }
  //     return;
  //   }
  //   if (myCallMode == null) {
  //     if (callMode != null) {
  //       await _leaveCall();
  //       callMode = null;
  //       calling = false;
  //     }
  //   } else {
  //     if (watcher.id == myId && watcher.callMode != null) {
  //       if (callMode != null && callMode != watcher.callMode) {
  //         callMode = watcher.callMode;
  //         await updateCallMode(_watchId, callMode);
  //       } else {
  //         if (callMode == null) {
  //           callMode = watcher.callMode;
  //           await _startCall();
  //           final callers = _watchers
  //               .where((element) =>
  //                   element.id != myId && element.callMode == watcher.callMode)
  //               .toList();

  //           calling = callers.isNotEmpty;
  //         }
  //         //  else {
  //         //   _toggleCallMode();
  //         // }
  //       }
  //     } else {
  //       if (watcher.callMode == myCallMode) {
  //         //_disposeForUser(watcher.id);
  //         Helper.setSpeakerphoneOn(false);
  //         startAudioProgressTimer();
  //         sendOffer(watcher.id);
  //         calling = true;
  //       } else {
  //         if (callMode != null) {
  //           if (watcher.callMode == null) {
  //             _disposeForUser(watcher.id);
  //             if (_watchers
  //                 .where((element) =>
  //                     element.id != myId && element.callMode == myCallMode)
  //                 .isEmpty) {
  //               calling = false;
  //             }
  //           }
  //           // else {
  //           //   callMode = watcher.callMode;
  //           // }
  //         }
  //       }
  //     }
  //   }
  // }
  // void updateMyCallMode({String? callMode}) async {
  //   final index = _watchers.indexWhere((element) => element.id == myId);
  //   if (index == -1) return;
  //   final watcher = _watchers[index];
  //   watcher.callMode = callMode;
  //   await executeCallAction(_watchers[index]);
  //   setState(() {});
  // }

  // void toggleCall(String? callMode) async {
  //   updateMyCallMode(callMode: callMode);
  // }

  void toggleCamera() async {
    _switchCamera();
  }

  void toggleMute() async {
    _toggleMic();
  }

  void toggleHold() {
    _toggleHold();
  }

  // Future<void> selectAudioOutput(String deviceId) async {
  //   await navigator.mediaDevices
  //       .selectAudioOutput(AudioOutputOptions(deviceId: deviceId));
  // }

  // Future<void> selectAudioInput(String deviceId) =>
  //     NativeAudioManagement.selectAudioInput(deviceId);

  // Future<void> setSpeakerphoneOn(bool enable) =>
  //     NativeAudioManagement.setSpeakerphoneOn(enable);

  void _listenForSignalingMessages() async {
    if (signalSub != null) return;
    await signalSub?.cancel();
    signalSub = streamChangeSignals(_watchId).listen((signalsChanges) {
      for (int i = 0; i < signalsChanges.length; i++) {
        final signalChange = signalsChanges[i];
        final data = signalChange.value;
        final type = data["type"];
        final id = data["id"];

        if (signalChange.added || signalChange.modified) {
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
            case 'candidates':
              _handleCandidates(id, data['candidates']);
              break;
          }
        } else if (signalChange.removed) {
          //_disposeForUser(id);
        }
      }
    });
  }

  // Future<void> _initializeLocalStream() async {
  //   Watcher watcher = _watchers.firstWhere((element) => element.id == myId);
  //   final isVideoOn = watcher.callMode == "video";
  //   final isAudioOn = watcher.isAudioOn ?? true;

  //   if (_localStream != null &&
  //       ((_localRenderer != null && isVideoOn) ||
  //           (_localRenderer == null && !isVideoOn))) {
  //     return;
  //   }

  //   await _localStream?.dispose();

  //   final mediaConstraints = <String, dynamic>{
  //     'audio': isAudioOn,
  //     if (isVideoOn)
  //       'video': {
  //         'mandatory': {
  //           'minWidth':
  //               '640', // Provide your own width, height and frame rate here
  //           'minHeight': '480',
  //           'minFrameRate': '30',
  //         },
  //         'facingMode': isFrontCameraSelected ? 'user' : 'environment',
  //         'optional': [],
  //       }
  //   };
  //   _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

  //   _localRenderer?.srcObject = _localStream;

  //   if (isVideoOn) {
  //     if (_localRenderer == null) {
  //       _localRenderer = RTCVideoRenderer();
  //       videoOverlayVisibility[myId] = "show";
  //       await _localRenderer?.initialize();
  //       _localRenderer?.srcObject = _localStream;
  //     }
  //   } else {
  //     if (_localRenderer != null) {
  //       _localRenderer!.dispose();
  //       _localRenderer = null;
  //       videoOverlayVisibility.remove(myId);
  //     }
  //   }
  //   // _localStream!.getVideoTracks().forEach((track) {
  //   //   track.enabled = isVideoOn;
  //   // });
  //   setState(() {});
  // }

  Future<void> _initializeLocalRenderer() async {
    if (_localRenderer != null) return;
    _localRenderer = RTCVideoRenderer();
    videoOverlayVisibility[myId] = "show";
    await _localRenderer?.initialize();
  }

  Future<void> _initializeLocalStream() async {
    Watcher watcher = _watchers.firstWhere((element) => element.id == myId);
    final isVideoOn = watcher.callMode == "video";
    final isAudioOn = watcher.isAudioOn ?? true;

    // if (_localStream != null &&
    //     ((_localRenderer != null && isVideoOn) ||
    //         (_localRenderer == null && !isVideoOn))) {
    //   return;
    // }

    //await _localStream?.dispose();

    if (_localStream == null) {
      final mediaConstraints = <String, dynamic>{
        'audio': isAudioOn,
        'video': {
          'mandatory': {
            'minWidth':
                '640', // Provide your own width, height and frame rate here
            'minHeight': '480',
            'minFrameRate': '30',
          },
          'optional': [],
          'facingMode': isFrontCameraSelected ? 'user' : 'environment',
        }
      };
      _localStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);

      //await _initializeLocalRenderer();
      videoOverlayVisibility[myId] = "show";
      _localRenderer = RTCVideoRenderer();
      await _localRenderer!.initialize();

      _localRenderer!.srcObject = _localStream;
      //toggleVideoTrack(isVideoOn);
    }
    toggleVideoTrack(isVideoOn);
    // if (isVideoOn) {
    //   if (_localRenderer == null) {
    //     _localRenderer = RTCVideoRenderer();
    //     videoOverlayVisibility[myId] = "show";
    //     await _localRenderer?.initialize();
    //     _localRenderer?.srcObject = _localStream;
    //   }
    // } else {
    //   if (_localRenderer != null) {
    //     _localRenderer!.dispose();
    //     _localRenderer = null;
    //     videoOverlayVisibility.remove(myId);
    //   }
    // }
    // _localStream!.getVideoTracks().forEach((track) {
    //   track.enabled = isVideoOn;
    // });
    setState(() {});
  }

  void toggleVideoTrack(bool isVideoOn) async {
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    // if (isVideoOn) {
    //   if (_localRenderer == null) {
    //     _localRenderer = RTCVideoRenderer();
    //     videoOverlayVisibility[myId] = "show";
    //     await _localRenderer?.initialize();
    //     _localRenderer?.srcObject = _localStream;
    //   }
    // } else {
    //   if (_localRenderer != null) {
    //     _localRenderer!.dispose();
    //     _localRenderer = null;
    //     videoOverlayVisibility.remove(myId);
    //   }
    // }
    setState(() {});
  }

  // void toggleVideoTrack(bool isVideoOn) async {
  //   List<MediaStreamTrack> videoTracks =
  //       List.from(_localStream!.getVideoTracks());

  //   // Iterate through the copied list of video tracks
  //   for (var track in videoTracks) {
  //     track.enabled = isVideoOn;
  //     if (!isVideoOn) {
  //       // Disable each video track
  //       _localStream!.removeTrack(track);
  //     } else {
  //       // Re-enable each video track if it's not already in the stream
  //       if (!_localStream!.getVideoTracks().contains(track)) {
  //         _localStream!.addTrack(track);
  //       }
  //     }
  //   }

  //   if (isVideoOn) {
  //     if (_localRenderer == null) {
  //       _localRenderer = RTCVideoRenderer();
  //       videoOverlayVisibility[myId] = "show";
  //       await _localRenderer?.initialize();
  //       _localRenderer?.srcObject = _localStream;
  //     }
  //   } else {
  //     if (_localRenderer != null) {
  //       _localRenderer!.dispose();
  //       _localRenderer = null;
  //       videoOverlayVisibility.remove(myId);
  //     }
  //   }
  //   setState(() {});
  // }

  Future<void> _createPeerConnection(String peerId) async {
    Watcher watcher = _watchers.firstWhere((element) => element.id == peerId);
    final isVideoOn = watcher.callMode == "video";

    await initCall();
    // if (_peerConnections[peerId] != null &&
    //     ((_remoteRenderers[peerId] != null && isVideoOn) ||
    //         (_remoteRenderers[peerId] == null && !isVideoOn))) return;
    //await _peerConnections[peerId]?.dispose();

    if (_peerConnections[peerId] == null) {
      print("peerCreated");

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

      pc.onTrack = (event) async {
        if (event.track.kind == 'video') {
          if (!_remoteRenderers.containsKey(peerId)) {
            var renderer = RTCVideoRenderer();
            _remoteRenderers[peerId] = renderer;
            videoOverlayVisibility[peerId] = "faint";
            await _remoteRenderers[peerId]?.initialize();
          }
          _remoteRenderers[peerId]?.srcObject = event.streams[0];
          setState(() {});
        } else {
          if (_remoteRenderers.containsKey(peerId)) {
            _remoteRenderers[peerId]?.dispose();
            _remoteRenderers.remove(peerId);
            videoOverlayVisibility.remove(peerId);
            setState(() {});
          }
        }
      };
      _peerIceCandidates[peerId] = [];

      pc.onIceCandidate = (candidate) {
        print(
            "gottenCandidate = $candidate, length ${_peerIceCandidates[peerId]!.length}");
        _peerIceCandidates[peerId]!.add(candidate.toMap());
        addSignal(_watchId, peerId,
            {'type': 'candidate', 'candidate': candidate.toMap()});
      };

      // Detect when gathering is complete
      pc.onIceGatheringState = (iceGatheringState) {
        print("sendCandidates = $iceGatheringState");

        // if (iceGatheringState ==
        //     RTCIceGatheringState.RTCIceGatheringStateComplete) {
        //   addSignal(_watchId, peerId,
        //       {'type': 'candidates', 'candidates': _peerIceCandidates[peerId]});
        // }
      };

      _localStream?.getTracks().forEach((track) {
        pc.addTrack(track, _localStream!);
      });
    }

    togglePeerVideo(peerId, isVideoOn);

    setState(() {});
  }

  Future<void> togglePeerVideo(String peerId, bool isVideoOn) async {
    // List<MediaStreamTrack> videoTracks =
    //     List.from(_remoteRenderers[peerId]!.srcObject!.getVideoTracks());

    // // Iterate through the copied list of video tracks
    // for (var track in videoTracks) {
    //   track.enabled = isVideoOn;
    //   if (!isVideoOn) {
    //     // Disable each video track
    //     _remoteRenderers[peerId]!.srcObject!.removeTrack(track);
    //   } else {
    //     // Re-enable each video track if it's not already in the stream
    //     if (!_remoteRenderers[peerId]!
    //         .srcObject!
    //         .getVideoTracks()
    //         .contains(track)) {
    //       _remoteRenderers[peerId]!.srcObject!.addTrack(track);
    //     }
    //   }
    // }
    _remoteRenderers[peerId]?.srcObject?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  Future<void> togglePeerMute(String peerId, bool mute) async {
    _remoteRenderers[peerId]?.srcObject?.getAudioTracks().forEach((track) {
      track.enabled = !mute;
    });
  }

  Future<void> togglePeerHold(String peerId, bool hold) async {
    _remoteRenderers[peerId]?.srcObject?.getTracks().forEach((track) {
      track.enabled = !hold;
    });
  }

  // Future<void> togglePeerCamera(String peerId, bool isFrontCamera) async {
  //   _remoteRenderers[peerId]?.srcObject?.getVideoTracks().forEach((track) {
  //     // // ignore: deprecated_member_use
  //     // track.switchCamera();
  //     Helper.switchCamera(track);
  //   });
  // }

  _toggleMic() async {
    isAudioOn = !isAudioOn;

    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
    updateCallAudio(_watchId, isAudioOn);
  }

  _toggleHold([bool? hold]) async {
    isOnHold = hold ?? !isOnHold;

    _localStream?.getTracks().forEach((track) {
      track.enabled = !isOnHold;
    });
    setState(() {});
    updateCallHold(_watchId, isOnHold);
  }

  // _toggleCallMode() {
  //   isVideoOn = !isVideoOn;
  //   _localStream?.getVideoTracks().forEach((track) {
  //     track.enabled = isVideoOn;
  //   });
  //   setState(() {});
  // }

  _switchCamera() {
    isFrontCameraSelected = !isFrontCameraSelected;
    _localStream?.getVideoTracks().forEach((track) {
      // // ignore: deprecated_member_use
      // track.switchCamera();
      Helper.switchCamera(track);
    });
    setState(() {});
    updateCallCamera(_watchId, isFrontCameraSelected);
  }

  toggleSpeaker() async {
    isOnSpeaker = !isOnSpeaker;
    await Helper.setSpeakerphoneOn(isOnSpeaker);
    setState(() {});
  }

  // void toggleVideoAudio() {
  //   toggleCall(callMode == "voice" ? "video" : "voice");
  // }

  void pauseStream() {
    if (callMode == null) return;
    _toggleHold(true);
  }

  void resumeStream() {
    if (callMode == null) return;
    _toggleHold(false);
  }

  toggleVideoOverlayVisibility(String? userId) {
    if (userId == null) return;
    final visibility = videoOverlayVisibility[userId];
    switch (visibility) {
      case "show":
        videoOverlayVisibility[userId] = "faint";
        break;
      case "faint":
        videoOverlayVisibility[userId] = "hide";
        break;
      case "hide":
        videoOverlayVisibility[userId] = "show";
        break;
    }
    setState(() {});
  }

  double getVideoOverlayOpacity(String? userId) {
    if (userId == null) return 1;
    final visibility = videoOverlayVisibility[userId];
    switch (visibility) {
      case "show":
        return 1;
      case "faint":
        return 0.5;
      case "hide":
        return 0;
    }
    return 1;
  }

  Future sendOffer(String peerId) async {
    print("sendOffer");

    await _createPeerConnection(peerId);
    final pc = _peerConnections[peerId]!;

    var offer = await pc.createOffer();

    await pc.setLocalDescription(offer);
    await addSignal(_watchId, peerId, {'type': 'offer', 'sdp': offer.sdp});
  }

  Future sendAnswer(String peerId, String sdp) async {
    print("sendAnswer");

    bool justCreating = _peerConnections[peerId] == null;

    await _createPeerConnection(peerId);

    final pc = _peerConnections[peerId]!;

    await pc.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));

    var answer = await pc.createAnswer();

    await pc.setLocalDescription(answer);

    await addSignal(_watchId, peerId, {'type': 'answer', 'sdp': answer.sdp});

    if (justCreating) {
      await sendOffer(peerId);
    }
  }

  Future<void> _handleOffer(String peerId, String sdp) async {
    print("_handleOffer");

    await sendAnswer(peerId, sdp);
  }

  Future<void> _handleAnswer(String peerId, String sdp) async {
    print("_handleAnswer");

    await _createPeerConnection(peerId);
    final pc = _peerConnections[peerId]!;
    await pc.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
  }

  Future<void> _handleCandidate(String peerId, dynamic candidate) async {
    print("_handleCandidate = $candidate");

    //await _createPeerConnection(peerId);
    final pc = _peerConnections[peerId];
    var rtcCandidate = RTCIceCandidate(candidate['candidate'],
        candidate['sdpMid'], candidate['sdpMLineIndex']);
    if (pc == null) {
      print("peerNull");
    }
    await pc?.addCandidate(rtcCandidate);
  }

  Future<void> _handleCandidates(
      String peerId, List<dynamic> candidates) async {
    print("_handleCandidates = $candidates");

    await _createPeerConnection(peerId);
    for (final candidate in candidates) {
      final pc = _peerConnections[peerId]!;
      var rtcCandidate = RTCIceCandidate(candidate['candidate'],
          candidate['sdpMid'], candidate['sdpMLineIndex']);
      await pc.addCandidate(rtcCandidate);
    }
  }

  String? getWatcherIdFromIndex(int index) {
    return index < _watchers.length ? _watchers[index].id : null;
  }

  Watcher? getWatcherFromIndex(int index) {
    return index < _watchers.length ? _watchers[index] : null;
  }

  RTCVideoRenderer? getMyRenderer() {
    return _localRenderer;
  }

  RTCVideoRenderer? getPeerRenderer(String id) {
    return _remoteRenderers[id];
  }

  Widget? buildVideoView(int index) {
    if (_watchId.isEmpty || _watchers.isEmpty) return null;
    final watcherId = getWatcherIdFromIndex(index);
    if (watcherId == null ||
        (watcherId == myId && _localRenderer == null) ||
        (watcherId != myId && _remoteRenderers[watcherId] == null)) {
      return null;
    }
    return RTCVideoView(
      watcherId == myId ? _localRenderer! : _remoteRenderers[watcherId]!,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      // mirror: watcherId == myId && isFrontCameraSelected,
    );
  }
}

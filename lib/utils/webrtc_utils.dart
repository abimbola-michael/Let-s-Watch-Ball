import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:watchball/firebase/firestore_methods.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../features/watch/models/watcher.dart';
import '../features/watch/services/watch_service.dart';
import '../features/watch/utils/utils.dart';

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
  final Map<String, String> videoOverlayVisibility = {};
  //final Map<String, List<RTCIceCandidate>> _rtcIceCandidates = {};
  MediaStream? _localStream;
  StreamSubscription? signalSub;

  List<Watcher> _watchers = [];
  String _watchId = "";
  StreamController<VoidCallback>? _setStateController;
  Stream<VoidCallback>? setStateStream;

  WebRTCCallUtils() {
    _setStateController = StreamController.broadcast();
    setStateStream = _setStateController?.stream;
    //initCall();
  }
  void init(List<Watcher> watchers, String watchId) {
    disposeCall();
    //_watchers = watchers.where((element) => element.callMode != null).toList();
    _watchId = watchId;
    _watchers = watchers;
  }

  void dispose() {
    _setStateController?.close();
  }

  void setState(VoidCallback onSetState) {
    _setStateController?.sink.add(onSetState);
  }

  // void addListener(VoidCallback onSetState) {}
  Future initCall() async {
    await _initializeLocalStream();
  }

  void disposeCall() async {
    _localRenderer?.dispose();
    videoOverlayVisibility.remove(myId);

    for (var renderer in _remoteRenderers.values) {
      renderer.dispose();
    }
    for (var pc in _peerConnections.values) {
      pc.dispose();
    }
    _localStream?.dispose();

    _remoteRenderers.clear();
    _peerConnections.clear();
    videoOverlayVisibility.clear();
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

  void _disposeForUser(String peerId) async {
    _remoteRenderers[peerId]?.dispose();
    _peerConnections[peerId]?.dispose();
    _remoteRenderers.remove(peerId);
    _peerConnections.remove(peerId);
    videoOverlayVisibility.remove(peerId);

    if (_peerConnections.isEmpty) {
      _disposeForMe();
    }
  }

  void startAudioProgressTimer() {
    if (audioProgressTimer != null) return;
    audioProgressTimer?.cancel();
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
            _watchers[index].audioLevel = audioLevel;
          }
        }
      }
    }
    setState(() {});
  }

  Future executeCallAction(Watcher watcher, [bool removed = false]) async {
    final currentWatchers =
        _watchers.where((element) => element.callMode != null).toList();

    void removeWatcher() {
      if (watcher.id == myId) {
        _leaveCall();
      } else {
        _disposeForUser(watcher.id);
      }
    }

    void addOrUpdateWatcher([Watcher? prevWatcher]) {
      final callMode = watcher.callMode;
      final isVideoOn = callMode == "video";
      final isAudioOn = watcher.isAudioOn ?? false;
      final isFrontCameraSelected = watcher.isFrontCamera ?? false;
      final isOnHold = watcher.isOnHold ?? false;
      if (watcher.id != myId) {
        if (prevWatcher != null) {
          if (prevWatcher.callMode != watcher.callMode) {
            sendOffer(watcher.id);
          } else if (prevWatcher.isOnHold != watcher.isOnHold) {
            togglePeerHold(watcher.id, isOnHold);
          } else if (prevWatcher.isAudioOn != watcher.isAudioOn) {
            togglePeerMute(watcher.id, isAudioOn);
          }
        } else {
          sendOffer(watcher.id);
        }
      } else {
        if (this.callMode == null) {
          if (currentWatchers.isNotEmpty) _startCall(watcher.callMode!);
        } else {
          updateCallMode(_watchId, watcher.callMode);
        }
        this.callMode = callMode;
        this.isVideoOn = isVideoOn;
        this.isAudioOn = isAudioOn;
        this.isFrontCameraSelected = isFrontCameraSelected;
        this.isOnHold = isOnHold;
      }
    }

    if (removed) {
      final prevWatcher =
          _watchers.firstWhere((element) => element.id == watcher.id);
      if (prevWatcher.callMode != null) {
        removeWatcher();
      }
      _watchers.removeWhere((element) => element.id == watcher.id);
    } else {
      final prevWatcherIndex =
          _watchers.indexWhere((element) => element.id == watcher.id);
      if (prevWatcherIndex != -1) {
        final prevWatcher = _watchers[prevWatcherIndex];
        if (prevWatcher.callMode != watcher.callMode
            // ||
            //     prevWatcher.isOnHold != watcher.isOnHold ||
            //     prevWatcher.isAudioOn != watcher.isAudioOn
            ) {
          if (watcher.callMode != null) {
            addOrUpdateWatcher(prevWatcher);
          } else {
            removeWatcher();
          }
        }
        _watchers[prevWatcherIndex] = watcher;
      } else {
        if (watcher.callMode != null) {
          addOrUpdateWatcher();
        }
        _watchers.add(watcher);
      }
    }
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
  void updateMyCallMode({String? callMode}) async {
    final index = _watchers.indexWhere((element) => element.id == myId);
    if (index == -1) return;
    final watcher = _watchers[index];
    watcher.callMode = callMode;
    await executeCallAction(_watchers[index]);
    setState(() {});
  }

  void toggleCall(String? callMode) async {
    updateMyCallMode(callMode: callMode);
  }

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
    //await signalSub?.cancel();
    signalSub = streamChangeSignals(_watchId).listen((signalsChanges) {
      for (int i = 0; i < signalsChanges.length; i++) {
        final signalChange = signalsChanges[i];
        final data = signalChange.value;
        final type = data["type"];
        final id = data["id"];
        //print("signalChange = $signalChange");

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
          }
        } else if (signalChange.removed) {
          _disposeForUser(id);
        }
      }
    });
  }

  Future<void> _initializeLocalRenderer() async {
    if (_localRenderer != null) return;
    _localRenderer = RTCVideoRenderer();
    videoOverlayVisibility[myId] = "show";
    await _localRenderer?.initialize();
  }

  Future<void> _initializeLocalStream() async {
    isVideoOn = callMode == "video";

    if (_localStream != null &&
        ((_localRenderer != null && isVideoOn) ||
            (_localRenderer == null && !isVideoOn))) {
      return;
    }
    await _localStream?.dispose();
    //print("newisAudioOn = $isAudioOn");
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {
              'mandatory': {
                'minWidth': '640', // Adjust as needed
                'minHeight': '480', // Adjust as needed
                'minFrameRate': '15',
                'maxFrameRate': '30',
              },
              'facingMode': isFrontCameraSelected ? 'user' : 'environment',
              'optional': [],
            }
          //? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
    });
    if (isVideoOn) {
      await _initializeLocalRenderer();
    } else {
      if (_localRenderer != null) {
        _localRenderer!.dispose();
        _localRenderer = null;
        videoOverlayVisibility.remove(myId);
      }
    }
    _localRenderer?.srcObject = _localStream;
    setState(() {});
  }

  Future<void> _createPeerConnection(String peerId) async {
    Watcher watcher = _watchers.firstWhere((element) => element.id == peerId);
    final isVideoOn = watcher.callMode == "video";

    await initCall();
    if (_peerConnections[peerId] != null &&
        ((_remoteRenderers[peerId] != null && isVideoOn) ||
            (_remoteRenderers[peerId] == null && !isVideoOn))) return;

    await _peerConnections[peerId]?.dispose();

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

    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
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

  String _setMediaBitrate(String sdp, {int? audioBitrate, int? videoBitrate}) {
    var lines = sdp.split('\n');
    var newSdp = <String>[];

    bool videoBitrateSet = false;
    bool audioBitrateSet = false;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('m=video')) {
        newSdp.add(lines[i]);
        videoBitrateSet = true;
      } else if (lines[i].startsWith('m=audio')) {
        newSdp.add(lines[i]);
        audioBitrateSet = true;
      } else if (lines[i].startsWith('b=AS:') && lines[i].contains('video')) {
        // Skip existing video bitrate line to avoid duplication
        videoBitrateSet = false;
      } else if (lines[i].startsWith('b=AS:') && lines[i].contains('audio')) {
        // Skip existing audio bitrate line to avoid duplication
        audioBitrateSet = false;
      } else {
        newSdp.add(lines[i]);
      }
    }

    // Add or update bitrate lines
    if (videoBitrateSet) {
      newSdp.add('b=AS:${videoBitrate ?? 1000}'); // Add video bitrate line
    }
    if (audioBitrateSet) {
      newSdp.add('b=AS:${audioBitrate ?? 64}'); // Add audio bitrate line
    }

    return newSdp.join('\n');
  }

  Future _startCall(String callMode) async {
    if (_watchId == "") return;
    await startCall(_watchId, callMode);
    startAudioProgressTimer();
    _listenForSignalingMessages();
  }

  _leaveCall() async {
    await endCall(_watchId);
    await removeSignal(_watchId, myId);
    disposeCall();
    //context.pop();
  }

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

  void toggleVideoAudio() {
    toggleCall(callMode == "voice" ? "video" : "voice");
  }

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

  Future sendIceCandidates(String peerId) async {
    await _createPeerConnection(peerId);
    final pc = _peerConnections[peerId]!;
    pc.onIceCandidate = (candidate) {
      addSignal(_watchId, peerId,
          {'type': 'candidate', 'candidate': candidate.toMap()});
    };
  }

  Future sendOffer(String peerId) async {
    //_listenForSignalingMessages();
    bool justCreating = _peerConnections[peerId] == null;

    await _createPeerConnection(peerId);
    final pc = _peerConnections[peerId]!;

    var offer = await pc.createOffer();
    //RTCSessionDescription offer = await pc.createOffer();
    //offer.sdp = _setMediaBitrate(offer.sdp!, videoBitrate: 500); // 500 kbps

    await pc.setLocalDescription(offer);
    await addSignal(_watchId, peerId, {'type': 'offer', 'sdp': offer.sdp});
    if (justCreating) {
      sendIceCandidates(peerId);
    }
  }

  Future sendAnswer(String peerId, String sdp) async {
    //_listenForSignalingMessages();
    bool justCreating = _peerConnections[peerId] == null;

    await _createPeerConnection(peerId);

    final pc = _peerConnections[peerId]!;

    await pc.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));

    var answer = await pc.createAnswer();
    //RTCSessionDescription answer = await pc.createAnswer();
    //answer.sdp = _setMediaBitrate(answer.sdp!, videoBitrate: 500); // 500 kbps
    await pc.setLocalDescription(answer);

    await addSignal(_watchId, peerId, {'type': 'answer', 'sdp': answer.sdp});

    if (justCreating) {
      sendIceCandidates(peerId);

      await sendOffer(peerId);
    }
  }

  Future<void> _handleOffer(String peerId, String sdp) async {
    await sendAnswer(peerId, sdp);
  }

  Future<void> _handleAnswer(String peerId, String sdp) async {
    await _createPeerConnection(peerId);
    final pc = _peerConnections[peerId]!;
    await pc.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
  }

  Future<void> _handleCandidate(
      String peerId, Map<String, dynamic> candidate) async {
    await _createPeerConnection(peerId);
    final pc = _peerConnections[peerId]!;
    var rtcCandidate = RTCIceCandidate(candidate['candidate'],
        candidate['sdpMid'], candidate['sdpMLineIndex']);
    await pc.addCandidate(rtcCandidate);
  }

  String? getWatcherIdFromIndex(int index) {
    return index < _watchers.length ? _watchers[index].id : null;
  }

  Watcher? getWatcherFromIndex(int index) {
    return index < _watchers.length ? _watchers[index] : null;
  }

  RTCVideoRenderer? getVideoRender(String id) {
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

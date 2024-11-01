import '../../../utils/utils.dart';
import '../models/watch.dart';
import '../models/watcher.dart';

String getAction(List<Watcher> watchers) {
  String action = "";
  for (int i = 0; i < watchers.length; i++) {
    final watcher = watchers[i];
    if (action == "") {
      action = watcher.action ?? "pause";
    } else {
      if (action != watcher.action) {
        return "pause";
      }
    }
  }
  return action;
}

String? getMyCallMode(List<Watcher> watchers) {
  for (int i = 0; i < watchers.length; i++) {
    final watcher = watchers[i];
    if (watcher.id == myId) {
      return watcher.callMode;
    }
  }
  return null;
}

String getCallMode(List<Watcher> watchers) {
  String callMode = "";
  for (int i = 0; i < watchers.length; i++) {
    final watcher = watchers[i];

    if (callMode.isEmpty && watcher.callMode != null) {
      callMode = watcher.callMode ?? "audio";
    } else {
      if (callMode != watcher.callMode) {
        return "audio";
      }
    }
  }
  return callMode;
}

String getChangedMatch(List<Watcher> watchers) {
  String match = "";
  for (int i = 0; i < watchers.length; i++) {
    final watcher = watchers[i];
    if (match == "") {
      match = watcher.match ?? "";
    } else {
      if (match != watcher.match) {
        return "";
      }
    }
  }
  return match;
}

String getActionString(String? action) {
  return action == null
      ? ""
      : action == "start"
          ? "started"
          : action == "restart"
              ? "restarted"
              : action == "pause"
                  ? "paused"
                  : action;
}

String getWatchLink(Watch watch) {
  return "watchball.hms.com/${watch.id}";
}

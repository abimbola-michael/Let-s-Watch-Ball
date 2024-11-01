// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:watchball/shared/components/custom_gridview.dart';
// import 'package:watchball/features/watch/components/video_watcher_item.dart';
// import 'package:watchball/features/watch/components/watcher_item.dart';
// import 'package:watchball/utils/extensions.dart';
// import 'package:watchball/utils/utils.dart';

// import '../components/grid_watcher_item.dart';
// import '../../user/models/user.dart';
// import '../models/watcher.dart';

// class WatchersListScreen extends StatelessWidget {
//   final List<Watcher> watchers;
//   final Map<String, RTCVideoRenderer>? remoteRenderers;
//   final String view;
//   final void Function(Watcher watcher, String action) onPressed;
//   final bool isCreator;
//   const WatchersListScreen(
//       {super.key,
//       required this.watchers,
//       required this.view,
//       required this.onPressed,
//       this.remoteRenderers,
//       required this.isCreator});

//   @override
//   Widget build(BuildContext context) {
//     if (watchers.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Text(
//             "No Watchers",
//             style: context.bodySmall,
//           ),
//         ),
//       );
//     }
//     if (view == "grid") {
//       return CustomGridview(
//         gridCount:
//             remoteRenderers != null && remoteRenderers!.isNotEmpty ? 2 : 3,
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: watchers.length,
//         itemBuilder: (context, index) {
//           final watcher = watchers[index];
//           if (remoteRenderers != null && remoteRenderers!.isNotEmpty) {
//             return VideoWatcherItem(
//               isCreator: isCreator,
//               mirror: watcher.id == myId,
//               videoRenderer: remoteRenderers![watcher.id],
//               watcher: watcher,
//               onPressed: (action) => onPressed(watcher, action),
//             );
//           }
//           return GridWatcherItem(
//             isCreator: isCreator,
//             watcher: watcher,
//             onPressed: (action) => onPressed(watcher, action),
//           );
//         },
//       );
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: watchers.length,
//       itemBuilder: (context, index) {
//         final watcher = watchers[index];
//         if (remoteRenderers != null) {
//           return VideoWatcherItem(
//             isCreator: isCreator,
//             mirror: watcher.id == myId,
//             videoRenderer: remoteRenderers![watcher.id],
//             watcher: watcher,
//             onPressed: (action) => onPressed(watcher, action),
//           );
//         }
//         return WatcherItem(
//           isCreator: isCreator,
//           watcher: watcher,
//           onPressed: (action) => onPressed(watcher, action),
//         );
//       },
//     );
//   }
// }

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:watchball/theme/colors.dart';
// import 'package:watchball/utils/extensions.dart';

// import '../../../utils/utils.dart';
// import '../../match/utils/match_utils.dart';
// import '../models/watch_history.dart';

// class WatchHistoryItem extends StatelessWidget {
//   final WatchHistory watchHistory;
//   //final VoidCallback onPressed;
//   const WatchHistoryItem({super.key, required this.watchHistory});

//   void viewMatch() {}

//   @override
//   Widget build(BuildContext context) {
//     final matchInfo = getMatchInfo(watchHistory.match);
//     final homeName = matchInfo.homeName;
//     final homeLogo = matchInfo.homeLogo;
//     final awayName = matchInfo.homeName;
//     final awayLogo = matchInfo.awayLogo;

//     String myId = "You";
//     final ids = watchHistory.watchersIds;
//     ids.remove(myId);
//     final max = ids.length > 2 ? 2 : ids.length;
//     final firstSets = ids.sublist(0, max);
//     final others = ids.sublist(max);
//     final message = firstSets.isEmpty
//         ? ""
//         : ids.length == 1
//             ? " and ${firstSets[0]}"
//             : ids.length == 2
//                 ? ", ${firstSets[0]} and ${firstSets[1]}"
//                 : ", ${firstSets.join(", ")} and ${others.length} others";

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Flexible(
//                       flex: 1,
//                       child: Text(
//                         homeName,
//                         style: context.bodySmall
//                             ?.copyWith(fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     CachedNetworkImage(
//                       imageUrl: homeLogo,
//                       height: 16,
//                       width: 16,
//                     ),
//                     // Flag(
//                     //  homeLogo,
//                     //   size: 16,
//                     // ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     Text(
//                       "-",
//                       style: context.bodySmall
//                           ?.copyWith(fontWeight: FontWeight.w700),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     // Flag(
//                     //  teamTwoIcon,
//                     //   size: 16,
//                     // ),
//                     CachedNetworkImage(
//                       imageUrl: awayLogo,
//                       height: 16,
//                       width: 16,
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     Flexible(
//                       flex: 1,
//                       child: Text(
//                         awayName,
//                         style: context.bodySmall
//                             ?.copyWith(fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 width: 4,
//               ),
//               Text(
//                 "Full Time",
//                 style: context.bodySmall?.copyWith(color: primaryColor),
//               ),
//               // Text(
//               //       match.endTime.isNotEmpty
//               //           ? "FT"
//               //           : match.gameTime == 0
//               //               ? getTime(match.startTime.toDateTime)
//               //               : match.gameTime.toMinsOrSecs,
//               //       style: context.bodySmall?.copyWith(
//               //           color: match.gameTime > 0 && match.gameTime < 5400
//               //               ? primaryColor
//               //               : lighterTint),
//               //     ),
//             ],
//           ),
//           const SizedBox(
//             height: 2,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   "You$message watchHistory",
//                   style: context.bodySmall?.copyWith(color: lightTint),
//                 ),
//               ),
//               const SizedBox(
//                 width: 4,
//               ),
//               Text(
//                 "${getFullTime(watchHistory.createdAt.toDateTime)}-${getFullTime(watchHistory.endedAt.toDateTime)}",
//                 style:
//                     context.bodySmall?.copyWith(fontSize: 10, color: lightTint),
//               ),
//             ],
//           ),
//           // const SizedBox(
//           //   height: 2,
//           // ),
//           // Text(
//           //   "${match.competition} - ${match.stage}",
//           //   style: context.bodySmall?.copyWith(color: lighterTint),
//           // ),
//         ],
//       ),
//     );
//   }
// }

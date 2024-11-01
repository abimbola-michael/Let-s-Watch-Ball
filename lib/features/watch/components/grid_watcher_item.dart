// import 'package:flutter/material.dart';
// import 'package:watchball/shared/components/app_button.dart';
// import 'package:watchball/theme/colors.dart';
// import 'package:watchball/utils/extensions.dart';

// import '../../user/models/user.dart';
// import '../models/watcher.dart';
// import '../../user/mocks/users.dart';
// import '../../../utils/utils.dart';

// class GridWatcherItem extends StatelessWidget {
//   final Watcher watcher;
//   final void Function(String action) onPressed;
//   final bool isCreator;

//   const GridWatcherItem(
//       {super.key,
//       required this.watcher,
//       required this.onPressed,
//       required this.isCreator});

//   @override
//   Widget build(BuildContext context) {
//     if (watcher.user == null) {
//       return Container();
//     }
//     final user = watcher.user!;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundImage: AssetImage(user.photo.toJpg),
//           ),
//           const SizedBox(
//             width: 6,
//           ),
//           Text(
//             user.name,
//             style: context.bodyMedium?.copyWith(),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           if (isCreator && watcher.id != myId)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   AppButton(
//                     title: type == "current"
//                         ? "Kickout"
//                         : type == "invite"
//                             ? "Cancel"
//                             : "Reject",
//                     bgColor: lightestTint,
//                     onPressed: onPressed,
//                   ),
//                   if (type == "request")
//                     AppButton(
//                       margin: const EdgeInsets.only(left: 4),
//                       title: "Accept",
//                       bgColor: primaryColor,
//                       onPressed: onRightPressed,
//                     )
//                 ],
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }

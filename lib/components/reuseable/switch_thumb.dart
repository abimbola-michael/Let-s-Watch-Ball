// import 'package:flutter/material.dart';
// import 'package:watchball/components/components.dart';

// import '../../utils/colors.dart';

// class SwitchThumb extends StatelessWidget {
//   final String theme;
//   final String currentTheme;
//   final VoidCallback onPressed;
//   const SwitchThumb(
//       {super.key,
//       required this.theme,
//       required this.onPressed,
//       required this.currentTheme});

//   @override
//   Widget build(BuildContext context) {
//     return Button(
//       width: 34,
//       height: 34,
//       color: theme == currentTheme ? Colors.white : Colors.transparent,
//       shadows: theme == currentTheme
//           ? [
//               BoxShadow(
//                 blurRadius: 3.33,
//                 offset: const Offset(0, 1.6),
//                 color: shadowColor.withOpacity(0.06),
//               ),
//               BoxShadow(
//                 blurRadius: 5,
//                 offset: const Offset(0, 1.6),
//                 color: shadowColor.withOpacity(0.01),
//               ),
//             ]
//           : null,
//       isCircular: true,
//       onPressed: onPressed,
//       child: SvgAsset(
//         name: theme == currentTheme ? "${theme}_fill" : theme,
//         size: 18,
//         useTint: theme != currentTheme,
//         color: theme != currentTheme ? greyLow : null,
//       ),
//     );
//   }
// }

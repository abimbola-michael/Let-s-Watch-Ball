import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';

import '../../utils/colors.dart';
import 'app_container.dart';

class AppTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  const AppTabBar(
      {super.key,
      required this.tabs,
      this.selectedTab = 0,
      required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      height: 35,
      color: faintBlack,
      // margin: const EdgeInsets.all(2),
      borderRadius: BorderRadius.circular(26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          return InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {
              if (selectedTab == index) return;
              onTabChanged(index);
            },
            child: AppContainer(
              height: 35,
              //constraints: const BoxConstraints(minWidth: 130),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              borderRadius: BorderRadius.circular(26),
              color: selectedTab == index ? primaryColor : Colors.transparent,
              child: Text(
                tab,
                style: context.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// class AppTabBar extends StatefulWidget {
//   final List<String> tabs;
//   final int selectedTab;
//   final ValueChanged<int> onTabChanged;
//   const AppTabBar(
//       {super.key,
//       required this.tabs,
//       this.selectedTab = 0,
//       required this.onTabChanged});

//   @override
//   State<AppTabBar> createState() => _AppTabBarState();
// }

// class _AppTabBarState extends State<AppTabBar> {
//   int selectedTab = 0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     selectedTab = widget.selectedTab;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppContainer(
//       width: double.infinity,
//       height: 45,
//       color: faintBlack,
//       margin: const EdgeInsets.all(2),
//       borderRadius: BorderRadius.circular(26),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(widget.tabs.length, (index) {
//           final tab = widget.tabs[index];
//           return InkWell(
//             borderRadius: BorderRadius.circular(26),
//             onTap: () {
//               if (selectedTab == index) return;
//             },
//             child: AppContainer(
//               height: 35,
//               //constraints: const BoxConstraints(minWidth: 130),
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               borderRadius: BorderRadius.circular(26),
//               color: selectedTab == index ? primaryColor : Colors.transparent,
//               child: Text(
//                 tab,
//                 style: context.bodyMedium,
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

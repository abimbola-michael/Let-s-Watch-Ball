import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../utils/colors.dart';
import '../reuseable/app_container.dart';

class DateTabBar extends StatelessWidget {
  final ScrollController scrollController;
  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final bool reverse;
  const DateTabBar(
      {super.key,
      required this.scrollController,
      this.selectedTab = 0,
      required this.onTabChanged,
      required this.tabs,
      this.reverse = false});

  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();
    // final firstDayOfTheYear = DateTime(now.year, 1, 1);
    // final firstDayOfTheNextYear = DateTime(now.year + 1, 1, 1);

    // final days = firstDayOfTheNextYear.difference(firstDayOfTheYear).inDays;
    // final dates = List.generate(
    //     days, (i) => firstDayOfTheYear.add(Duration(days: i - 1)));
    return AppContainer(
        width: double.infinity,
        height: 35,
        color: faintBlack,
        //margin: const EdgeInsets.all(2),
        borderRadius: BorderRadius.circular(26),
        child: ListView.builder(
            reverse: reverse,
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final tab = tabs[index];
              return InkWell(
                key: Key(tab),
                borderRadius: BorderRadius.circular(26),
                onTap: () {
                  if (selectedTab == index) return;
                  onTabChanged(index);
                },
                child: TabItem(selected: selectedTab == index, tab: tab),
              );
            })
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(tabs.length, (index) {
        //     final tab = tabs[index];
        //     return InkWell(
        //       borderRadius: BorderRadius.circular(26),
        //       onTap: () {
        //         if (selectedTab == index) return;
        //         onTabChanged(index);
        //       },
        //       child: AppContainer(
        //         height: 35,
        //         //constraints: const BoxConstraints(minWidth: 130),
        //         padding: const EdgeInsets.symmetric(horizontal: 20),
        //         borderRadius: BorderRadius.circular(26),
        //         color: selectedTab == index ? primaryColor : Colors.transparent,
        //         child: Text(
        //           tab,
        //           style: context.bodyMedium,
        //         ),
        //       ),
        //     );
        //   }),
        // ),
        );
  }
}

class TabItem extends StatelessWidget {
  final bool selected;
  final String tab;

  const TabItem({
    super.key,
    required this.selected,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      height: 35,
      width: 100,
      borderRadius: BorderRadius.circular(26),
      color: selected ? primaryColor : Colors.transparent,
      child: Text(
        tab,
        style: context.bodyMedium,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// class DateTabBar extends StatefulWidget {
//   final List<String> tabs;
//   final int selectedTab;
//   final ValueChanged<int> onTabChanged;
//   const DateTabBar(
//       {super.key,
//       required this.tabs,
//       this.selectedTab = 0,
//       required this.onTabChanged});

//   @override
//   State<DateTabBar> createState() => _DateTabBarState();
// }

// class _DateTabBarState extends State<DateTabBar> {
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

import 'package:flutter/material.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

class SettingsCategoryItem extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SettingsCategoryItem(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.bodySmall?.copyWith(color: lighterTint),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';

import 'app_container.dart';
import 'button.dart';
import 'svg_asset.dart';

class AppTabItem extends StatelessWidget {
  final String icon;
  final bool selected;
  final int badgeCount;
  final VoidCallback onPressed;
  const AppTabItem({
    super.key,
    required this.icon,
    required this.selected,
    required this.onPressed,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Button(
          onPressed: onPressed,
          width: 40,
          height: 40,
          isCircular: true,
          color: selected ? primaryColor : Colors.transparent,
          child: SvgAsset(name: icon, color: selected ? black : lighterTint),
        ),
        if (badgeCount > 0)
          Positioned(
              right: 0,
              top: 0,
              child: AppContainer(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: primaryColor,
                child: Text(
                  badgeCount.toString(),
                  style:
                      context.bodyMedium?.copyWith(color: white, fontSize: 10),
                ),
              )),
      ],
    );
  }
}

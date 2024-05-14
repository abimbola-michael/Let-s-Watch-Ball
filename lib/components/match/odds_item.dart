import 'package:flutter/material.dart';
import 'package:watchball/components/reuseable/app_container.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';

class OddsItem extends StatelessWidget {
  final String title;
  final double odd;
  final VoidCallback onPressed;
  const OddsItem(
      {super.key,
      required this.title,
      required this.odd,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      color: faintTint,
      borderRadius: BorderRadius.circular(5),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   title,
          //   style: context.bodySmall?.copyWith(color: lighterTint),
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
          Text(
            "$odd",
            style: context.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';

class ProfileStatItem extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onPressed;
  const ProfileStatItem(
      {super.key,
      required this.title,
      required this.count,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: context.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w900, color: primaryColor),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            title,
            style: context.bodyMedium?.copyWith(),
          ),
        ],
      ),
    );
  }
}

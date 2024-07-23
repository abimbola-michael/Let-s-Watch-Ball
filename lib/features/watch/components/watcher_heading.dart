import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../theme/colors.dart';
import '../../../shared/components/app_container.dart';

class WatcherHeading extends StatelessWidget {
  final String type;
  final int size;
  const WatcherHeading({super.key, required this.type, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${type.capitalize} Watchers",
          style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          width: 4,
        ),
        AppContainer(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            "$size",
            style: context.bodySmall,
          ),
        ),
      ],
    );
  }
}

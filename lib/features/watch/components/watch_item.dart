import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../user/models/user.dart';
import '../../user/mocks/users.dart';
import '../../../shared/components/app_container.dart';

class WatchItem extends StatelessWidget {
  final Watch watch;
  final VoidCallback onPressed;
  final bool? selected;
  const WatchItem(
      {super.key, required this.watch, required this.onPressed, this.selected});

  @override
  Widget build(BuildContext context) {
    List<String> names = [];
    List<String> photos = [];
    for (var watcher in watch.watchers) {
      final user = watcher.user;
      if (user != null) {
        names.add(user.name);
        photos.add(user.photo);
      }
    }

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(userOne.photo.toJpg),
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names.join(", "),
                    style: context.bodyMedium?.copyWith(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${watch.watchers.length} watchers",
                    style: context.bodySmall?.copyWith(color: primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (selected != null) ...[
              const SizedBox(
                width: 6,
              ),
              AppContainer(
                isCircular: true,
                height: 24,
                width: 24,
                color: selected! ? primaryColor : transparent,
                borderColor: selected! ? primaryColor : lighterTint,
                child: selected!
                    ? const Icon(
                        EvaIcons.checkmark,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(
                width: 6,
              ),
            ]
            // const SizedBox(
            //   width: 6,
            // ),
            // AppButton(
            //   title: action.capitalize,
            //   bgColor: action == "accept" ? primaryColor : lightestTint,
            //   onPressed: onPressed,
            // )
          ],
        ),
      ),
    );
  }
}

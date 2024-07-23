import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../models/user.dart';
import '../mocks/users.dart';

class UserSelectItem extends StatelessWidget {
  final User user;
  final bool selected;
  final VoidCallback onPressed;
  const UserSelectItem(
      {super.key,
      required this.user,
      required this.selected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(user.photo.toJpg),
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
                    user.name,
                    style: context.bodyMedium?.copyWith(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.bio,
                    style: context.bodyMedium?.copyWith(color: lighterTint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            AppContainer(
              isCircular: true,
              height: 24,
              width: 24,
              color: selected ? primaryColor : transparent,
              borderColor: selected ? primaryColor : lighterTint,
              child: selected
                  ? const Icon(
                      EvaIcons.checkmark,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(
              width: 6,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/shared/components/button.dart';
import 'package:watchball/shared/components/profile_photo.dart';
import 'package:watchball/utils/extensions.dart';

import '../models/user.dart';
import '../../../theme/colors.dart';

class UserHorItem extends StatelessWidget {
  final User user;
  final bool closable;
  final VoidCallback? onClose;
  const UserHorItem(
      {super.key, required this.user, this.onClose, this.closable = true});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                ProfilePhoto(profilePhoto: user.photo, name: user.username),
                if (onClose != null && closable)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Button(
                      onPressed: onClose,
                      isCircular: true,
                      height: 20,
                      width: 20,
                      color: red,
                      child: const Icon(
                        EvaIcons.close,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            user.username,
            style: context.bodyMedium?.copyWith(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

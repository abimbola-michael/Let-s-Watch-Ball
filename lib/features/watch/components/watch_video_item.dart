import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/features/user/models/user.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

class WatchVideoItem extends StatelessWidget {
  final User user;
  final VoidCallback onPressed;
  const WatchVideoItem(
      {super.key, required this.user, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      height: double.infinity,
      width: double.infinity,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.all(1),
      child: Stack(
        children: [
          AppContainer(
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(user.photo.toJpg),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  user.name,
                  style: context.bodyMedium?.copyWith(color: white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

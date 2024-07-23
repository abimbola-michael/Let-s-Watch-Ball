import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/utils/extensions.dart';
import '../../../theme/colors.dart';
import '../../user/models/user.dart';

class ContactItem extends StatelessWidget {
  final User user;
  const ContactItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ],
      ),
    );
  }
}

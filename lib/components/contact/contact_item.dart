import 'package:flutter/material.dart';
import 'package:watchball/components/reuseable/app_button.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../models/user.dart';
import '../../utils/mockdatas/users.dart';

class ContactItem extends StatefulWidget {
  final User user;
  final String type;
  const ContactItem({super.key, required this.user, required this.type});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  String action = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    action = widget.type;
  }

  void toggleAction() {
    if (action == "request") {
      action = "accept";
    } else {
      action = "request";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(widget.user.photo.toJpg),
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
                  widget.user.name,
                  style: context.bodyMedium?.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.user.bio,
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
          AppButton(
            title: action.capitalize,
            bgColor: action == "accept" ? primaryColor : lightestTint,
            onPressed: toggleAction,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/user/enums/enums.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../shared/components/profile_photo.dart';
import '../models/phone_contact.dart';

class ContactItem extends StatelessWidget {
  final bool isInvite;
  final PhoneContact contact;
  final VoidCallback onPressed;
  final List<String> availablePlatforms;
  final void Function(String platform)? onShare;

  const ContactItem(
      {super.key,
      this.isInvite = false,
      required this.contact,
      required this.onPressed,
      required this.onShare,
      this.availablePlatforms = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ProfilePhoto(profilePhoto: "", name: contact.name ?? contact.phone),
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name ?? contact.phone,
                  style: context.bodyMedium?.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  contact.phone,
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
          if (contact.contactStatus == ContactStatus.requested || isInvite)
            if (availablePlatforms.contains("WhatsApp"))
              PopupMenuButton<String>(
                itemBuilder: (context) {
                  return availablePlatforms.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(
                        option,
                        style: context.bodySmall,
                      ),
                    );
                  }).toList();
                },
                onSelected: onShare,
                child: const AppButton(
                  title: "Invite",
                  wrapped: true,
                ),
              )
            else
              AppButton(
                title: "Invite",
                wrapped: true,
                onPressed: onPressed,
              )
          else if (contact.contactStatus == ContactStatus.unadded)
            AppButton(
              title: "Add",
              wrapped: true,
              onPressed: onPressed,
            )
        ],
      ),
    );
  }
}

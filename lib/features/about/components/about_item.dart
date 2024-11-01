import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

class AboutItem extends StatelessWidget {
  final String title;
  final String value;
  final bool editable;
  final VoidCallback? onEdit;
  const AboutItem(
      {super.key,
      required this.title,
      required this.value,
      required this.editable,
      this.onEdit});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.bodySmall?.copyWith(color: lightTint),
                ),
                if (value.isNotEmpty) ...[
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    value,
                    style: context.bodyMedium?.copyWith(),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              OctIcons.pencil,
              color: primaryColor,
            ),
            iconSize: 16,
          )
        ],
      ),
    );
  }
}

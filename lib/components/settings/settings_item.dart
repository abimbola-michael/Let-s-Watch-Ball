import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';

import '../../utils/colors.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: color,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: context.bodyMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

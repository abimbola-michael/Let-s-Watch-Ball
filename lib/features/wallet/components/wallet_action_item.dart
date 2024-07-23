import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/shared/components/button.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

class WalletActionItem extends StatelessWidget {
  final String title;
  //final IconData icon;
  final Color? color;
  final VoidCallback onPressed;
  const WalletActionItem(
      {super.key,
      required this.title,
      //  required this.icon,
      required this.onPressed,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      // height: context.widthPercent(30),
      width: 100,
      height: 35,
      borderRadius: BorderRadius.circular(20),
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: color ?? lightestTint,
      child: Text(
        title,
        style: context.bodyMedium?.copyWith(color: white),
      ),
    );
  }
}

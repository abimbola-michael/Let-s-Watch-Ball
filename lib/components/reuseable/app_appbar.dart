// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';

import '../../utils/utils.dart';
import 'app_back_button.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? trailing;
  final Widget? middle;
  final Widget? leading;
  final VoidCallback? onBackPressed;
  final bool hideBackButton;
  final Color? color;
  const AppAppBar({
    super.key,
    this.title,
    this.trailing,
    this.onBackPressed,
    this.hideBackButton = false,
    this.leading,
    this.middle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 + statusBarHeight,
      padding: EdgeInsets.only(left: 15, right: 15, top: statusBarHeight),
      child: SizedBox(
        height: 60,
        child: Stack(
          children: [
            if (middle != null)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: middle!,
                ),
              )
            else if (title != null)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    title!,
                    style: context.headlineSmall
                        ?.copyWith(color: color, fontSize: 18),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            if (!hideBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: leading ??
                    AppBackButton(
                      onPressed: onBackPressed,
                      color: color,
                    ),
              ),
            if (trailing != null)
              Align(
                alignment: Alignment.centerRight,
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60 + statusBarHeight);
}

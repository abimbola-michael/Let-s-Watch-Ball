import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/utils/extensions.dart';

import '../../theme/colors.dart';
import '../../utils/utils.dart';
import 'app_container.dart';

class AppSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onPressed;
  final VoidCallback? onCloseSearch;
  const AppSearchBar(
      {super.key,
      required this.hint,
      this.controller,
      this.onPressed,
      this.onCloseSearch,
      this.onChanged});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60 + statusBarHeight);
}

class _AppSearchBarState extends State<AppSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 + statusBarHeight,
      padding: EdgeInsets.only(left: 15, right: 15, top: statusBarHeight),
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: lightestTint,
      ),
      child: widget.controller != null || widget.onChanged != null
          ? Row(
              children: [
                if (widget.onCloseSearch != null)
                  IconButton(
                    onPressed: widget.onCloseSearch,
                    icon: const Icon(EvaIcons.arrow_back_outline),
                    color: tint,
                  ),
                Expanded(
                  child: TextField(
                    onTap: widget.onPressed,
                    controller: widget.controller,
                    onChanged: (value) {
                      setState(() {});
                      widget.onChanged?.call(value);
                    },
                    style: context.bodyMedium?.copyWith(color: tint),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget.hint,
                      hintStyle:
                          context.bodyMedium?.copyWith(color: lighterTint),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (widget.controller != null &&
                    widget.controller!.text.isNotEmpty)
                  IconButton(
                    onPressed: () => widget.controller?.clear(),
                    icon: const Icon(EvaIcons.close_outline),
                    color: tint,
                  ),
              ],
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onPressed,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  widget.hint,
                  style: context.bodyMedium?.copyWith(color: lighterTint),
                ),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60 + statusBarHeight);
}

import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';

import '../../theme/colors.dart';
import 'app_container.dart';

class AppSearchBar extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onPressed;
  const AppSearchBar(
      {super.key,
      required this.hint,
      this.controller,
      this.onPressed,
      this.onChanged});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      borderRadius: BorderRadius.circular(10),
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: lightestTint,
      child: widget.controller != null || widget.onChanged != null
          ? TextField(
              onTap: widget.onPressed,
              controller: widget.controller,
              onChanged: widget.onChanged,
              style: context.bodyMedium?.copyWith(color: tint),
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hint,
                hintStyle: context.bodyMedium?.copyWith(color: lighterTint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
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
}

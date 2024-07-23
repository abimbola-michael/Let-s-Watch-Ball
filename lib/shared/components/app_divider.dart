import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class AppDivider extends StatelessWidget {
  final double opacity;
  final Color color;
  const AppDivider({super.key, this.opacity = 0.1, this.color = black});

  @override
  Widget build(BuildContext context) {
    return Divider(color: color.withOpacity(opacity));
  }
}

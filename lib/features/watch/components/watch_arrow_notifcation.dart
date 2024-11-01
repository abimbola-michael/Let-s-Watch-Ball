import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/theme/colors.dart';

import '../../../utils/utils.dart';

class WatchArrowNotification extends StatelessWidget {
  final Watch watch;
  const WatchArrowNotification({super.key, required this.watch});

  @override
  Widget build(BuildContext context) {
    // final icon = watch.creatorId == myId
    //     ? EvaIcons.arrow_forward_outline
    //     : EvaIcons.arrow_back_outline;
    return Transform.rotate(
      angle: 45,
      child: Icon(
        watch.creatorId == myId
            ? EvaIcons.arrow_forward_outline
            : EvaIcons.arrow_back_outline,
        size: 10,
        color: watch.status == "missed" ? Colors.red : primaryColor,
      ),
    );
  }
}

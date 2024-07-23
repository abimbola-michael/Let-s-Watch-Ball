import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';

import '../../theme/colors.dart';
import '../../utils/utils.dart';

class TimerText extends StatefulWidget {
  final Duration duration;
  final Duration interval;
  final VoidCallback onComplete;
  const TimerText(
      {super.key,
      required this.duration,
      this.interval = const Duration(seconds: 1),
      required this.onComplete});

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  int time = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    time = widget.duration.inSeconds;
    timer = Timer.periodic(widget.interval, (timer) {
      if (!mounted || time <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        time--;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      durationToString(time),
      style: context.bodyMedium
          ?.copyWith(fontWeight: FontWeight.w500, color: primaryColor),
    );
  }
}

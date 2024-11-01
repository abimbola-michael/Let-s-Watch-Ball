import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/features/watch/components/watch_arrow_notifcation.dart';
import 'package:watchball/features/watch/models/watch.dart';
import 'package:watchball/features/watch/models/watch_record.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

class WatchRecordItem extends StatelessWidget {
  final Watch watch;
  final int index;
  final VoidCallback? onPressed;
  const WatchRecordItem(
      {super.key, required this.watch, this.onPressed, required this.index});

  String getDuration(WatchRecord record) {
    if (record.startedAt == null || record.endedAt == null) return "";
    int duration = int.parse(record.endedAt!) - int.parse(record.startedAt!);
    return ", ${(duration ~/ 1000).toDurationString()}";
  }

  @override
  Widget build(BuildContext context) {
    final record = watch.records[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          WatchArrowNotification(watch: watch),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                watch.creatorId == myId ? "Outgoing" : "Incoming",
                style:
                    context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "${record.createdAt.date}, ${record.createdAt.time}${getDuration(record)}",
                style: context.bodySmall?.copyWith(color: lighterTint),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

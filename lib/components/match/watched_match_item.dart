import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';

import '../../models/watched_match.dart';

class WatchedMatchItem extends StatelessWidget {
  final WatchedMatch match;
  //final VoidCallback onPressed;
  const WatchedMatchItem({super.key, required this.match});

  void viewMatch() {}

  @override
  Widget build(BuildContext context) {
    String myId = "You";
    final ids = match.usersIds.contains(" ")
        ? match.usersIds.split(" ")
        : [match.usersIds];
    ids.remove(myId);
    final max = ids.length > 2 ? 2 : ids.length;
    final firstSets = ids.sublist(0, max);
    final others = ids.sublist(max);
    final message = firstSets.isEmpty
        ? ""
        : firstSets.length == 1
            ? " and ${firstSets[0]}"
            : firstSets.length == 2
                ? ", ${firstSets[0]} and ${firstSets[1]}"
                : "${firstSets.join(", ")} and ${others.length} others";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  match.teamOne,
                  style:
                      context.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Flag(
                match.teamOneIcon,
                size: 24,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "-",
                style: context.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 4,
              ),
              Flag(
                match.teamTwoIcon,
                size: 24,
              ),
              const SizedBox(
                width: 4,
              ),
              Flexible(
                flex: 1,
                child: Text(
                  match.teamTwo,
                  style:
                      context.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "You$message watched",
            style: context.bodySmall?.copyWith(),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "${match.competition} - ${match.stage}",
            style: context.bodySmall?.copyWith(color: lighterTint),
          ),
        ],
      ),
    );
  }
}

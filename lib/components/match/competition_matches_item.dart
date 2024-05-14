import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/components/match/match_item.dart';
import 'package:watchball/models/competition.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:icons_plus/icons_plus.dart';

class CompetitionMatchesItem extends StatelessWidget {
  final Competition competition;
  const CompetitionMatchesItem({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flag(
              competition.logo,
              size: 24,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    competition.name,
                    style: context.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    competition.host,
                    style: context.bodySmall?.copyWith(color: lighterTint),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(OctIcons.arrow_right)
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(competition.matches.length, (index) {
            final match = competition.matches[index];
            return MatchItem(match: match);
          }),
        )
      ],
    );
  }
}

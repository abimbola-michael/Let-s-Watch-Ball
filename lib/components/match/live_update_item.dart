import 'package:flutter/material.dart';
import 'package:watchball/components/reuseable/app_container.dart';
import 'package:watchball/components/match/odds_item.dart';
import 'package:watchball/models/football_match.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';
import 'package:icons_plus/icons_plus.dart';

class LiveUpdateItem extends StatelessWidget {
  final FootballMatch match;
  final VoidCallback onPressed;
  const LiveUpdateItem(
      {super.key, required this.match, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(4),
      borderColor: lightestTint,
      borderRadius: BorderRadius.circular(5),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flag(
                      match.teamOneIcon,
                      size: 50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      match.teamOneName,
                      style: context.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "${match.teamOneScore}",
                      style: context.headlineSmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getTime(match.dateTime),
                      style: context.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      getDate(match.dateTime),
                      style: context.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flag(
                      match.teamTwoIcon,
                      size: 50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      match.teamTwoName,
                      style: context.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "${match.teamTwoScore}",
                      style: context.headlineSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: OddsItem(
                  title: match.teamOneName,
                  odd: match.teamOneOdds,
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: OddsItem(
                  title: "Draw",
                  odd: match.drawOdds,
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: OddsItem(
                  title: match.teamTwoName,
                  odd: match.teamTwoOdds,
                  onPressed: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

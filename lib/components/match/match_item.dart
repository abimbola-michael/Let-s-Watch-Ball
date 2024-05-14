import 'package:flutter/material.dart';
import 'package:watchball/components/reuseable/app_container.dart';
import 'package:watchball/components/reuseable/button.dart';
import 'package:watchball/components/match/odds_item.dart';
import 'package:watchball/models/football_match.dart';
import 'package:watchball/screens/match/match_info_screen.dart';
import 'package:watchball/utils/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';
import 'package:icons_plus/icons_plus.dart';

class MatchItem extends StatelessWidget {
  final FootballMatch match;
  const MatchItem({super.key, required this.match});

  void viewMatch(BuildContext context) {
    context.pushNamedTo(MatchInfoScreen.route, args: {"match": match});
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () => viewMatch(context),
      padding: const EdgeInsets.all(8),
      borderColor: lightestTint,
      borderRadius: BorderRadius.circular(5),
      margin: const EdgeInsets.symmetric(vertical: 10),
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
                      size: 24,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      match.teamOneName,
                      style: context.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (match.gameTime > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${match.teamOneScore}",
                            style:
                                context.headlineSmall?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          AppContainer(
                            height: 5,
                            width: 10,
                            borderRadius: BorderRadius.circular(10),
                            color: tint,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${match.teamTwoScore}",
                            style:
                                context.headlineSmall?.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    Text(
                      match.gameTime == 0
                          ? getTime(match.dateTime)
                          : match.gameTime < 5400
                              ? match.gameTime.toMinsOrSecs
                              : "Full Time",
                      style: context.bodySmall?.copyWith(color: lighterTint),
                    ),
                    // Text(
                    //   getTime(match.dateTime),
                    //   style: context.bodyMedium?.copyWith(),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   getDate(match.dateTime),
                    //   style: context.bodyMedium
                    //       ?.copyWith(fontWeight: FontWeight.w700),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flag(
                      match.teamTwoIcon,
                      size: 24,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      match.teamTwoName,
                      style: context.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (match.gameTime > 0 && match.gameTime < 90 * 60) ...[
            const SizedBox(
              height: 4,
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
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ],
      ),
    );
  }
}

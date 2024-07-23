import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/shared/components/button.dart';
import 'package:watchball/features/match/models/live_match.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';
import 'package:watchball/utils/utils.dart';

import '../../watch/screens/watch_match_screen.dart';

class LiveMatchItem extends StatelessWidget {
  //final bool isWatch;
  final LiveMatch match;
  final void Function(bool watching)? onWatching;
  const LiveMatchItem({super.key, required this.match, this.onWatching
      /*this.isWatch = false*/
      });

  // void viewMatch(BuildContext context) {
  //   context.pushNamedTo(MatchInfoScreen.route, args: {"match": match});
  // }

  void watchMatch(BuildContext context) async {
    onWatching?.call(true);
    await context.pushNamedTo(WatchMatchScreen.route, args: {"match": match});
    onWatching?.call(false);

    //context.pushNamedTo(MatchPaymentScreen.route, args: {"match": match});
  }

  @override
  Widget build(BuildContext context) {
    // int duration =
    //     match.endTime.isEmpty ? 0 : match.startTime.toInt - match.endTime.toInt;
    String homeScore = "";
    String awayScore = "";
    String gameTime = "";
    String half = "";
    final dateTime = getTimeZoneDateTime(match);
    String date = dateTime[0];
    String time = dateTime[1];
    //Kếtthúc

    bool finished = false;
    if (match.score != "-1" &&
        match.score.contains("-") &&
        match.score.split("-").length == 2) {
      // print(
      //     "score = ${match.score}, date = ${match.date} to $date, time = ${match.time} to $time");
      final scores = match.score.split("-");
      homeScore = scores[0].trim();
      awayScore = scores[1].trim();
    }
    if (match.status.contains(":")) {
      half = match.status[1];
      gameTime = match.status.substring(match.status.indexOf(":") + 1);
      if (gameTime.endsWith("'")) {
        gameTime.substring(0, gameTime.length - 1);
      } else {
        finished = true;
      }
    }

    return Button(
      onPressed: () => watchMatch(context),
      //onPressed: () => viewMatch(context),
      padding: const EdgeInsets.all(8),
      borderColor: lightestTint,
      borderRadius: BorderRadius.circular(5),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      imageUrl: match.homeLogo,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        match.homeName,
                        style: context.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (homeScore.isNotEmpty && awayScore.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            homeScore,
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
                            awayScore,
                            style:
                                context.headlineSmall?.copyWith(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    else
                      Text(
                        date,
                        style: context.headlineSmall?.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    Text(
                      gameTime.isNotEmpty
                          ? gameTime
                          : match.status == "UpComing"
                              ? time
                              : "Full Time",
                      style: context.bodySmall?.copyWith(
                          color:
                              gameTime.isNotEmpty ? primaryColor : lighterTint),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      imageUrl: match.awayLogo,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        match.awayName,
                        style: context.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // if (gameTime.isNotEmpty)
          //   AppButton(
          //     title: "Watch",
          //     margin: const EdgeInsets.symmetric(vertical: 4),
          //     radius: 8,
          //     onPressed: () => watchMatch(context),
          //   ),
        ],
      ),
    );
  }
}

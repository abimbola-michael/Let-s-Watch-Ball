import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../shared/components/app_container.dart';
import '../../../theme/colors.dart';
import '../../match/models/match_info.dart';

class PhotoOrFlagWidget extends StatelessWidget {
  final double size;
  final bool isMatch;
  final MatchInfo? info;
  final String? photo;
  final double borderWidth;
  const PhotoOrFlagWidget(
      {super.key,
      this.info,
      this.photo,
      this.borderWidth = 0,
      required this.size,
      required this.isMatch});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: size,
      height: size,
      isCircular: true,
      borderWidth: borderWidth,
      borderColor: tint,
      child: isMatch && info != null
          ? Column(
              children: [
                CachedNetworkImage(
                  imageUrl: info!.homeLogo,
                  height: size / 2,
                  width: size,
                ),
                CachedNetworkImage(
                  imageUrl: info!.awayLogo,
                  height: size / 2,
                  width: size,
                ),
              ],
            )
          : photo != null
              ? CachedNetworkImage(
                  imageUrl: photo!,
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                )
              : Container(),
    );
  }
}

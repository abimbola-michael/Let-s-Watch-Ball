import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../theme/colors.dart';

class ProfilePhoto extends StatelessWidget {
  final String name;
  final String profilePhoto;
  final double size;
  final bool isCircular;
  final bool isFill;

  const ProfilePhoto(
      {super.key,
      required this.profilePhoto,
      required this.name,
      this.size = 50,
      this.isCircular = true,
      this.isFill = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFill ? double.infinity : size,
      height: isFill ? double.infinity : size,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        // border: Border.all(
        //   color: lightestTint,
        // ),
        color: lightestTint,
        image: profilePhoto.isNotEmpty
            ? DecorationImage(
                image: CachedNetworkImageProvider(profilePhoto),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: profilePhoto.isNotEmpty
          ? null
          : Text(
              name.firstChar ?? "",
              style: const TextStyle(fontSize: 30, color: primaryColor),
            ),
    );
  }
}

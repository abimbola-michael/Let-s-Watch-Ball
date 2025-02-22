import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/utils/extensions.dart';

import '../../features/user/models/user.dart';
import '../../theme/colors.dart';
import '../../utils/utils.dart';
import 'custom_grid_builder.dart';

class WatchersProfilePhoto extends StatelessWidget {
  final bool withoutMyId;
  final List<User> users;
  final double size;
  const WatchersProfilePhoto(
      {super.key,
      required this.users,
      this.withoutMyId = false,
      this.size = 50});

  @override
  Widget build(BuildContext context) {
    List<User> users = withoutMyId
        ? this.users.where((user) => user.id != myId).toList()
        : this.users;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(
        //   color: lightestTint,
        // ),
      ),
      child: CustomGridBuilder(
        expandedWidth: true,
        expandedHeight: true,
        gridCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final profilePhoto = user.photo;
          final name = user.phoneName ?? user.name;
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
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
                : SizedBox(
                    child: Text(
                      name.firstChar ?? "",
                      style: const TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

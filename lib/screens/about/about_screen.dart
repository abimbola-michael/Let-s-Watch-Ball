import 'package:flutter/material.dart';
import 'package:watchball/components/about/about_item.dart';
import 'package:watchball/utils/extensions.dart';

import '../../components/profile/profile_stat_item.dart';
import '../../components/reuseable/app_container.dart';
import '../../utils/colors.dart';
import '../../utils/mockdatas/users.dart';

class AboutScreen extends StatefulWidget {
  final void Function(int index) onUpdateTab;
  const AboutScreen({super.key, required this.onUpdateTab});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          AppContainer(
            borderRadius: BorderRadius.circular(30),
            height: 100,
            width: 100,
            borderColor: lightTint,
            borderWidth: 5,
            image: AssetImage(userOne.photo.toJpg),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Abimbola Michael",
            style: context.headlineMedium?.copyWith(fontSize: 18),
          ),
          // Text(
          //   "Club: Real Madrid",
          //   style: context.bodyMedium?.copyWith(),
          // ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileStatItem(
                title: "Feeds",
                count: 100,
                onPressed: () => widget.onUpdateTab(1),
              ),
              const SizedBox(
                width: 20,
              ),
              ProfileStatItem(
                title: "Contacts",
                count: 650,
                onPressed: () => widget.onUpdateTab(2),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AboutItem(title: "My Football Nickname", value: "Rooney"),
              const AboutItem(title: "My Goat", value: "C Ronaldo"),
              const AboutItem(title: "My Club", value: "Real Madrid"),
              const AboutItem(
                  title: "My Best Player in Club", value: "Ronaldo"),
              const AboutItem(title: "My Country", value: "Argentina"),
              const AboutItem(
                  title: "My Best Player in Country", value: "Ronaldo"),
            ],
          ),
        ],
      ),
    );
  }
}

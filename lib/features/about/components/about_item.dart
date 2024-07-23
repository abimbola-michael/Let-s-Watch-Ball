import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

class AboutItem extends StatelessWidget {
  final String title;
  final String value;
  const AboutItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.bodyMedium?.copyWith(color: lightTint),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            value,
            style: context.bodyMedium?.copyWith(),
          ),
        ],
      ),
    );
  }
}

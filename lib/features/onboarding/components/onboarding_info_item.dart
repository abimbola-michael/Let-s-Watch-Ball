// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:watchball/features/onboarding/models/onboarding_info.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../theme/colors.dart';
import '../../../shared/components/app_container.dart';

class OnboardingInfoItem extends StatelessWidget {
  final OnboardingInfo onboardingInfo;
  const OnboardingInfoItem({
    super.key,
    required this.onboardingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppContainer(
                height: double.infinity,
                width: double.infinity,
                //  image: AssetImage(onboardingInfo.image.toPng),
                margin: EdgeInsets.only(bottom: 50),
                imageFit: BoxFit.fill,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                onboardingInfo.title,
                style: context.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                onboardingInfo.message,
                style: context.bodyMedium?.copyWith(color: lighterTint),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

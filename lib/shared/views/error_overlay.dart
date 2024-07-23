import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_button.dart';
import 'package:watchball/utils/extensions.dart';

import '../../theme/colors.dart';
import '../components/app_container.dart';
//import 'package:loading_animation_widget/loading_animation_widget.dart';

class ErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorOverlay({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      color: lighterBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: context.bodyMedium,
          ),
          if (onRetry != null)
            const AppButton(
              title: "Retry",
              wrapped: true,
              margin: EdgeInsets.symmetric(vertical: 4),
            )
        ],
      ),
      // child: LoadingAnimationWidget.threeRotatingDots(
      //   color: primaryColor,
      //   size: 50,
      // ),
    );
  }
}

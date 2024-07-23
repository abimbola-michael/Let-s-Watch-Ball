import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../components/app_container.dart';
//import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      color: lighterBlack,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
      // child: LoadingAnimationWidget.threeRotatingDots(
      //   color: primaryColor,
      //   size: 50,
      // ),
    );
  }
}

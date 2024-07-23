import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

class PaymentTypeItem extends StatelessWidget {
  final String type;
  final String message;
  final bool selected;
  final VoidCallback onPressed;
  const PaymentTypeItem(
      {super.key,
      required this.type,
      required this.onPressed,
      required this.selected,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      //behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: AppContainer(
          color: selected ? primaryColor : lightestTint,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                type,
                style: context.headlineSmall
                    ?.copyWith(color: selected ? white : tint, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                message,
                style: context.bodySmall
                    ?.copyWith(color: selected ? white : tint, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

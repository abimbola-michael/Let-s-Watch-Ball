import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_container.dart';
import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

class PaymentItem extends StatelessWidget {
  final String resolution;
  final double price;
  final String currency;
  final bool selected;
  final VoidCallback onPressed;
  const PaymentItem(
      {super.key,
      required this.resolution,
      required this.price,
      required this.currency,
      required this.onPressed,
      required this.selected});

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
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                resolution,
                style: context.headlineMedium
                    ?.copyWith(color: selected ? white : tint),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "$currency $price",
                style: context.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: selected ? white : tint,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

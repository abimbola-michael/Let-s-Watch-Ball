import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';
import '../../utils/colors.dart';
import 'app_button.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final List<String> actions;
  final List<Color>? actionsBgColors;
  final List<Color>? actionsTextColors;

  final List<VoidCallback?> onPresseds;
  final bool isColActions;
  final BuildContext dialogContext;
  const AppAlertDialog({
    super.key,
    required this.title,
    this.message,
    required this.actions,
    required this.onPresseds,
    this.actionsBgColors,
    this.actionsTextColors,
    this.isColActions = false,
    required this.dialogContext,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: context.widthPercent(10)),
        padding:
            const EdgeInsets.only(top: 20, right: 16, bottom: 16, left: 16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            if (message != null) ...[
              Text(
                message!,
                style: context.bodyMedium?.copyWith(color: lighterBlack),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
            if (isColActions)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(actions.length, (index) {
                  return AppButton(
                    color: actionsTextColors != null &&
                            actionsTextColors!.isNotEmpty &&
                            index < actionsTextColors!.length
                        ? actionsTextColors![index]
                        : null,
                    bgColor: actionsBgColors != null &&
                            actionsBgColors!.isNotEmpty &&
                            index < actionsBgColors!.length
                        ? actionsBgColors![index]
                        : actions.length > 1 && index == 1
                            ? Colors.transparent
                            : null,
                    title: actions[index],
                    onPressed: () {
                      if (index < onPresseds.length &&
                          onPresseds[index] != null) {
                        onPresseds[index]!();
                      } else {
                        dialogContext.pop();
                      }
                    },
                    margin: EdgeInsets.only(
                        right: index == actions.length - 1 ? 0 : 10),
                    wrapped: true,
                  );
                }),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: List.generate(actions.length, (index) {
                  return AppButton(
                    color: actionsTextColors != null &&
                            actionsTextColors!.isNotEmpty &&
                            index < actionsTextColors!.length
                        ? actionsTextColors![index]
                        : null,
                    bgColor: actionsBgColors != null &&
                            actionsBgColors!.isNotEmpty &&
                            index < actionsBgColors!.length
                        ? actionsBgColors![index]
                        : actions.length > 1 && index == 0
                            ? Colors.transparent
                            : null,
                    title: actions[index],
                    onPressed: () {
                      if (index < onPresseds.length &&
                          onPresseds[index] != null) {
                        onPresseds[index]!();
                      } else {
                        dialogContext.pop();
                      }
                    },
                    margin: EdgeInsets.only(
                        right: index == actions.length - 1 ? 0 : 10),
                    wrapped: true,
                  );
                }),
              )
          ],
        ),
      ),
    );
  }
}

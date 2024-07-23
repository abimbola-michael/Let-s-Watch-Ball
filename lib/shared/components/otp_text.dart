// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:watchball/theme/colors.dart';
import 'package:watchball/utils/extensions.dart';

import 'app_text_field.dart';

class OtpText extends StatefulWidget {
  final bool match;
  final void Function(String) onGetOtp;
  final int length;
  const OtpText({
    super.key,
    required this.onGetOtp,
    required this.length,
    required this.match,
  });

  @override
  State<OtpText> createState() => _OtpTextState();
}

class _OtpTextState extends State<OtpText> {
  final List<Widget> textfields = [];
  final List<TextEditingController> controllers = [];
  List<String> outputs = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      final controller = TextEditingController();
      outputs.add("");
      controllers.add(controller);
      textfields.add(Expanded(
        child: AppTextField(
            autoFocus: true,
            hideErrorText: true,
            controller: controller,
            alignment: Alignment.center,
            width: 65,
            inputType: TextInputType.number,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 28, color: black),
            hintText: "",
            onChanged: (value) {
              if (value.isNotEmpty) {
                final controller = controllers[i];
                controller.text = value.substring(value.length - 1);
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
                nextFocus(i);
              } else {
                prevFocus(i);
              }
              getResult();
            }),
      ));
    }
  }

  void getResult() {
    outputs = controllers.map((e) => e.text).toList();
    widget.onGetOtp(outputs.join());
  }

  void nextFocus(i) {
    if (i < widget.length - 1) {
      FocusScope.of(context).nextFocus();
      final controller = controllers[i + 1];
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
    if (i == widget.length - 1) {
      FocusScope.of(context).unfocus();
    }
  }

  void prevFocus(i) {
    if (i > 0) {
      FocusScope.of(context).previousFocus();
      final controller = controllers[i - 1];
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
    if (i == 0) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: textfields,
    );
  }
}

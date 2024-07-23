// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:watchball/utils/extensions.dart';

class EmptyListView extends StatelessWidget {
  final String message;
  const EmptyListView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.bodySmall,
      ),
    );
  }
}

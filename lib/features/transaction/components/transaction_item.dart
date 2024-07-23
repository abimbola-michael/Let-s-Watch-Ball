import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/features/transaction/models/transaction.dart';
import 'package:watchball/utils/extensions.dart';

import '../../../theme/colors.dart';
import '../../../utils/utils.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    String myId = "You";
    String toId = transaction.to;
    String fromId = transaction.from;
    String message = "";
    bool isDeficit = false;
    if (transaction.match.isNotEmpty) {
      message = "Watched ${transaction.match}";
      isDeficit = true;
    } else if (transaction.from.isEmpty) {
      message = "Deposited";
    } else if (fromId == myId) {
      message = "Transfered to $toId";
      isDeficit = true;
    } else {
      message = "Received from $fromId";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: context.bodyMedium?.copyWith(),
                ),
                // const SizedBox(
                //   height: 4,
                // ),
                Text(
                  "${isDeficit ? "-" : "+"}${transaction.currency}${transaction.amount}",
                  style: context.bodyMedium?.copyWith(
                      color: isDeficit ? Colors.red : primaryColor,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Text(
            getFullTime(
              DateTime.fromMillisecondsSinceEpoch(transaction.time.toInt),
            ),
            style: context.bodySmall?.copyWith(color: lighterTint),
          ),
        ],
      ),
    );
  }
}

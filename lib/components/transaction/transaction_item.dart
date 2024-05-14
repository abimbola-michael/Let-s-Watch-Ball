import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watchball/models/transaction.dart';
import 'package:watchball/utils/extensions.dart';

import '../../utils/colors.dart';
import '../../utils/utils.dart';

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
      message =
          "You used ${transaction.currency}${transaction.amount} from your wallet to watch ${transaction.match}";
      isDeficit = true;
    } else if (transaction.from.isEmpty) {
      message =
          "You deposited ${transaction.currency}${transaction.amount} to your wallet";
    } else if (fromId == myId) {
      message =
          "You transfered ${transaction.currency}${transaction.amount} to $toId's wallet";
      isDeficit = true;
    } else {
      message =
          "You received ${transaction.currency}${transaction.amount} from $fromId's wallet";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                message,
                style: context.bodyMedium
                    ?.copyWith(color: isDeficit ? Colors.red : tint),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                getTime(
                  DateTime.fromMillisecondsSinceEpoch(transaction.time.toInt),
                ),
                style: context.bodySmall?.copyWith(color: lighterTint),
              ),
            ],
          )
        ],
      ),
    );
  }
}

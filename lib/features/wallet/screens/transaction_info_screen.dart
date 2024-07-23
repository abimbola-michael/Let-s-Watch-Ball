import 'package:flutter/material.dart';
import 'package:watchball/shared/components/app_appbar.dart';
import 'package:watchball/features/transaction/models/transaction.dart';
import 'package:watchball/utils/extensions.dart';

class TransactionInfoScreen extends StatefulWidget {
  static const route = "/transaction-info";
  const TransactionInfoScreen({super.key});

  @override
  State<TransactionInfoScreen> createState() => _TransactionInfoScreenState();
}

class _TransactionInfoScreenState extends State<TransactionInfoScreen> {
  late Transaction transaction;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    transaction = context.args["transaction"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: "",
      ),
    );
  }
}

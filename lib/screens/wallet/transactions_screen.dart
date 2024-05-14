import 'package:flutter/material.dart';
import '../../components/transaction/transaction_item.dart';
import '../../models/transaction.dart';

class TransactionScreen extends StatefulWidget {
  final String type;
  const TransactionScreen({super.key, required this.type});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Transaction> transactions = [];
  //final _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // transactions = allTransactions;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionItem(transaction: transaction);
        });
  }
}

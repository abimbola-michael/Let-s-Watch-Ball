import '../models/transaction.dart';

List<Transaction> allTransactions = [
  Transaction(
    id: "",
    from: "You",
    to: "Tayo",
    match: "",
    status: "Successful",
    amount: 500,
    currency: "NGN",
    time: DateTime.now().millisecondsSinceEpoch.toString(),
  ),
  Transaction(
    id: "",
    from: "",
    to: "",
    match: "Brazil vs Argentina",
    status: "Successful",
    amount: 200,
    currency: "NGN",
    time: DateTime.now().millisecondsSinceEpoch.toString(),
  ),
  Transaction(
    id: "",
    from: "",
    to: "",
    match: "",
    status: "Successful",
    amount: 300,
    currency: "NGN",
    time: DateTime.now().millisecondsSinceEpoch.toString(),
  ),
  Transaction(
    id: "",
    from: "You",
    to: "Seyi",
    match: "",
    status: "Successful",
    amount: 2000,
    currency: "NGN",
    time: DateTime.now().millisecondsSinceEpoch.toString(),
  ),
];

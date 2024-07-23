// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Transaction {
  String id;
  String from;
  String to;
  String match;
  String status;
  double amount;
  String currency;
  String time;

  Transaction({
    required this.id,
    required this.from,
    required this.to,
    required this.match,
    required this.status,
    required this.amount,
    required this.currency,
    required this.time,
  });

  Transaction copyWith({
    String? id,
    String? from,
    String? to,
    String? match,
    String? status,
    double? amount,
    String? currency,
    String? time,
  }) {
    return Transaction(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      match: match ?? this.match,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'from': from,
      'to': to,
      'match': match,
      'status': status,
      'amount': amount,
      'currency': currency,
      'time': time,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      from: map['from'] as String,
      to: map['to'] as String,
      match: map['match'] as String,
      status: map['status'] as String,
      amount: map['amount'] as double,
      currency: map['currency'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, from: $from, to: $to, match: $match, status: $status, amount: $amount, currency: $currency, time: $time)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.from == from &&
        other.to == to &&
        other.match == match &&
        other.status == status &&
        other.amount == amount &&
        other.currency == currency &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        from.hashCode ^
        to.hashCode ^
        match.hashCode ^
        status.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        time.hashCode;
  }
}

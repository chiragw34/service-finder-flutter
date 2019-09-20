import './new_transaction.dart';
import './transaction_list.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class UserTransactions extends StatefulWidget {
  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
      amount: 68.99,
      id: 't1',
      title: 'New shoes',
      date: DateTime.now(),
    ),
    Transaction(
      amount: 79.99,
      id: 't2',
      title: 'New shirts',
      date: DateTime.now(),
    ),
    Transaction(
      amount: 89.99,
      id: 't3',
      title: 'New t shirts',
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );
    setState(
      () {
        _userTransactions.add(newTx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTransaction(_addNewTransaction),
        TransactionList(_userTransactions),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nevada/utils/num_utils.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

const typeRelationship = <TransactionType, String>{
  TransactionType.income: 'Income',
  TransactionType.expense: 'Expense'
};

const statusRelationship = <TransactionStatus, String>{
  TransactionStatus.paid: 'Paid',
  TransactionStatus.pending: 'Pending'
};

@HiveType(typeId: 7)
class Transaction extends HiveObject {
  @HiveField(0)
  String uuid;

  @HiveField(1)
  int amount;

  @HiveField(2)
  TransactionType type;

  @HiveField(3)
  String? deliveryUuid;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  TransactionStatus status;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String senderUuid; // Customer ID

  @HiveField(8)
  String? comment;

  Transaction(
      {required this.uuid,
      required this.amount,
      required this.type,
      required this.senderUuid,
      required this.deliveryUuid,
      required this.status,
      required this.createdAt});

  static Transaction empty() => Transaction(
      uuid: const Uuid().v4().toString(),
      amount: 0,
      type: TransactionType.income,
      senderUuid: '',
      deliveryUuid: '',
      status: TransactionStatus.pending,
      createdAt: DateTime.now());
}

@HiveType(typeId: 72)
enum TransactionType {
  @HiveField(0, defaultValue: true)
  income,
  @HiveField(1)
  expense
}

@HiveType(typeId: 75)
enum TransactionStatus {
  @HiveField(0, defaultValue: true)
  paid,
  @HiveField(1)
  pending
}

extension TransactionExtras on Transaction {
  MaterialStateProperty<Color> get rowColor {
    if (type == TransactionType.income) {
      if (status == TransactionStatus.pending) {
        return MaterialStatePropertyAll(Colors.orangeAccent.withOpacity(0.1));
      } else if (status == TransactionStatus.paid) {
        return MaterialStatePropertyAll(Colors.green.withOpacity(0.1));
      }
    }
    return const MaterialStatePropertyAll(Colors.white);
  }

  String get amountText {
    return '${amount.asMoney} MT';
  }
}

extension TransactionTypeName on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.income:
        return 'Entrée';
      case TransactionType.expense:
        return 'Dépense';
    }
  }

  Widget get icon {
    switch (this) {
      case TransactionType.income:
        return const Icon(Icons.trending_up, color: Colors.green);
      case TransactionType.expense:
        return const Icon(Icons.trending_down, color: Colors.redAccent);
    }
  }
}

extension TransactionStatusName on TransactionStatus {
  String get label {
    switch (this) {
      case TransactionStatus.paid:
        return 'Payé';
      case TransactionStatus.pending:
        return 'Crédit';
    }
  }

  Widget get labelWidget {
    switch (this) {
      case TransactionStatus.paid:
        return Text(label,
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold));
      case TransactionStatus.pending:
        return Text(label,
            style: const TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.bold));
    }
  }
}

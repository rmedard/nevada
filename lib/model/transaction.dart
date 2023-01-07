import 'package:hive/hive.dart';

part 'transaction.g.dart';

const typeRelationship = <TransactionType, String> {
  TransactionType.cash: 'Cash',
  TransactionType.debt: 'Debt'
};

const statusRelationship = <TransactionStatus, String> {
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
  String deliveryUuid;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  TransactionStatus status;

  @HiveField(6)
  DateTime createdAt;

  Transaction(
      {required this.uuid,
      required this.amount,
      required this.type,
      required this.deliveryUuid,
      required this.status,
      required this.createdAt});
}

@HiveType(typeId: 21)
enum TransactionType {
  @HiveField(0, defaultValue: true)
  cash,
  @HiveField(1)
  debt
}

@HiveType(typeId: 51)
enum TransactionStatus {
  @HiveField(0, defaultValue: true)
  paid,
  @HiveField(1)
  pending
}

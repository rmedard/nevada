
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nevada/utils/num_utils.dart';
import 'package:uuid/uuid.dart';

part 'customer.g.dart';

@HiveType(typeId: 1)
class Customer extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  String names;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String location;

  @HiveField(4, defaultValue: 0)
  int balance;

  @HiveField(5)
  DateTime? lastDeliveryDate;

  Customer({required this.uuid, required this.names, required this.phone, required this.location, required this.balance});

  static Customer empty() => Customer(uuid: const Uuid().v4(), names: '', phone: '', location: '', balance: 0);
}

extension CustomerBalanceText on Customer {
  Widget get balanceText {
    return Text(
      '${balance.asMoney} MT',
      style: TextStyle(
          color: balance < 0 ? Colors.redAccent : Colors.green,
          fontWeight: FontWeight.bold),
    );
  }

  int get debtAmount {
    return balance < 0 ? balance * -1 : 0;
  }
}
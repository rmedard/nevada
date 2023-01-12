import 'package:hive/hive.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery_line.dart';

part 'delivery.g.dart';

@HiveType(typeId: 3)
class Delivery extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  Customer customer;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  late HiveList<DeliveryLine> lines;

  Delivery({required this.uuid, required this.customer, required this.date});
}

import 'package:hive/hive.dart';
import 'package:nevada/model/customer.dart';
import 'package:nevada/model/delivery_line.dart';
import 'package:nevada/utils/constants.dart';

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
  HiveList<DeliveryLine> lines = HiveList(Hive.box<DeliveryLine>(boxNames[BoxNameKey.deliveryLines]!), objects: []);

  Delivery({required this.uuid, required this.customer, required this.date});
}


import 'package:hive/hive.dart';
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

  Customer({required this.uuid, required this.names, required this.phone, required this.location});

  static Customer empty() => Customer(uuid: const Uuid().v4(), names: '', phone: '', location: '');
}
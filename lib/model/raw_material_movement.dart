import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'raw_material_movement.g.dart';

const movementTypeRelationship = <MaterialMovementType, String> {
  MaterialMovementType.released: 'Released',
  MaterialMovementType.defect: 'Defect'
};

@HiveType(typeId: 9)
class RawMaterialMovement extends HiveObject {

  @HiveField(0)
  String uuid;

  @HiveField(1)
  DateTime date;

  @HiveField(2, defaultValue: MaterialMovementType.released)
  MaterialMovementType movementType;

  @HiveField(3)
  double unitSize;

  @HiveField(4, defaultValue: 0)
  int quantity;

  RawMaterialMovement({
    required this.uuid,
    required this.date,
    required this.movementType,
    required this.unitSize,
    required this.quantity});

  static RawMaterialMovement empty(MaterialMovementType type) => RawMaterialMovement(
      uuid: const Uuid().v4(),
      date: DateTime.now(),
      movementType: type,
      unitSize: 0,
      quantity: 0);
}

@HiveType(typeId: 91)
enum MaterialMovementType {
  @HiveField(0, defaultValue: true)
  released,
  @HiveField(1)
  defect
}
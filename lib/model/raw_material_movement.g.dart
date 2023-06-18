// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_material_movement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RawMaterialMovementAdapter extends TypeAdapter<RawMaterialMovement> {
  @override
  final int typeId = 9;

  @override
  RawMaterialMovement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RawMaterialMovement(
      uuid: fields[0] as String,
      date: fields[1] as DateTime,
      movementType: fields[2] == null
          ? MaterialMovementType.released
          : fields[2] as MaterialMovementType,
      unitSize: fields[3] as double,
      quantity: fields[4] == null ? 0 : fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RawMaterialMovement obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.movementType)
      ..writeByte(3)
      ..write(obj.unitSize)
      ..writeByte(4)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawMaterialMovementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MaterialMovementTypeAdapter extends TypeAdapter<MaterialMovementType> {
  @override
  final int typeId = 92;

  @override
  MaterialMovementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MaterialMovementType.released;
      case 1:
        return MaterialMovementType.defect;
      default:
        return MaterialMovementType.released;
    }
  }

  @override
  void write(BinaryWriter writer, MaterialMovementType obj) {
    switch (obj) {
      case MaterialMovementType.released:
        writer.writeByte(0);
        break;
      case MaterialMovementType.defect:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialMovementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

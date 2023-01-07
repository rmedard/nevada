// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_line.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryLineAdapter extends TypeAdapter<DeliveryLine> {
  @override
  final int typeId = 4;

  @override
  DeliveryLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryLine(
      uuid: fields[0] as String,
      deliveryUuid: fields[1] as String,
      productUuid: fields[2] as String,
      productQuantity: fields[3] as int,
      productUnitPrice: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryLine obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.deliveryUuid)
      ..writeByte(2)
      ..write(obj.productUuid)
      ..writeByte(3)
      ..write(obj.productQuantity)
      ..writeByte(4)
      ..write(obj.productUnitPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryLineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

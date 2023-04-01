// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_line.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryLineAdapter extends TypeAdapter<DeliveryLine> {
  @override
  final int typeId = 31;

  @override
  DeliveryLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryLine(
      product: fields[0] as Product,
      productQuantity: fields[1] as int,
      productUnitPrice: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryLine obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.productQuantity)
      ..writeByte(2)
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

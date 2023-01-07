// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_refill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockRefillAdapter extends TypeAdapter<StockRefill> {
  @override
  final int typeId = 6;

  @override
  StockRefill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockRefill(
      uuid: fields[0] as String,
      date: fields[1] as DateTime,
      product: fields[2] as Product,
      productQuantity: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StockRefill obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.productQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockRefillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 2;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      uuid: fields[0] as String,
      name: fields[1] as String,
      unitBasePrice: fields[2] as int,
      description: fields[3] as String,
      totalStock: fields[4] == null ? 0 : fields[4] as int,
      isStockable: fields[5] == null ? true : fields[5] as bool,
      isActive: fields[6] == null ? true : fields[6] as bool,
      unitSize: fields[7] == null ? 0 : fields[7] as double,
      unitsInPack: fields[8] == null ? 0 : fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unitBasePrice)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.totalStock)
      ..writeByte(5)
      ..write(obj.isStockable)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.unitSize)
      ..writeByte(8)
      ..write(obj.unitsInPack);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

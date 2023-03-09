// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 1;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      uuid: fields[0] as String,
      names: fields[1] as String,
      phone: fields[2] as String,
      location: fields[3] as String,
      balance: fields[4] == null ? 0 : fields[4] as int,
    )..lastDeliveryDate = fields[5] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.names)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.balance)
      ..writeByte(5)
      ..write(obj.lastDeliveryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

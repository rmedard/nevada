// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_pay.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalaryPayAdapter extends TypeAdapter<SalaryPay> {
  @override
  final int typeId = 88;

  @override
  SalaryPay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalaryPay(
      amount: fields[3] as int,
    )
      ..paymentDate = fields[0] as DateTime
      ..month = fields[1] as int
      ..year = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, SalaryPay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.paymentDate)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalaryPayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

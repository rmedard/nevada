// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 8;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employee(
      uuid: fields[0] as String,
      names: fields[1] as String,
      entryDate: fields[2] as DateTime,
      baseSalary: fields[3] as int,
    )
      ..salaryPayments = (fields[4] as List).cast<SalaryPay>()
      ..holidays = (fields[5] as Map).cast<int, YearlyHolidays>();
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.names)
      ..writeByte(2)
      ..write(obj.entryDate)
      ..writeByte(3)
      ..write(obj.baseSalary)
      ..writeByte(4)
      ..write(obj.salaryPayments)
      ..writeByte(5)
      ..write(obj.holidays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

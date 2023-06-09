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
      dateOfBirth: fields[2] as DateTime,
      placeOfBirth: fields[3] as String,
      entryDate: fields[4] as DateTime,
      contractType: fields[5] as ContractType,
      jobTitle: fields[6] as JobTitle,
      baseSalary: fields[7] as int,
    )
      ..salaryPayments = (fields[8] as List).cast<SalaryPay>()
      ..holidays = (fields[9] as Map).cast<int, YearlyHolidays>();
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.names)
      ..writeByte(2)
      ..write(obj.dateOfBirth)
      ..writeByte(3)
      ..write(obj.placeOfBirth)
      ..writeByte(4)
      ..write(obj.entryDate)
      ..writeByte(5)
      ..write(obj.contractType)
      ..writeByte(6)
      ..write(obj.jobTitle)
      ..writeByte(7)
      ..write(obj.baseSalary)
      ..writeByte(8)
      ..write(obj.salaryPayments)
      ..writeByte(9)
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

class ContractTypeAdapter extends TypeAdapter<ContractType> {
  @override
  final int typeId = 81;

  @override
  ContractType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContractType.permanent;
      case 1:
        return ContractType.contractor;
      default:
        return ContractType.permanent;
    }
  }

  @override
  void write(BinaryWriter writer, ContractType obj) {
    switch (obj) {
      case ContractType.permanent:
        writer.writeByte(0);
        break;
      case ContractType.contractor:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobFunctionAdapter extends TypeAdapter<JobTitle> {
  @override
  final int typeId = 82;

  @override
  JobTitle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JobTitle.machinist;
      case 1:
        return JobTitle.assistant;
      case 2:
        return JobTitle.seller;
      case 3:
        return JobTitle.guard;
      default:
        return JobTitle.machinist;
    }
  }

  @override
  void write(BinaryWriter writer, JobTitle obj) {
    switch (obj) {
      case JobTitle.machinist:
        writer.writeByte(0);
        break;
      case JobTitle.assistant:
        writer.writeByte(1);
        break;
      case JobTitle.seller:
        writer.writeByte(2);
        break;
      case JobTitle.guard:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobFunctionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

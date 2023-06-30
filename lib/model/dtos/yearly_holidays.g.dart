// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly_holidays.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YearlyHolidaysAdapter extends TypeAdapter<YearlyHolidays> {
  @override
  final int typeId = 89;

  @override
  YearlyHolidays read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YearlyHolidays(
      allowedAmount: fields[0] as int,
    )..holidays = (fields[1] as List).cast<Holiday>();
  }

  @override
  void write(BinaryWriter writer, YearlyHolidays obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.allowedAmount)
      ..writeByte(1)
      ..write(obj.holidays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearlyHolidaysAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HolidayAdapter extends TypeAdapter<Holiday> {
  @override
  final int typeId = 90;

  @override
  Holiday read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Holiday(
      dateTime: fields[0] as DateTime,
      consumed: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Holiday obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.consumed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HolidayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

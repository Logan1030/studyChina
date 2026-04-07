// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrong_answer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WrongAnswerAdapter extends TypeAdapter<WrongAnswer> {
  @override
  final int typeId = 2;

  @override
  WrongAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WrongAnswer(
      character: fields[0] as String,
      lessonNumber: fields[1] as int,
      timestamp: fields[2] as DateTime,
      timesWrong: fields[3] as int,
      timesCorrect: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WrongAnswer obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.character)
      ..writeByte(1)
      ..write(obj.lessonNumber)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.timesWrong)
      ..writeByte(4)
      ..write(obj.timesCorrect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WrongAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

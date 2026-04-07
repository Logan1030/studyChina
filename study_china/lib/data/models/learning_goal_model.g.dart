// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearningGoalAdapter extends TypeAdapter<LearningGoal> {
  @override
  final int typeId = 4;

  @override
  LearningGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearningGoal(
      dailyTarget: fields[0] as int,
      weeklyTarget: fields[1] as int,
      completedToday: fields[2] as int,
      completedThisWeek: fields[3] as int,
      lastUpdated: fields[4] as DateTime?,
      currentStreak: fields[5] as int,
      lastStudyDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LearningGoal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.dailyTarget)
      ..writeByte(1)
      ..write(obj.weeklyTarget)
      ..writeByte(2)
      ..write(obj.completedToday)
      ..writeByte(3)
      ..write(obj.completedThisWeek)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.currentStreak)
      ..writeByte(6)
      ..write(obj.lastStudyDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

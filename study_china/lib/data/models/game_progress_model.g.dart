// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameProgressAdapter extends TypeAdapter<GameProgress> {
  @override
  final int typeId = 3;

  @override
  GameProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameProgress(
      totalStars: fields[0] as int,
      lessonStars: (fields[1] as Map?)?.cast<int, int>(),
      unlockedLessons: (fields[2] as List?)?.cast<int>(),
      currentStreak: fields[3] as int,
      lastPlayedDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GameProgress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalStars)
      ..writeByte(1)
      ..write(obj.lessonStars)
      ..writeByte(2)
      ..write(obj.unlockedLessons)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.lastPlayedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

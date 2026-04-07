// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VolumeProgressAdapter extends TypeAdapter<VolumeProgress> {
  @override
  final int typeId = 5;

  @override
  VolumeProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VolumeProgress(
      volumeId: fields[0] as int,
      lessonStars: (fields[1] as Map?)?.cast<int, int>(),
      masteredLessons: (fields[2] as List?)?.cast<int>(),
      totalStars: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, VolumeProgress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.volumeId)
      ..writeByte(1)
      ..write(obj.lessonStars)
      ..writeByte(2)
      ..write(obj.masteredLessons)
      ..writeByte(3)
      ..write(obj.totalStars);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolumeProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

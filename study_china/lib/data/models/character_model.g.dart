// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 0;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      character: fields[0] as String,
      pinyin: fields[1] as String,
      meaning: fields[2] as String,
      imageAsset: fields[3] as String?,
      audioAsset: fields[4] as String?,
      words: (fields[5] as List).cast<String>(),
      category: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.character)
      ..writeByte(1)
      ..write(obj.pinyin)
      ..writeByte(2)
      ..write(obj.meaning)
      ..writeByte(3)
      ..write(obj.imageAsset)
      ..writeByte(4)
      ..write(obj.audioAsset)
      ..writeByte(5)
      ..write(obj.words)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

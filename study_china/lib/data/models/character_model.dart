import 'package:hive/hive.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  @HiveField(0)
  final String character;

  @HiveField(1)
  final String pinyin;

  @HiveField(2)
  final String meaning;

  @HiveField(3)
  final String? imageAsset;

  @HiveField(4)
  final String? audioAsset;

  @HiveField(5)
  final List<String> words;

  @HiveField(6)
  final String category;

  Character({
    required this.character,
    required this.pinyin,
    required this.meaning,
    this.imageAsset,
    this.audioAsset,
    this.words = const [],
    this.category = 'other',
  });
}

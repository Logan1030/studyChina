import 'package:hive/hive.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 1)
class Lesson extends HiveObject {
  @HiveField(0)
  final int lessonNumber;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> characters;

  @HiveField(3)
  bool isUnlocked;

  @HiveField(4)
  int starsEarned;

  Lesson({
    required this.lessonNumber,
    required this.title,
    required this.characters,
    this.isUnlocked = false,
    this.starsEarned = 0,
  });
}

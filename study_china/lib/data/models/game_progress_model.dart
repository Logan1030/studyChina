import 'package:hive/hive.dart';

part 'game_progress_model.g.dart';

@HiveType(typeId: 3)
class GameProgress extends HiveObject {
  @HiveField(0)
  int totalStars;

  @HiveField(1)
  Map<int, int> lessonStars;

  @HiveField(2)
  List<int> unlockedLessons;

  @HiveField(3)
  int currentStreak;

  @HiveField(4)
  DateTime? lastPlayedDate;

  GameProgress({
    this.totalStars = 0,
    Map<int, int>? lessonStars,
    List<int>? unlockedLessons,
    this.currentStreak = 0,
    this.lastPlayedDate,
  })  : lessonStars = lessonStars ?? {},
        unlockedLessons = unlockedLessons ?? [1];

  void updateLessonStars(int lessonNumber, int stars) {
    final currentStars = lessonStars[lessonNumber] ?? 0;
    if (stars > currentStars) {
      totalStars += (stars - currentStars);
      lessonStars[lessonNumber] = stars;
    }
    if (lessonNumber < 30 && !unlockedLessons.contains(lessonNumber + 1)) {
      if (stars >= 1) {
        unlockedLessons.add(lessonNumber + 1);
      }
    }
  }

  bool isLessonUnlocked(int lessonNumber) {
    return unlockedLessons.contains(lessonNumber);
  }
}

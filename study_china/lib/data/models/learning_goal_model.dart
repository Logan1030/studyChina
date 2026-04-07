import 'package:hive/hive.dart';

part 'learning_goal_model.g.dart';

@HiveType(typeId: 4)
class LearningGoal extends HiveObject {
  @HiveField(0)
  final int dailyTarget;

  @HiveField(1)
  final int weeklyTarget;

  @HiveField(2)
  int completedToday;

  @HiveField(3)
  int completedThisWeek;

  @HiveField(4)
  DateTime lastUpdated;

  @HiveField(5)
  int currentStreak;

  @HiveField(6)
  DateTime? lastStudyDate;

  LearningGoal({
    this.dailyTarget = 10,
    this.weeklyTarget = 50,
    this.completedToday = 0,
    this.completedThisWeek = 0,
    DateTime? lastUpdated,
    this.currentStreak = 0,
    this.lastStudyDate,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  void recordStudy(int charactersCount) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastStudyDate != null) {
      final lastDate = DateTime(
        lastStudyDate!.year,
        lastStudyDate!.month,
        lastStudyDate!.day,
      );
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        currentStreak++;
      } else if (difference > 1) {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }

    lastStudyDate = now;
    completedToday += charactersCount;
    completedThisWeek += charactersCount;
    lastUpdated = now;
  }

  void resetDaily() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastUpdate = DateTime(lastUpdated.year, lastUpdated.month, lastUpdated.day);

    if (today != lastUpdate) {
      completedToday = 0;
    }
  }

  void resetWeekly() {
    final now = DateTime.now();
    final weekNumber = _weekOfYear(now);
    final lastWeekNumber = _weekOfYear(lastUpdated);

    if (weekNumber != lastWeekNumber) {
      completedThisWeek = 0;
    }
  }

  int _weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).ceil();
  }

  double get dailyProgress => dailyTarget > 0 ? (completedToday / dailyTarget).clamp(0.0, 1.0) : 0.0;
  double get weeklyProgress => weeklyTarget > 0 ? (completedThisWeek / weeklyTarget).clamp(0.0, 1.0) : 0.0;
}

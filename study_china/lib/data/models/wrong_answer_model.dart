import 'package:hive/hive.dart';

part 'wrong_answer_model.g.dart';

@HiveType(typeId: 2)
class WrongAnswer extends HiveObject {
  @HiveField(0)
  final String character;

  @HiveField(1)
  final int lessonNumber;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  int timesWrong;

  @HiveField(4)
  int timesCorrect;

  WrongAnswer({
    required this.character,
    required this.lessonNumber,
    required this.timestamp,
    this.timesWrong = 1,
    this.timesCorrect = 0,
  });

  bool get isMastered => timesCorrect >= 5;

  double get masteryProgress => (timesCorrect / 5).clamp(0.0, 1.0);
}

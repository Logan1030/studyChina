import 'package:hive/hive.dart';

part 'volume_progress_model.g.dart';

@HiveType(typeId: 5)
class VolumeProgress extends HiveObject {
  @HiveField(0)
  final int volumeId;

  @HiveField(1)
  Map<int, int> lessonStars;

  @HiveField(2)
  List<int> masteredLessons;

  @HiveField(3)
  int totalStars;

  VolumeProgress({
    required this.volumeId,
    Map<int, int>? lessonStars,
    List<int>? masteredLessons,
    this.totalStars = 0,
  })  : lessonStars = lessonStars ?? {},
        masteredLessons = masteredLessons ?? [];

  void updateLessonStars(int lessonNumber, int stars) {
    final currentStars = lessonStars[lessonNumber] ?? 0;
    if (stars > currentStars) {
      totalStars += (stars - currentStars);
      lessonStars[lessonNumber] = stars;
    }
    if (stars >= 3 && !masteredLessons.contains(lessonNumber)) {
      masteredLessons.add(lessonNumber);
    }
  }

  int get maxStars => lessonStars.values.fold(0, (sum, stars) => sum + stars);
  int get lessonsCompleted => lessonStars.keys.length;
}

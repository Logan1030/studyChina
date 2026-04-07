/// 册数据模型 - 表示一本书/一册
class Volume {
  final int id;
  final String title;
  final int startLesson;
  final int endLesson;

  const Volume({
    required this.id,
    required this.title,
    required this.startLesson,
    required this.endLesson,
  });

  int get lessonCount => endLesson - startLesson + 1;
}

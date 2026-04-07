import 'package:hive_flutter/hive_flutter.dart';
import '../../models/character_model.dart';
import '../../models/lesson_model.dart';
import '../../models/wrong_answer_model.dart';
import '../../models/game_progress_model.dart';

class HiveDatasource {
  static const String progressBoxName = 'progress';
  static const String wrongAnswersBoxName = 'wrongAnswers';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(LessonAdapter());
    Hive.registerAdapter(WrongAnswerAdapter());
    Hive.registerAdapter(GameProgressAdapter());

    await Hive.openBox<GameProgress>(progressBoxName);
    await Hive.openBox<WrongAnswer>(wrongAnswersBoxName);
  }

  static Box<GameProgress> get progressBox => Hive.box<GameProgress>(progressBoxName);
  static Box<WrongAnswer> get wrongAnswersBox => Hive.box<WrongAnswer>(wrongAnswersBoxName);

  static GameProgress getProgress() {
    return progressBox.get('main') ?? GameProgress();
  }

  static Future<void> saveProgress(GameProgress progress) async {
    await progressBox.put('main', progress);
  }

  static List<WrongAnswer> getWrongAnswers() {
    return wrongAnswersBox.values.toList();
  }

  static Future<void> addWrongAnswer(WrongAnswer wrong) async {
    final existing = wrongAnswersBox.values.where(
      (w) => w.character == wrong.character,
    ).toList();

    if (existing.isNotEmpty) {
      existing.first.timesWrong++;
      await existing.first.save();
    } else {
      await wrongAnswersBox.add(wrong);
    }
  }

  static Future<void> updateWrongAnswerCorrect(String character) async {
    final existing = wrongAnswersBox.values.where(
      (w) => w.character == character,
    ).toList();

    if (existing.isNotEmpty) {
      existing.first.timesCorrect++;
      await existing.first.save();
    }
  }

  static Future<void> clearAllData() async {
    await progressBox.clear();
    await wrongAnswersBox.clear();
    await progressBox.put('main', GameProgress());
  }
}

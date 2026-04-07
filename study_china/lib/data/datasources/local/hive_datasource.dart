import 'package:hive_flutter/hive_flutter.dart';
import '../../models/character_model.dart';
import '../../models/lesson_model.dart';
import '../../models/wrong_answer_model.dart';
import '../../models/game_progress_model.dart';
import '../../models/volume_progress_model.dart';
import '../../models/learning_goal_model.dart';

class HiveDatasource {
  static const String progressBoxName = 'progress';
  static const String wrongAnswersBoxName = 'wrongAnswers';
  static const String volumeProgressBoxName = 'volumeProgress';
  static const String learningGoalBoxName = 'learningGoal';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(LessonAdapter());
    Hive.registerAdapter(WrongAnswerAdapter());
    Hive.registerAdapter(GameProgressAdapter());
    Hive.registerAdapter(VolumeProgressAdapter());
    Hive.registerAdapter(LearningGoalAdapter());

    await Hive.openBox<GameProgress>(progressBoxName);
    await Hive.openBox<WrongAnswer>(wrongAnswersBoxName);
    await Hive.openBox<VolumeProgress>(volumeProgressBoxName);
    await Hive.openBox<LearningGoal>(learningGoalBoxName);
  }

  static Box<GameProgress> get progressBox => Hive.box<GameProgress>(progressBoxName);
  static Box<WrongAnswer> get wrongAnswersBox => Hive.box<WrongAnswer>(wrongAnswersBoxName);
  static Box<VolumeProgress> get volumeProgressBox => Hive.box<VolumeProgress>(volumeProgressBoxName);
  static Box<LearningGoal> get learningGoalBox => Hive.box<LearningGoal>(learningGoalBoxName);

  // Legacy progress methods
  static GameProgress getProgress() {
    return progressBox.get('main') ?? GameProgress();
  }

  static Future<void> saveProgress(GameProgress progress) async {
    await progressBox.put('main', progress);
  }

  // Wrong answers methods
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

  // Volume progress methods
  static Map<int, VolumeProgress> getAllVolumeProgress() {
    final result = <int, VolumeProgress>{};
    for (var i = 1; i <= 3; i++) {
      final progress = volumeProgressBox.get('volume_$i');
      if (progress != null) {
        result[i] = progress;
      }
    }
    return result;
  }

  static VolumeProgress? getVolumeProgress(int volumeId) {
    return volumeProgressBox.get('volume_$volumeId');
  }

  static Future<void> saveVolumeProgress(VolumeProgress progress) async {
    await volumeProgressBox.put('volume_${progress.volumeId}', progress);
  }

  // Learning goal methods
  static LearningGoal getLearningGoal() {
    return learningGoalBox.get('main') ?? LearningGoal();
  }

  static Future<void> saveLearningGoal(LearningGoal goal) async {
    await learningGoalBox.put('main', goal);
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await progressBox.clear();
    await wrongAnswersBox.clear();
    await volumeProgressBox.clear();
    await learningGoalBox.clear();
    await progressBox.put('main', GameProgress());
  }
}

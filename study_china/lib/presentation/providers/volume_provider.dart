import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/hive_datasource.dart';
import '../../data/models/learning_goal_model.dart';
import '../../data/models/volume_progress_model.dart';
import '../../data/models/wrong_answer_model.dart';

// Volume Progress Provider
final volumeProgressProvider = StateNotifierProvider<VolumeProgressNotifier, AsyncValue<Map<int, VolumeProgress>>>((ref) {
  return VolumeProgressNotifier();
});

class VolumeProgressNotifier extends StateNotifier<AsyncValue<Map<int, VolumeProgress>>> {
  VolumeProgressNotifier() : super(const AsyncValue.loading()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final progress = HiveDatasource.getAllVolumeProgress();
      state = AsyncValue.data(progress);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateLessonStars(int lessonNumber, int stars) async {
    final volumeId = (lessonNumber - 1) ~/ 10 + 1;
    final currentData = state.valueOrNull ?? {};

    final volumeProgress = currentData[volumeId] ?? VolumeProgress(volumeId: volumeId);
    volumeProgress.updateLessonStars(lessonNumber, stars);

    await HiveDatasource.saveVolumeProgress(volumeProgress);

    state = AsyncValue.data({
      ...currentData,
      volumeId: volumeProgress,
    });
  }
}

// Learning Goal Provider
final learningGoalProvider = StateNotifierProvider<LearningGoalNotifier, LearningGoal>((ref) {
  return LearningGoalNotifier();
});

class LearningGoalNotifier extends StateNotifier<LearningGoal> {
  LearningGoalNotifier() : super(HiveDatasource.getLearningGoal());

  void recordStudy(int charactersCount) {
    state.recordStudy(charactersCount);
    HiveDatasource.saveLearningGoal(state);
    state = state;
  }

  void updateTargets(int daily, int weekly) {
    state = LearningGoal(
      dailyTarget: daily,
      weeklyTarget: weekly,
      completedToday: state.completedToday,
      completedThisWeek: state.completedThisWeek,
      currentStreak: state.currentStreak,
      lastStudyDate: state.lastStudyDate,
    );
    HiveDatasource.saveLearningGoal(state);
  }

  void resetDaily() {
    state.resetDaily();
    HiveDatasource.saveLearningGoal(state);
    state = state;
  }

  void resetWeekly() {
    state.resetWeekly();
    HiveDatasource.saveLearningGoal(state);
    state = state;
  }
}

// Wrong Answers Provider
final wrongAnswersProvider = Provider<List<WrongAnswer>>((ref) {
  return HiveDatasource.getWrongAnswers();
});

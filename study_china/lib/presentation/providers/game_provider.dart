import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/assets/word_data.dart';
import '../../data/datasources/local/hive_datasource.dart';
import '../../data/models/character_model.dart';
import '../../data/models/game_progress_model.dart';
import '../../data/models/wrong_answer_model.dart';

final progressProvider = StateNotifierProvider<ProgressNotifier, GameProgress>((ref) {
  return ProgressNotifier();
});

class ProgressNotifier extends StateNotifier<GameProgress> {
  ProgressNotifier() : super(HiveDatasource.getProgress());

  Future<void> updateLessonStars(int lessonNumber, int stars) async {
    state.updateLessonStars(lessonNumber, stars);
    await HiveDatasource.saveProgress(state);
    state = state;
  }

  Future<void> addWrongAnswer(String character, int lessonNumber) async {
    final wrong = WrongAnswer(
      character: character,
      lessonNumber: lessonNumber,
      timestamp: DateTime.now(),
    );
    await HiveDatasource.addWrongAnswer(wrong);
  }

  Future<void> markCorrect(String character) async {
    await HiveDatasource.updateWrongAnswerCorrect(character);
  }

  Future<void> resetProgress() async {
    await HiveDatasource.clearAllData();
    state = GameProgress();
  }
}

final wrongAnswersProvider = Provider<List<WrongAnswer>>((ref) {
  return HiveDatasource.getWrongAnswers();
});

enum GameType { characterMatch, audioDiscrimination, wordMatching, readingComprehension }

class Question {
  final String targetCharacter;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.targetCharacter,
    required this.options,
    required this.correctIndex,
  });
}

class GameState {
  final GameType gameType;
  final int currentQuestion;
  final int totalQuestions;
  final int correctAnswers;
  final Question? currentQuestionData;
  final bool isAnswered;
  final bool? isCorrect;
  final int? selectedIndex;
  final bool isComplete;
  final int starsEarned;

  GameState({
    this.gameType = GameType.characterMatch,
    this.currentQuestion = 0,
    this.totalQuestions = 5,
    this.correctAnswers = 0,
    this.currentQuestionData,
    this.isAnswered = false,
    this.isCorrect,
    this.selectedIndex,
    this.isComplete = false,
    this.starsEarned = 0,
  });

  GameState copyWith({
    GameType? gameType,
    int? currentQuestion,
    int? totalQuestions,
    int? correctAnswers,
    Question? currentQuestionData,
    bool? isAnswered,
    bool? isCorrect,
    int? selectedIndex,
    bool? isComplete,
    int? starsEarned,
  }) {
    return GameState(
      gameType: gameType ?? this.gameType,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      currentQuestionData: currentQuestionData ?? this.currentQuestionData,
      isAnswered: isAnswered ?? this.isAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isComplete: isComplete ?? this.isComplete,
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState());

  final List<Question> _questions = [];

  void startGame(int lessonNumber) {
    _questions.clear();
    final characters = WordData.getLessonCharacters(lessonNumber);

    for (var i = 0; i < characters.length && i < 5; i++) {
      final correct = characters[i];
      final distractors = characters
          .where((c) => c.character != correct.character)
          .toList()
        ..shuffle();
      final options = [correct, ...distractors.take(3)]..shuffle();
      final correctIndex = options.indexWhere((c) => c.character == correct.character);

      _questions.add(Question(
        targetCharacter: correct.character,
        options: options.map((c) => c.meaning).toList(),
        correctIndex: correctIndex,
      ));
    }

    state = GameState(
      gameType: GameType.characterMatch,
      currentQuestion: 0,
      totalQuestions: _questions.length,
      currentQuestionData: _questions.isNotEmpty ? _questions[0] : null,
    );
  }

  void selectAnswer(int index) {
    if (state.isAnswered || state.currentQuestionData == null) return;

    final isCorrect = index == state.currentQuestionData!.correctIndex;
    state = state.copyWith(
      isAnswered: true,
      isCorrect: isCorrect,
      selectedIndex: index,
      correctAnswers: isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
    );
  }

  void nextQuestion() {
    final nextIndex = state.currentQuestion + 1;
    if (nextIndex >= _questions.length) {
      final stars = _calculateStars();
      state = state.copyWith(
        isComplete: true,
        starsEarned: stars,
      );
    } else {
      state = state.copyWith(
        currentQuestion: nextIndex,
        currentQuestionData: _questions[nextIndex],
        isAnswered: false,
        isCorrect: null,
        selectedIndex: null,
      );
    }
  }

  int _calculateStars() {
    final ratio = state.correctAnswers / state.totalQuestions;
    if (ratio >= 1.0) return 3;
    if (ratio >= 0.8) return 2;
    if (ratio >= 0.6) return 1;
    return 0;
  }

  void resetGame() {
    state = GameState();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

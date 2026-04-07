import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/assets/word_data.dart';
import '../../../data/models/character_model.dart';
import '../../../data/services/audio_service.dart';
import '../../providers/game_provider.dart';
import '../../providers/volume_provider.dart';

class ExamScreen extends ConsumerStatefulWidget {
  final int lessonNumber;

  const ExamScreen({super.key, required this.lessonNumber});

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  late List<Character> characters;
  List<Question> questions = [];
  int currentIndex = 0;
  int correctCount = 0;
  bool isAnswered = false;
  int? selectedIndex;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    characters = WordData.getLessonCharacters(widget.lessonNumber);
    _generateQuestions();
  }

  void _generateQuestions() {
    final chars = characters.take(5).toList();
    for (var i = 0; i < chars.length; i++) {
      final correct = chars[i];
      final distractors = chars.where((c) => c.character != correct.character).toList()
        ..shuffle();
      final options = [correct.meaning, ...distractors.take(3).map((c) => c.meaning)]..shuffle();
      final correctIndex = options.indexOf(correct.meaning);
      questions.add(Question(
        targetCharacter: correct.character,
        pinyin: correct.pinyin,
        options: options,
        correctIndex: correctIndex,
      ));
    }
  }

  void selectAnswer(int index) {
    if (isAnswered) return;
    setState(() {
      selectedIndex = index;
      isAnswered = true;
      if (index == questions[currentIndex].correctIndex) {
        correctCount++;
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
        selectedIndex = null;
      });
    } else {
      _completeExam();
    }
  }

  void _completeExam() {
    final stars = _calculateStars();
    ref.read(volumeProgressProvider.notifier).updateLessonStars(
          widget.lessonNumber,
          stars,
        );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('考核完成'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Icon(
                  Icons.star,
                  size: 40,
                  color: index < stars ? Colors.amber : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '正确率: $correctCount/${questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '获得 $stars 颗星',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/volume/${(widget.lessonNumber - 1) ~/ 10 + 1}');
            },
            child: const Text('返回'),
          ),
          if (stars < 3)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentIndex = 0;
                  correctCount = 0;
                  isAnswered = false;
                  selectedIndex = null;
                });
              },
              child: const Text('再试一次'),
            ),
        ],
      ),
    );
  }

  int _calculateStars() {
    final ratio = correctCount / questions.length;
    if (ratio >= 1.0) return 3;
    if (ratio >= 0.6) return 2;
    if (ratio >= 0.4) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('考核 第${widget.lessonNumber}课'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.canPop() ? context.pop() : context.go('/volume/${(widget.lessonNumber - 1) ~/ 10 + 1}'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(Color(0xFF2196F3)),
              ),
              const SizedBox(height: 8),
              Text(
                '第 ${currentIndex + 1} 题 / 共 ${questions.length} 题',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '正确: $correctCount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      question.targetCharacter,
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _audioService.speakCharacter(
                        question.targetCharacter,
                        question.pinyin,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up,
                          size: 32,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '选择正确含义',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: List.generate(
                    question.options.length,
                    (index) => _AnswerOption(
                      text: question.options[index],
                      isSelected: selectedIndex == index,
                      isCorrect: index == question.correctIndex,
                      isAnswered: isAnswered,
                      onTap: () => selectAnswer(index),
                    ),
                  ),
                ),
              ),
              if (isAnswered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      currentIndex < questions.length - 1 ? '下一题' : '完成',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  final String targetCharacter;
  final String pinyin;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.targetCharacter,
    required this.pinyin,
    required this.options,
    required this.correctIndex,
  });
}

class _AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black87;

    if (isAnswered) {
      if (isCorrect) {
        bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
        borderColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF4CAF50);
      } else if (isSelected && !isCorrect) {
        bgColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        textColor = Colors.red;
      }
    } else if (isSelected) {
      bgColor = const Color(0xFF2196F3).withOpacity(0.1);
      borderColor = const Color(0xFF2196F3);
    }

    return GestureDetector(
      onTap: isAnswered ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

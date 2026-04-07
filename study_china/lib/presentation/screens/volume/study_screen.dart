import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/assets/word_data.dart';
import '../../../data/models/character_model.dart';
import '../../providers/volume_provider.dart';

class StudyScreen extends ConsumerStatefulWidget {
  final int lessonNumber;

  const StudyScreen({super.key, required this.lessonNumber});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  late List<Character> characters;
  int currentIndex = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    characters = WordData.getLessonCharacters(widget.lessonNumber);
  }

  void nextCharacter() {
    if (currentIndex < characters.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void previousCharacter() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  void toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentChar = characters[currentIndex];
    final isLast = currentIndex == characters.length - 1;
    final isFirst = currentIndex == 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('学习 第${widget.lessonNumber}课'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (currentIndex + 1) / characters.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
              ),
              const SizedBox(height: 8),
              Text(
                '${currentIndex + 1} / ${characters.length}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GestureDetector(
                  onTap: toggleAnswer,
                  child: Container(
                    width: double.infinity,
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            currentChar.character,
                            key: ValueKey(currentChar.character),
                            style: const TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedOpacity(
                          opacity: showAnswer ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Column(
                            children: [
                              Text(
                                currentChar.pinyin,
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentChar.meaning,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!showAnswer)
                          Text(
                            '点击显示答案',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.arrow_back_ios,
                    label: '上一个',
                    onPressed: isFirst ? null : previousCharacter,
                  ),
                  _ActionButton(
                    icon: Icons.arrow_forward_ios,
                    label: isLast ? '完成' : '下一个',
                    onPressed: isLast ? () => _completeStudy() : nextCharacter,
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeStudy() {
    ref.read(learningGoalProvider.notifier).recordStudy(characters.length);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('学习完成'),
        content: Text('已学习 ${characters.length} 个汉字'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/volume/${(widget.lessonNumber - 1) ~/ 10 + 1}');
            },
            child: const Text('返回课程'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/exam/${widget.lessonNumber}');
            },
            child: const Text('开始考核'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.3 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary ? const Color(0xFF4CAF50) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isPrimary ? null : Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isPrimary ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/datasources/local/hive_datasource.dart';
import '../../../data/models/wrong_answer_model.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_widgets.dart';

class WrongNotebookScreen extends ConsumerWidget {
  const WrongNotebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wrongAnswers = HiveDatasource.getWrongAnswers();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        title: const Text('错题本'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: wrongAnswers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    '太棒了！没有错题',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    '继续保持！',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ChildFriendlyButton(
                    label: '返回主页',
                    icon: Icons.home,
                    color: AppColors.primary,
                    onTap: () => context.go('/'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: wrongAnswers.length,
              itemBuilder: (context, index) {
                final wrong = wrongAnswers[index];
                return _WrongAnswerCard(wrong: wrong);
              },
            ),
    );
  }
}

class _WrongAnswerCard extends StatelessWidget {
  final WrongAnswer wrong;

  const _WrongAnswerCard({required this.wrong});

  @override
  Widget build(BuildContext context) {
    final metadata = _getCharacterMetadata(wrong.character);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                wrong.character,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wrong.character,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${metadata['pinyin']} - ${metadata['meaning']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                    const SizedBox(width: 4),
                    Text('${wrong.timesCorrect}/5'),
                    const SizedBox(width: 16),
                    const Icon(Icons.cancel, color: AppColors.error, size: 16),
                    const SizedBox(width: 4),
                    Text('${wrong.timesWrong}'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '第${wrong.lessonNumber}课',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              if (wrong.isMastered)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '已掌握',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: wrong.masteryProgress,
                      backgroundColor: AppColors.locked.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                      minHeight: 8,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, String> _getCharacterMetadata(String char) {
    return {
      'pinyin': '—',
      'meaning': char,
    };
  }
}

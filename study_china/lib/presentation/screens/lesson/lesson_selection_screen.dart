import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_widgets.dart';

class LessonSelectionScreen extends ConsumerWidget {
  const LessonSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('选择课程'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.85,
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          final lessonNumber = index + 1;
          final stars = progress.lessonStars[lessonNumber] ?? 0;
          final isUnlocked = progress.isLessonUnlocked(lessonNumber);

          return LessonCard(
            lessonNumber: lessonNumber,
            stars: stars,
            isUnlocked: isUnlocked,
            onTap: () => context.go('/lesson/$lessonNumber'),
          );
        },
      ),
    );
  }
}

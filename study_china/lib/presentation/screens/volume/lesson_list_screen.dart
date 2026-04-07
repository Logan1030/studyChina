import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/volume_model.dart';
import '../../../data/models/volume_progress_model.dart';
import '../../providers/volume_provider.dart';
import 'volume_selection_screen.dart';

class LessonListScreen extends ConsumerWidget {
  final int volumeId;

  const LessonListScreen({super.key, required this.volumeId});

  Volume? get volume {
    try {
      return VolumeSelectionScreen.volumes.firstWhere((v) => v.id == volumeId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volumeData = volume;
    if (volumeData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('册数不存在'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      );
    }

    final progressAsync = ref.watch(volumeProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(volumeData.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getVolumeColor(volumeId).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      color: _getVolumeColor(volumeId),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '第${volumeData.startLesson}-${volumeData.endLesson}课',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _getVolumeColor(volumeId),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => context.go('/planning/$volumeId'),
                      icon: const Icon(Icons.flag_outlined, size: 18),
                      label: const Text('学习目标'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '课程列表',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: volumeData.lessonCount,
                  itemBuilder: (context, index) {
                    final lessonNumber = volumeData.startLesson + index;
                    return progressAsync.when(
                      data: (progressMap) {
                        final progress = progressMap[volumeId];
                        final stars = progress?.lessonStars[lessonNumber] ?? 0;
                        final isMastered = progress?.masteredLessons.contains(lessonNumber) ?? false;
                        return _LessonCard(
                          lessonNumber: lessonNumber,
                          stars: stars,
                          isMastered: isMastered,
                          onTap: () => context.go('/volume/$volumeId/lesson/$lessonNumber'),
                        );
                      },
                      loading: () => _LessonCard(
                        lessonNumber: lessonNumber,
                        stars: 0,
                        isMastered: false,
                        onTap: () => context.go('/volume/$volumeId/lesson/$lessonNumber'),
                      ),
                      error: (_, __) => _LessonCard(
                        lessonNumber: lessonNumber,
                        stars: 0,
                        isMastered: false,
                        onTap: () => context.go('/volume/$volumeId/lesson/$lessonNumber'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getVolumeColor(int volumeId) {
    switch (volumeId) {
      case 1:
        return const Color(0xFF4CAF50);
      case 2:
        return const Color(0xFF2196F3);
      case 3:
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

class _LessonCard extends StatelessWidget {
  final int lessonNumber;
  final int stars;
  final bool isMastered;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lessonNumber,
    required this.stars,
    required this.isMastered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isMastered ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMastered ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$lessonNumber',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isMastered ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '课',
                    style: TextStyle(
                      fontSize: 12,
                      color: isMastered ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (stars > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    stars,
                    (index) => const Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            if (isMastered)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/volume_model.dart';
import '../../../data/models/volume_progress_model.dart';
import '../../providers/volume_provider.dart';

class VolumeSelectionScreen extends ConsumerWidget {
  const VolumeSelectionScreen({super.key});

  static const List<Volume> volumes = [
    Volume(id: 1, title: '第一册', startLesson: 1, endLesson: 10),
    Volume(id: 2, title: '第二册', startLesson: 11, endLesson: 20),
    Volume(id: 3, title: '第三册', startLesson: 21, endLesson: 30),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(volumeProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('选择册数'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '欢迎学习汉字',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '选择一册开始学习',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: volumes.length,
                  itemBuilder: (context, index) {
                    final volume = volumes[index];
                    return progressAsync.when(
                      data: (progressMap) {
                        final progress = progressMap[volume.id] ?? VolumeProgress(volumeId: volume.id);
                        return _VolumeCard(
                          volume: volume,
                          progress: progress,
                          onTap: () => context.go('/volume/${volume.id}'),
                        );
                      },
                      loading: () => _VolumeCard(
                        volume: volume,
                        progress: VolumeProgress(volumeId: volume.id),
                        onTap: () => context.go('/volume/${volume.id}'),
                      ),
                      error: (_, __) => _VolumeCard(
                        volume: volume,
                        progress: VolumeProgress(volumeId: volume.id),
                        onTap: () => context.go('/volume/${volume.id}'),
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
}

class _VolumeCard extends StatelessWidget {
  final Volume volume;
  final VolumeProgress progress;
  final VoidCallback onTap;

  const _VolumeCard({
    required this.volume,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalLessons = volume.lessonCount;
    final completedLessons = progress.lessonsCompleted;
    final progressPercent = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getVolumeColor(volume.id),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${volume.id}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      volume.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '第${volume.startLesson}-${volume.endLesson}课 · $completedLessons/$totalLessons课',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(_getVolumeColor(volume.id)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (index) => Icon(
                        Icons.star,
                        size: 20,
                        color: index < (progress.totalStars ~/ 10)
                            ? Colors.amber
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${progress.totalStars}星',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
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

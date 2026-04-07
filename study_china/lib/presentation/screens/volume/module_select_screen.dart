import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/volume_provider.dart';

class ModuleSelectScreen extends ConsumerWidget {
  final int volumeId;
  final int lessonNumber;

  const ModuleSelectScreen({
    super.key,
    required this.volumeId,
    required this.lessonNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wrongAnswers = ref.watch(wrongAnswersProvider);
    final lessonWrongCount = wrongAnswers.where((w) => w.lessonNumber == lessonNumber).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('第$lessonNumber课'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/volume/$volumeId'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getModuleColor(0),
                      _getModuleColor(0).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '开始学习',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '第$lessonNumber课',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '选择学习模式',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _ModuleCard(
                      icon: Icons.menu_book,
                      title: '学习',
                      subtitle: '看字听音，反复练习认读',
                      color: _getModuleColor(0),
                      onTap: () => context.go('/study/$lessonNumber'),
                    ),
                    const SizedBox(height: 12),
                    _ModuleCard(
                      icon: Icons.assignment,
                      title: '考核',
                      subtitle: '测试认字正确率',
                      color: _getModuleColor(1),
                      onTap: () => context.go('/exam/$lessonNumber'),
                    ),
                    const SizedBox(height: 12),
                    _ModuleCard(
                      icon: Icons.edit_note,
                      title: '错题',
                      subtitle: lessonWrongCount > 0
                          ? '本课有 $lessonWrongCount 个错字'
                          : '本课暂无错题',
                      color: _getModuleColor(2),
                      badge: lessonWrongCount > 0 ? lessonWrongCount : null,
                      onTap: lessonWrongCount > 0
                          ? () => context.go('/wrong-notebook?lesson=$lessonNumber')
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _ModuleCard(
                      icon: Icons.flag,
                      title: '规划',
                      subtitle: '设定学习目标',
                      color: _getModuleColor(3),
                      onTap: () => context.go('/planning/$volumeId'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getModuleColor(int index) {
    const colors = [
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
      Color(0xFFFF9800),
      Color(0xFF9C27B0),
    ];
    return colors[index % colors.length];
  }
}

class _ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final int? badge;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$badge',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDisabled ? Colors.grey[300] : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

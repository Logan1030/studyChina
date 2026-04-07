import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Text(
                '识词游戏',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Learn Chinese Characters',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      icon: Icons.star,
                      value: '${progress.totalStars}',
                      label: '星星',
                      color: AppColors.secondary,
                    ),
                    _StatItem(
                      icon: Icons.lock_open,
                      value: '${progress.unlockedLessons.length}',
                      label: '已解锁',
                      color: AppColors.success,
                    ),
                    _StatItem(
                      icon: Icons.book,
                      value: '${progress.lessonStars.length}',
                      label: '已完成',
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ChildFriendlyButton(
                label: '开始学习',
                icon: Icons.play_arrow_rounded,
                color: AppColors.primary,
                onTap: () => context.go('/lessons'),
                isLarge: true,
              ),
              const SizedBox(height: AppSpacing.md),
              ChildFriendlyButton(
                label: '错题本',
                icon: Icons.book_rounded,
                color: AppColors.secondary,
                onTap: () => context.go('/wrong-notebook'),
              ),
              const SizedBox(height: AppSpacing.md),
              ChildFriendlyButton(
                label: '设置',
                icon: Icons.settings_rounded,
                color: AppColors.textSecondary,
                onTap: () => context.go('/settings'),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

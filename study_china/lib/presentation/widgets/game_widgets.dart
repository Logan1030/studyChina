import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class ChildFriendlyButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLarge;

  const ChildFriendlyButton({
    super.key,
    required this.label,
    this.icon,
    required this.color,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  State<ChildFriendlyButton> createState() => _ChildFriendlyButtonState();
}

class _ChildFriendlyButtonState extends State<ChildFriendlyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.isLarge ? 280 : 200,
          height: widget.isLarge ? 80 : 60,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: widget.isLarge ? 32 : 24,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.isLarge ? 24 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageOptionCard extends StatefulWidget {
  final String imageEmoji;
  final String label;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const ImageOptionCard({
    super.key,
    required this.imageEmoji,
    required this.label,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  State<ImageOptionCard> createState() => _ImageOptionCardState();
}

class _ImageOptionCardState extends State<ImageOptionCard> {
  bool _isPressed = false;

  Color get backgroundColor {
    if (!widget.isAnswered) {
      return widget.isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.surface;
    }
    if (widget.isCorrect) {
      return AppColors.success.withOpacity(0.3);
    }
    if (widget.isSelected && !widget.isCorrect) {
      return AppColors.error.withOpacity(0.3);
    }
    return AppColors.surface;
  }

  Color get borderColor {
    if (!widget.isAnswered) {
      return widget.isSelected ? AppColors.primary : Colors.transparent;
    }
    if (widget.isCorrect) {
      return AppColors.success;
    }
    if (widget.isSelected && !widget.isCorrect) {
      return AppColors.error;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isAnswered) setState(() => _isPressed = true);
      },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.imageEmoji,
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int stars;
  final int maxStars;

  const StarRating({
    super.key,
    required this.stars,
    this.maxStars = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        if (index < stars) {
          return const Icon(Icons.star, color: AppColors.secondary, size: 24)
              .animate()
              .scale(delay: Duration(milliseconds: index * 200));
        }
        return const Icon(Icons.star_border, color: AppColors.locked, size: 24);
      }),
    );
  }
}

class _MiniStarRating extends StatelessWidget {
  final int stars;
  final int maxStars;

  const _MiniStarRating({
    required this.stars,
    this.maxStars = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        if (index < stars) {
          return const Icon(Icons.star, color: AppColors.secondary, size: 12);
        }
        return const Icon(Icons.star_border, color: AppColors.locked, size: 12);
      }),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const ProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('第 ${current + 1} 题', style: const TextStyle(fontSize: 16)),
            Text('共 $total 题', style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (current + 1) / total,
            backgroundColor: AppColors.locked.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 12,
          ),
        ),
      ],
    );
  }
}

class LessonCard extends StatelessWidget {
  final int lessonNumber;
  final int stars;
  final bool isUnlocked;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lessonNumber,
    required this.stars,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surface : AppColors.locked.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '第',
              style: TextStyle(
                fontSize: 10,
                color: isUnlocked ? AppColors.textSecondary : AppColors.locked,
              ),
            ),
            Text(
              '$lessonNumber',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? AppColors.primary : AppColors.locked,
              ),
            ),
            Text(
              '课',
              style: TextStyle(
                fontSize: 10,
                color: isUnlocked ? AppColors.textSecondary : AppColors.locked,
              ),
            ),
            const SizedBox(height: 2),
            if (!isUnlocked)
              const Icon(Icons.lock, color: AppColors.locked, size: 14)
            else
              _MiniStarRating(stars: stars, maxStars: 3),
          ],
        ),
      ),
    );
  }
}

class ConfettiOverlay extends StatelessWidget {
  final bool show;

  const ConfettiOverlay({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return IgnorePointer(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 80))
                  .animate(onPlay: (c) => c.repeat())
                  .rotate(duration: 1.seconds)
                  .then()
                  .shake(),
              const SizedBox(height: 24),
              const Text(
                '太棒了！',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().scale(),
            ],
          ),
        ),
      ),
    );
  }
}

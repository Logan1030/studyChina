import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/datasources/assets/word_data.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_widgets.dart';

class GameScreen extends ConsumerStatefulWidget {
  final int lessonNumber;

  const GameScreen({super.key, required this.lessonNumber});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  static const Map<String, String> _emojiMap = {
    '人': '👤',
    '口': '👄',
    '大': '� elefante',
    '中': '🎯',
    '小': '🐜',
    '哭': '😢',
    '笑': '😄',
    '一': '1️⃣',
    '上': '⬆️',
    '下': '⬇️',
    '爸': '👨',
    '妈': '👩',
    '天': '☀️',
    '太': '🌞',
    '月': '🌙',
    '二': '2️⃣',
    '地': '🌍',
    '阳': '☀️',
    '亮': '💡',
    '星': '⭐',
    '云': '☁️',
    '火': '🔥',
    '水': '💧',
    '三': '3️⃣',
    '土': '🌱',
    '山': '⛰️',
    '石': '🪨',
    '木': '🌳',
    '我': '🙋',
    '好': '👍',
    '有': '✅',
    '田': '🌾',
    '牛': '🐮',
    '羊': '🐑',
    '聪': '🧠',
    '耳': '👂',
    '目': '👁️',
    '心': '❤️',
    '和': '➕',
    '四': '4️⃣',
    '明': '🌟',
    '头': '👤',
    '眉': '眉毛',
    '鼻': '👃',
    '手': '✋',
    '花': '🌸',
    '树': '🌳',
    '五': '5️⃣',
    '草': '🌿',
    '叶': '🍃',
    '日': '☀️',
    '风': '💨',
    '雨': '🌧️',
    '的': '✓',
    '孩': '👶',
    '六': '6️⃣',
    '白': '⚪',
    '红': '🔴',
    '是': '✔️',
    '家': '🏠',
    '多': '➕',
    '唱': '🎤',
    '子': '👶',
    '七': '7️⃣',
    '爱': '❤️',
    '爷': '👴',
    '奶': '👵',
    '少': '➖',
    '歌': '🎵',
    '不': '✖️',
    '朋': '👯',
    '八': '8️⃣',
    '宝': '💎',
    '在': '📍',
    '学': '📚',
    '书': '📖',
    '游': '🏊',
    '友': '👫',
    '儿': '👦',
    '九': '9️⃣',
    '贝': '🐚',
    '生': '🌱',
    '习': '📝',
    '看': '👀',
    '戏': '🎭',
    '字': '🔤',
    '气': '💨',
    '十': '🔟',
    '会': '💪',
    '见': '👁️',
    '早': '🌅',
    '雪': '❄️',
    '鸡': '🐔',
    '绿': '🟢',
    '黄': '🟡',
    '青': '🔵',
    '鱼': '🐟',
    '做': '🔧',
    '飞': '✈️',
    '跑': '🏃',
    '要': '📦',
    '吃': '🍽️',
    '鸟': '🐦',
    '他': '👨',
    '们': '👥',
    '春': '🌸',
    '夏': '☀️',
    '秋': '🍂',
    '冬': '❄️',
    '季': '📅',
    '都': '✓',
    '个': '个',
    '狗': '🐕',
    '猫': '🐱',
    '蓝': '🔵',
    '落': '🍂',
    '真': '✅',
    '开': '🚪',
    '说': '💬',
    '也': '➕',
    '马': '🐴',
    '米': '🍚',
    '哥': '👦',
    '姐': '👧',
    '来': '➡️',
    '黑': '⚫',
    '去': '⬅️',
    '出': '🚪',
    '跳': '🦘',
    '着': '👟',
    '了': '✓',
    '你': '🙋',
    '又': '➕',
    '弟': '👦',
    '妹': '👧',
    '东': '⬅️',
    '就': '💪',
    '还': '↩️',
    '快': '⚡',
    '得': '✅',
    '西': '➡️',
    '乐': '😊',
    '到': '📍',
    '起': '⬆️',
    '玩': '🎮',
    '捉': '✋',
    '迷': '❓',
    '球': '⚽',
    '很': '⚡',
    '高': '📏',
    '鸭': '🦆',
    '哈': '😂',
    '方': '⬜',
    '爬': '🐢',
    '藏': '🙈',
    '兴': '😊',
    '向': '➡️',
    '对': '✔️',
    '能': '💪',
    '叫': '📢',
    '变': '🔄',
    '问': '❓',
    '成': '✅',
    '再': '🔁',
    '急': '😰',
    '教': '👨‍🏫',
    '门': '🚪',
    '只': '1️⃣',
    '回': '↩️',
    '公': '🏢',
    '打': '👊',
    '兔': '🐰',
    '请': '🙏',
    '过': '➡️',
    '吗': '❓',
    '泳': '🏊',
    '虫': '🐛',
    '把': '✋',
    '驮': '🐘',
    '鹅': '🦢',
    '河': '🏞️',
    '礼': '🎁',
    '背': '👝',
    '拿': '✋',
    '里': '⬜',
    '后': '⬜',
    '谢': '🙏',
    '边': '⬜',
    '貌': '😊',
    '班': '👨‍🏫',
    '幼': '👶',
    '园': '🏡',
    '照': '📷',
    '婆': '👵',
    '甜': '🍬',
    '梦': '💭',
    '老': '👴',
    '盒': '📦',
    '尺': '📏',
    '刀': '🔪',
    '时': '🕐',
    '正': '✔️',
    '文': '📝',
    '具': '🔧',
    '笔': '✏️',
    '画': '🎨',
    '长': '📏',
    '放': '📤',
    '用': '🔧',
    '总': '📊',
    '尾': '🐾',
    '巴': '🐵',
    '玉': '💎',
    '尖': '📍',
    '竹': '🎋',
    '苗': '🌱',
    '听': '👂',
    '话': '💬',
    '猴': '🐵',
    '猩': '🦍',
    '给': '📤',
    '进': '➡️',
    '告': '📢',
    '电': '⚡',
    '诉': '💬',
    '念': '📖',
    '饭': '🍚',
    '乖': '😊',
    '想': '💭',
    '面': '👤',
    '住': '🏠',
    '前': '⬜',
    '从': '⬜',
    '同': '👥',
    '没': '✖️',
    '送': '📤',
    '果': '🍎',
    '工': '🏭',
    '厂': '🏭',
    '产': '📦',
    '动': '🏃',
    '关': '🔒',
    '找': '🔍',
    '按': '👆',
    '年': '📅',
    '节': '🎊',
    '桃': '🍑',
    '荷': '🪷',
    '菊': '🌼',
    '梅': '🍒',
    '冷': '🥶',
    '它': '🐱',
    '怕': '😨',
    '躲': '🙈',
    '勇': '💪',
    '敢': '💪',
    '堆': '📦',
    '仗': '⚔️',
    '柳': '🌿',
    '农': '👨‍🌾',
    '民': '👥',
    '伯': '👨',
    '种': '🌱',
    '最': '👑',
  };

  String _getEmoji(String char) {
    return _emojiMap[char] ?? '❓';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).startGame(widget.lessonNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    if (gameState.isComplete) {
      return _ResultScreen(
        lessonNumber: widget.lessonNumber,
        correctAnswers: gameState.correctAnswers,
        totalQuestions: gameState.totalQuestions,
        stars: gameState.starsEarned,
      );
    }

    final question = gameState.currentQuestionData;
    if (question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.go('/lessons'),
                      ),
                      Text(
                        '第${widget.lessonNumber}课',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: ProgressBar(
                    current: gameState.currentQuestion,
                    total: gameState.totalQuestions,
                  ),
                ),
                const Spacer(),
                Text(
                  '这个字是什么意思？',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  question.targetCharacter,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn().scale(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final char = WordData.getCharacter(question.targetCharacter);
                      final options = <String, String>{};
                      for (var i = 0; i < 4; i++) {
                        if (i == question.correctIndex) {
                          options[_getEmoji(char.character)] = char.meaning;
                        } else {
                          final otherChars = WordData.lessons[widget.lessonNumber]!
                              .where((c) => c != question.targetCharacter)
                              .toList();
                          if (otherChars.isNotEmpty && i < question.options.length) {
                            options[_getEmoji(otherChars[i % otherChars.length])] =
                                question.options[i];
                          }
                        }
                      }

                      final entries = options.entries.toList();
                      final emoji = index < entries.length ? entries[index].key : '❓';
                      final label = index < entries.length ? entries[index].value : '';

                      return ImageOptionCard(
                        imageEmoji: emoji,
                        label: label,
                        isSelected: gameState.selectedIndex == index,
                        isCorrect: index == question.correctIndex,
                        isAnswered: gameState.isAnswered,
                        onTap: () {
                          ref.read(gameProvider.notifier).selectAnswer(index);
                          if (index != question.correctIndex) {
                            ref.read(progressProvider.notifier).addWrongAnswer(
                              question.targetCharacter,
                              widget.lessonNumber,
                            );
                          } else {
                            ref.read(progressProvider.notifier).markCorrect(
                              question.targetCharacter,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                if (gameState.isAnswered)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ChildFriendlyButton(
                      label: '下一题',
                      icon: Icons.arrow_forward,
                      color: AppColors.primary,
                      onTap: () => ref.read(gameProvider.notifier).nextQuestion(),
                      isLarge: true,
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
            if (gameState.isAnswered && gameState.isCorrect == true)
              Positioned.fill(
                child: Container(
                  color: AppColors.success.withOpacity(0.2),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 100)),
                  ),
                ).animate().fadeOut(delay: 500.ms),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultScreen extends ConsumerWidget {
  final int lessonNumber;
  final int correctAnswers;
  final int totalQuestions;
  final int stars;

  const _ResultScreen({
    required this.lessonNumber,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.stars,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(progressProvider.notifier).updateLessonStars(lessonNumber, stars);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stars == 3 ? '🎉' : stars >= 1 ? '👏' : '💪',
                style: const TextStyle(fontSize: 80),
              ).animate().scale(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                stars == 3
                    ? '太棒了！'
                    : stars >= 1
                        ? '做得好！'
                        : '继续加油！',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: AppSpacing.lg),
              StarRating(stars: stars, maxStars: 3),
              const SizedBox(height: AppSpacing.xl),
              Text(
                '答对 $correctAnswers / $totalQuestions 题',
                style: const TextStyle(
                  fontSize: 24,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ChildFriendlyButton(
                label: '再学一次',
                icon: Icons.refresh,
                color: AppColors.primary,
                onTap: () {
                  ref.read(gameProvider.notifier).resetGame();
                  ref.read(gameProvider.notifier).startGame(lessonNumber);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              ChildFriendlyButton(
                label: '返回课程',
                icon: Icons.list,
                color: AppColors.secondary,
                onTap: () => context.go('/lessons'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

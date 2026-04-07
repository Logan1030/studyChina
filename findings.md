# 发现与决策

## 需求
用户要求重新设计识字游戏 APP，新的层次结构：
1. **首页 → 册数选择** - 首先选择"第几册"
2. **册 → 课程列表** - 每册包含多课
3. **课 → 功能模块** - 学习、规划、考核、错题

### 功能模块定义（待确认）
| 模块 | 描述 |
|------|------|
| 学习 | 汉字认读练习，看字听音 |
| 规划 | 学习计划/复习计划 |
| 考核 | 测试模式，检验认字能力 |
| 错题 | 错误汉字收集，重点复习 |

## 当前内容结构
- word.md 包含 30 课
- 每课约 8-16 个汉字
- 总计约 400+ 汉字

## 内容分析
| 课 | 字数 | 内容特征 |
|----|-----|---------|
| 1-11 | 约160字 | 基础汉字（人、口、大、小、一、二...） |
| 12-20 | 约144字 | 重复内容较多 |
| 21-30 | 约64字 | 进阶内容 |

## 技术现状
- Flutter iOS app
- Riverpod 状态管理
- GoRouter 路由
- Hive 本地存储
- 现有路由：`/`, `/lessons`, `/lesson/:number`, `/wrong-notebook`, `/settings`

## 新路由设计
| 路由 | 页面 | 功能 |
|------|------|------|
| `/` | VolumeSelectionScreen | 册数选择（3册） |
| `/volume/:volumeId` | LessonListScreen | 课程列表（每册10课） |
| `/volume/:volumeId/lesson/:lessonNumber` | ModuleSelectScreen | 功能选择（学习/规划/考核/错题） |
| `/study/:lessonNumber` | StudyScreen | 学习模式（认读练习） |
| `/exam/:lessonNumber` | ExamScreen | 考核模式（测试） |
| `/planning/:volumeId` | PlanningScreen | 规划模式（学习目标） |
| `/wrong-notebook` | WrongNotebookScreen | 错题本 |
| `/settings` | SettingsScreen | 设置 |

## 新数据模型

### Volume（册）
```dart
class Volume {
  final int id;           // 1, 2, 3
  final String title;     // "第一册"
  final int startLesson;  // 1
  final int endLesson;   // 10
}
```

### LearningGoal（学习目标）
```dart
class LearningGoal {
  final int dailyTarget;      // 每日目标字数
  final int weeklyTarget;     // 每周目标字数
  final int completedToday;   // 今日已完成
  final int completedThisWeek; // 本周已完成
  final DateTime lastUpdated;
}
```

### VolumeProgress（册进度）
```dart
class VolumeProgress {
  final int volumeId;
  final Map<int, int> lessonStars;  // lessonNumber -> stars
  final List<int> masteredLessons;   // 掌握课程
  final int totalStars;
}
```

## 页面组件清单

| 页面 | 组件 |
|------|------|
| VolumeSelectionScreen | VolumeCard, ProgressOverview |
| LessonListScreen | LessonCard, LessonProgressBar |
| ModuleSelectScreen | ModuleCard (学习/规划/考核/错题) |
| StudyScreen | CharacterCard, AudioButton, ProgressIndicator |
| ExamScreen | QuestionCard, AnswerOption, ScoreDisplay |
| PlanningScreen | GoalSetter, WeeklyProgress, StreakCard |
| WrongNotebookScreen | WrongCharacterCard, ReviewButton |

## 状态管理方案

| Provider | 类型 | 用途 |
|----------|------|------|
| `volumesProvider` | Provider | 静态册数据 |
| `volumeProgressProvider` | StateNotifier | 册进度（星级） |
| `learningGoalProvider` | StateNotifier | 学习目标 |
| `studySessionProvider` | StateNotifier | 学习会话状态 |
| `examResultProvider` | StateNotifier | 考核成绩 |
| `wrongAnswersProvider` | Provider | 错题列表 |

## 遇到的问题
| 问题 | 解决方案 |
|------|---------|
| 原有30课内容分散 | 重新分组到各册 |
| 学习vs考核区别不清 | 待与用户确认 |

## 已确认决策
| 决策 | 内容 |
|------|------|
| 册数划分 | 每册10课，共3册（第1-10课=第一册，第11-20课=第二册，第21-30课=第三册） |
| 规划模块 | 学习目标 - 设定每日/每周学习目标，追踪进度 |

### 内容分组
| 册 | 课程 | 字数 |
|----|-----|------|
| 第一册 | 第1-10课 | 约160字 |
| 第二册 | 第11-20课 | 约144字（部分重复） |
| 第三册 | 第21-30课 | 约64字 |

### 各模块功能定义
| 模块 | 功能 |
|------|------|
| 学习 | 汉字认读练习，看字听音，反复练习 |
| 规划 | 设定学习目标（每日/每周目标），追踪完成进度 |
| 考核 | 测试认字正确率，记录成绩 |
| 错题 | 错误汉字收集，重点复习 |

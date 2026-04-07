import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/volume/volume_selection_screen.dart';
import 'presentation/screens/volume/lesson_list_screen.dart';
import 'presentation/screens/volume/module_select_screen.dart';
import 'presentation/screens/volume/study_screen.dart';
import 'presentation/screens/volume/exam_screen.dart';
import 'presentation/screens/volume/planning_screen.dart';
import 'presentation/screens/wrong_notebook/wrong_notebook_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';

// Router instance
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const VolumeSelectionScreen(),
    ),
    GoRoute(
      path: '/volume/:volumeId',
      builder: (context, state) {
        final volumeId = int.parse(state.pathParameters['volumeId'] ?? '1');
        return LessonListScreen(volumeId: volumeId);
      },
    ),
    GoRoute(
      path: '/volume/:volumeId/lesson/:lessonNumber',
      builder: (context, state) {
        final volumeId = int.parse(state.pathParameters['volumeId'] ?? '1');
        final lessonNumber = int.parse(state.pathParameters['lessonNumber'] ?? '1');
        return ModuleSelectScreen(volumeId: volumeId, lessonNumber: lessonNumber);
      },
    ),
    GoRoute(
      path: '/study/:lessonNumber',
      builder: (context, state) {
        final lessonNumber = int.parse(state.pathParameters['lessonNumber'] ?? '1');
        return StudyScreen(lessonNumber: lessonNumber);
      },
    ),
    GoRoute(
      path: '/exam/:lessonNumber',
      builder: (context, state) {
        final lessonNumber = int.parse(state.pathParameters['lessonNumber'] ?? '1');
        return ExamScreen(lessonNumber: lessonNumber);
      },
    ),
    GoRoute(
      path: '/planning/:volumeId',
      builder: (context, state) {
        final volumeId = int.parse(state.pathParameters['volumeId'] ?? '1');
        return PlanningScreen(volumeId: volumeId);
      },
    ),
    GoRoute(
      path: '/wrong-notebook',
      builder: (context, state) => const WrongNotebookScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class StudyChinaApp extends StatelessWidget {
  const StudyChinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '识词游戏',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

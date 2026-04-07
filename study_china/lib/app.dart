import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/lesson/lesson_selection_screen.dart';
import 'presentation/screens/game/game_screen.dart';
import 'presentation/screens/wrong_notebook/wrong_notebook_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';

// Router instance that can be accessed for test reset
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/lessons',
      builder: (context, state) => const LessonSelectionScreen(),
    ),
    GoRoute(
      path: '/lesson/:number',
      builder: (context, state) {
        final number = int.parse(state.pathParameters['number'] ?? '1');
        return GameScreen(lessonNumber: number);
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

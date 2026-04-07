# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**study_china** is a Flutter iOS application for Chinese character learning aimed at kindergarten senior class (大班) children. The app presents lessons as interactive games where children learn to recognize and read Chinese characters.

**Root directory** contains teaching content: `word.md` (30 lessons of characters), `studyWay.md` (teaching methodology), and JPEG teaching images.

## Flutter App Structure (`study_china/`)

```
study_china/
├── lib/
│   ├── main.dart                    # Entry point, Hive init, ProviderScope
│   ├── app.dart                     # App widget with GoRouter navigation
│   ├── core/theme/                  # AppTheme configuration
│   ├── data/
│   │   ├── models/                  # Hive models (Character, Volume, VolumeProgress, LearningGoal, WrongAnswer)
│   │   ├── datasources/
│   │   │   ├── assets/word_data.dart  # Static lesson character data
│   │   │   └── local/hive_datasource.dart  # Hive persistence
│   │   └── presentation/
│   │       ├── providers/           # Riverpod providers (volume_provider, game_provider)
│   │       └── screens/
│   │           ├── home/            # HomeScreen
│   │           ├── volume/           # VolumeSelectionScreen, LessonListScreen, ModuleSelectScreen, StudyScreen, ExamScreen, PlanningScreen
│   │           ├── game/            # GameScreen
│   │           ├── wrong_notebook/   # WrongNotebookScreen
│   │           └── settings/         # SettingsScreen
│   └── presentation/widgets/        # Shared game widgets
├── pubspec.yaml
└── ios/                            # iOS Runner project
```

## Tech Stack

| Concern | Solution |
|---------|----------|
| State Management | flutter_riverpod ^2.4.9 |
| Navigation | go_router ^12.1.1 |
| Local Storage | hive ^2.2.3 + hive_flutter ^1.1.0 |
| Audio | audioplayers ^5.2.1 |
| UI Animations | flutter_animate ^4.3.0 |
| Fonts | google_fonts ^6.1.0 |

## Key Commands

```bash
cd study_china

# Install dependencies
flutter pub get

# Run on iOS Simulator
flutter run -d <simulator_id>

# Run on specific iOS device
flutter run -d <device_id>

# Build iOS for simulator
flutter build ios --simulator --no-codesign

# Run tests
flutter test

# Generate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# Integration tests
flutter test integration_test/
```

## Data Model

- **Character**: single character with pinyin, meaning, category
- **Volume**: book/册 (id, title, startLesson, endLesson) - 3 volumes, 10 lessons each
- **VolumeProgress**: tracks lesson stars (0-3) and mastered lessons per volume
- **LearningGoal**: daily/weekly targets, current streak tracking
- **WrongAnswer**: tracks incorrectly answered characters for review

## Navigation Routes

| Route | Screen | Parameters |
|-------|--------|------------|
| `/` | HomeScreen | - |
| `/volume/:volumeId` | LessonListScreen | volumeId (1-3) |
| `/volume/:volumeId/lesson/:lessonNumber` | ModuleSelectScreen | volumeId, lessonNumber |
| `/study/:lessonNumber` | StudyScreen | lessonNumber |
| `/exam/:lessonNumber` | ExamScreen | lessonNumber |
| `/planning/:volumeId` | PlanningScreen | volumeId |
| `/wrong-notebook` | WrongNotebookScreen | - |
| `/settings` | SettingsScreen | - |

## Content Files (Root Directory)

- `word.md` - Source of truth for 30 lessons, each with ~16 characters
- `studyWay.md` - Teaching methodology (汉字教学法, 提高专注力, 词语教学法, 短文教学法)
- `*.jpeg` - Teaching images (汉字教学法.jpeg, 提高专注力.jpeg, etc.)

## Development Notes

- Hive models use `hive_generator` for TypeAdapter generation
- Run `dart run build_runner build --delete-conflicting-outputs` after modifying Hive models
- The app hierarchy: Volume → Lesson → Module (学习/考核/错题/规划)
- App name displayed is "识 字"
- Character data is loaded from static `WordData` class, not from word.md at runtime

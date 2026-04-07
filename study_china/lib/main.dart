import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local/hive_datasource.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatasource.init();

  runApp(
    const ProviderScope(
      child: StudyChinaApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/screens/main_app_screen.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: rootNavigatorKey,
      theme: MainTheme.defaultLight,
      home: const MainAppPage(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/project_module/database/project_database.dart';
import 'package:task_calendar/project_module/project_main_theme.dart';
import 'package:task_calendar/screens/main_app_screen.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/shared_preference.dart';

import 'l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppShared.init();
  await tasksDatabase.init(); // Ждём, пока init завершится
  await ProjectDatabase.init();
  Intl.defaultLocale = 'ru';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: const Locale('ru'),
      navigatorKey: rootNavigatorKey,
      theme: ProjectMainTheme.theme,
      darkTheme: ProjectMainTheme.theme,
      home: const MainAppPage(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

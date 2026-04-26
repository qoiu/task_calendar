import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/project_module/task_main_theme.dart';
import 'package:task_calendar/screens/main_app_screen.dart';
import 'package:task_calendar/themes.dart';

import 'l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   // Для Android: делаем иконки белыми
  //   statusBarIconBrightness: Brightness.light,
  //   // Для iOS: установка Light здесь заставляет систему отображать белый шрифт
  //   statusBarBrightness: Brightness.dark,
  //
  //   systemNavigationBarColor: Colors.black,
  //   systemNavigationBarIconBrightness: Brightness.light,
  // ));
  await tasksDatabase.init(); // Ждём, пока init завершится
  // await skillDatabase.init(); // Ждём, пока init завершится
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
      theme: TaskMainTheme.theme,
      darkTheme: TaskMainTheme.theme,
      home: const MainAppPage(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/screens/main_app_screen.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await tasksDatabase.init(); // Ждём, пока init завершится
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
      theme: MainTheme.defaultLight,
      home: const MainAppPage(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

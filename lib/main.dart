import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:task_calendar/database/main_database.dart';
import 'package:task_calendar/project_module/database/project_database.dart';
import 'package:task_calendar/project_module/project_main_theme.dart';
import 'package:task_calendar/screens/main_app_screen.dart';
import 'package:task_calendar/utils/shared_preference.dart';

import 'l10n/app_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'magic_alarm_channel_id',
  'Чудесные Уведомления',
  description: 'Канал для запуска таймеров в фоне',
  importance: Importance.max,
  playSound: true,
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppShared.init();
  await DB.main.init(); // Ждём, пока init завершится
  print('init ProjectDatabase');
  await ProjectDatabase.main.init();
  Intl.defaultLocale = 'ru';
  runApp(const MyApp());
}

Future<void> initAlarm() async {
  // В новых версиях инициализируем плагин через пустой внутренний callback
  await AndroidAlarmManager.initialize();

  // Настройка локальных уведомлений
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

  // Создаем канал уведомлений (для Android 8.0+)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'magic_alarm_channel_id',
    'Чудесные Уведомления',
    importance: Importance.max,
    // priority: Priority.high,
    playSound: true,
  );

  final androidImplementation = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (androidImplementation != null) {
    await androidImplementation.createNotificationChannel(channel);
    print("=== КАНАЛ УВЕДОМЛЕНИЙ ИНИЦИАЛИЗИРОВАН ===");
  }
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

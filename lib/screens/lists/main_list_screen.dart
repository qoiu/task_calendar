import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/main.dart';
import 'package:task_calendar/screens/lists/components/list_date_time_item.dart';
import 'package:task_calendar/screens/lists/components/main_list_controller.dart';
import 'package:task_calendar/screens/lists/unsigned_tasks.dart';
import 'package:task_calendar/utils/utils.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MainListScreen extends StatefulWidget {
  const MainListScreen({super.key});

  @override
  State<MainListScreen> createState() => _MainListScreenState();
}

class _MainListScreenState extends State<MainListScreen> {
  ScrollController _scrollController = ScrollController();
  List<int> _items = List.generate(20, (i) => i); // начальные данные
  bool _isLoadingTop = false;
  bool _isLoadingBottom = false;
  bool showPlans = false;
  MainListController listController = MainListController();
  late UnsignedTasksController unsignedTasksController;
  GlobalKey addKey = GlobalKey();

  @override
  void initState() {
    unsignedTasksController =
        UnsignedTasksController(update: () => setState(() {}));
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      setState(() {});

      tz.initializeTimeZones();
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final granted = await androidImplementation
          ?.requestNotificationsPermission();
      await androidImplementation
          ?.requestFullScreenIntentPermission();

      final exactGranted = await androidImplementation
          ?.requestExactAlarmsPermission();
      print('Exact alarms permission granted: $exactGranted');
      final list = await androidImplementation?.pendingNotificationRequests();

      await flutterLocalNotificationsPlugin.cancel(124);
      await flutterLocalNotificationsPlugin.cancel(126);
      await flutterLocalNotificationsPlugin.cancel(151);
      'list: ${list?.map((e) => '${e.title} - ${e.body} - ${e.id} - ${e
          .payload}').toList().toString()}'.print();
      // Шаг 2: Получаем строку таймзоны с устройства, например "Europe/Moscow"
      final String localTimeZone = await FlutterNativeTimezone
          .getLocalTimezone();
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15));
      var dateTime = DateTime.now().add(Duration(minutes: 2));
      ['notifi should appear at', localTimeZone].print();
      ['notifi should appear at', dateTime].print();
      // await flutterLocalNotificationsPlugin.zonedSchedule(
      //   133, // ID уведомления
      //   'testNotify2', // заголовок
      //   'test2', // тело
      //   tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15)),
      //   NotificationDetails(android: androidDetails()),
      //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //   matchDateTimeComponents: null, // если не повторяется
      // );
      await AndroidAlarmManager.oneShot(
        const Duration(seconds: 15),
        0, // уникальный ID
        backgroundCallback,
        exact: true,
        wakeup: true,
      );
      ['notifi should appear at', dateTime].print();
      while (true) {
        await Future.delayed(Duration(seconds: 1));
        ['time', DateTime.now()].print();
      }
    });
  }
  void backgroundCallback() async {
    final plugin = FlutterLocalNotificationsPlugin();

    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Scheduled Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    await plugin.show(
      0,
      'Фоновое уведомление',
      'Даже если приложение закрыто!',
      const NotificationDetails(android: androidDetails),
    );
  }

  void _onScroll() {
    const threshold = 100;

    // Прокрутка вверх
    if (_scrollController.offset <= threshold && !_isLoadingTop) {
      _loadMoreTop();
    }

    // Прокрутка вниз
    if (_scrollController.position.maxScrollExtent - _scrollController.offset <=
        threshold &&
        !_isLoadingBottom) {
      _loadMoreBottom();
    }
  }

  Future<void> _loadMoreTop() async {
    if (_isLoadingTop) return;
    _isLoadingTop = true;

    // Запоминаем позицию до добавления новых элементов
    final scrollOffsetBefore = _scrollController.offset;
    final scrollSize = _scrollController.position.maxScrollExtent;

    final newItems = List.generate(1, (i) => _items.first - i - 1);
    'new items: $newItems'.dpGreen().print();
    _items.insertAll(0, newItems);

    setState(() {});

    // Отложенный скролл, чтобы сохранить позицию
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var max = _scrollController.position.maxScrollExtent;
      var jumpTo = scrollOffsetBefore + (max - scrollSize);
      debugPrint('jump: $scrollOffsetBefore -> $jumpTo'.dpYellow());
      _scrollController.jumpTo(
        jumpTo,
      );
      _isLoadingTop = false;
    });
  }

  Future<void> _loadMoreBottom() async {
    setState(() => _isLoadingBottom = true);

    final newItems = List.generate(1, (i) => _items.last + i + 1);
    _items.addAll(newItems);

    setState(() => _isLoadingBottom = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            child: ListView(
              controller: _scrollController,
              children: _items.map((i) {
                return ListDateTimeItem(
                  formatDate.format(DateTime.now().add(Duration(days: i))),
                  listController: listController,
                  update: () => setState(() {}),
                  key: Key('dayOffset_$i}'),
                );
              }).toList(),
            ),
          ),
          UnsignedTasks(
              update: () => setState(() {}),
              controller: unsignedTasksController,
              listController: listController),
          Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(30),
              child: Container(
                width: 50,
                height: 50,
                key: addKey,
                child: FloatingActionButton(
                  onPressed: () {
                    ['showPlan', unsignedTasksController.showPlan].print();
                    if (!unsignedTasksController.showPlan) {
                      unsignedTasksController.show();
                    } else {
                      unsignedTasksController.createTask();
                    }
                  },
                  shape: const CircleBorder(),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

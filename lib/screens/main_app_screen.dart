
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qoiu_utils/extensions/color.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/project_module/project_main_theme.dart';
import 'package:task_calendar/project_module/task_loader_screen.dart';
import 'package:task_calendar/screens/lists/main_list_screen.dart';
import 'package:task_calendar/screens/log_list.dart';
import 'package:task_calendar/screens/menu/menu_page.dart';
import 'package:task_calendar/screens/skills/skills_list.dart';
import 'package:task_calendar/utils/enum/screen_tag.dart';
import 'package:task_calendar/utils/shared_preference.dart';
import 'package:task_calendar/utils/utils.dart';
import 'package:timezone/browser.dart' as tz;

import '../main.dart';

String? currentRoute;

@pragma('vm:entry-point')
void alarmCallback() async {
  // Эту строку вы обязаны увидеть в консоли ровно через минуту!
  print("=== СИСТЕМА ANDROID ВЫЗВАЛА ALARM_CALLBACK! ===");

  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin bgNotifyPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  await bgNotifyPlugin.initialize(settings: const InitializationSettings(android: initAndroid));

  await bgNotifyPlugin.show(
    id: 1,
    title: 'Чудо произошло! 🎉',
    body: 'Таймер сработал.',
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'magic_alarm_channel_id',
        'Чудесные Уведомления',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPage();
}
String _currentTabKey = 'current_tab_key';
class _MainAppPage extends State<MainAppPage> {
  int currentIndex = AppShared.prefs.getInt(_currentTabKey)??3;

  List<TabItem> tabs = [];

  @override
  void initState() {
    super.initState();
    // DB.main.init();
    initTabs();
    ['cIndex',AppShared.prefs.getInt(_currentTabKey)].print();
    currentIndex = AppShared.prefs.getInt(_currentTabKey)??3;
    tabs[currentIndex].isLoaded = true;
    // Ждем, пока виджет полностью инициализируется в системе, и только потом запускаем
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInstantNotification();
    });
  }


  Future<void> showInstantNotification() async {
    // 1. Проверяем и запрашиваем разрешение на уведомления (для Android 13+)
    final bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (granted ?? false) {
      // 2. Настраиваем внешний вид и важность уведомления
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'magic_alarm_channel_id', // ID канала (должен совпадать с тем, что создали в initAlarm)
        'Чудесные Уведомления',    // Имя канала
        importance: Importance.max, // Максимальная важность (чтобы всплыл баннер сверху)
        priority: Priority.high,    // Высокий приоритет
        playSound: true,            // Включить звук
        icon: '@mipmap/ic_launcher',
      );

      const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      // 3. Показываем уведомление мгновенно
      await flutterLocalNotificationsPlugin.show(
        id: 999, // Уникальный ID конкретного пуша (если вызвать с тем же ID, старое пуш заменится новым)
        title: 'Мгновенное чудо! ⚡', // Заголовок
        body: 'Это уведомление пришло прямо сейчас.', // Текст сообщения
        notificationDetails: platformDetails,
      );
    } else {
      print("Пользователь запретил показ уведомлений!");
    }
  }
  // Метод для запуска таймера
  void _startPreciseTimer() async {
    // 1. Запрашиваем разрешения
    final bool? notificationsGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final bool? exactAlarmGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    if ((notificationsGranted ?? false) && (exactAlarmGranted ?? true)) {

      // Вычисляем время: прямо сейчас + 1 минута
      final tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.getLocation('Europe/Moscow')).add(const Duration(minutes: 1));

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'precise_magic_channel_id',
        'Точные Уведомления',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      // ОС Android сама берет на себя задачу показать пуш ровно через 60 сек!
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: 777, // ID уведомления
        title: 'Чудо произошло! 🌟',
        body: 'Прошла ровно 1 минута.',
        scheduledDate: scheduledTime,
        notificationDetails: const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Пробивает режим сна и закрытое приложение

        // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      print("=== ТАЙМЕР ЗАПЛАНИРОВАН В ОС НА 1 МИНУТУ ===");
    } else {
      print("Нет системных разрешений!");
    }
  }

  void initTabs() {
    tabs = [
      TabItem(
          icon: "assets/svg/menu_lists.svg",
          title: () => getString().menu_lists,
          tag: ScreenTag.MAIN_LISTS.name,
          screenBuilder: (context) => const MainListScreen(),
          index: 0),
      TabItem(
          icon: "assets/svg/menu_calendar.svg",
          title: () => 'Навыки',
          tag: ScreenTag.MAIN_CALENDAR.name,
          screenBuilder: (context) => const SkillsList(),
          index: 1),
      TabItem(
          icon: "assets/svg/menu_calendar.svg",
          title: () => 'Логи',
          tag: ScreenTag.MAIN_CALENDAR.name,
          screenBuilder: (context) => LogList(),
          index: 2),
      TabItem(
          icon: "assets/svg/menu_calendar.svg",
          title: () => 'Проекты',
          tag: ScreenTag.MAIN_CALENDAR.name,
          screenBuilder: (context) => TaskLoaderScreen(),
          index: 3),
      TabItem(
          icon: "assets/svg/menu_settings.svg",
          title: () => getString().menu_settings,
          tag: ScreenTag.MAIN_SETTINGS.name,
          screenBuilder: (context) => const MenuPage(),
          index: 4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        debugPrint("route: $currentRoute");
        var navigation = Navigator.of(rootNavigatorKey.currentContext!);
        if (navigation.canPop()) {
          navigation.pop();
          return false;
        }
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          // Белые иконки на Android
          statusBarIconBrightness: Brightness.light,
          // Белые иконки на iOS
          statusBarBrightness: Brightness.dark,
          // Сохраняем настройки навигационной панели
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: ProjectMainTheme.surface,
          bottomNavigationBar: Container(
              // Добавляем границу сверху
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: getColorScheme().outline.withOpacity(0.2),
                    // Цвет линии
                    width: 0.5, // Толщина линии
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                items:
                    tabs.map((e) => e.getBottomBarItem(currentIndex)).toList(),
                onTap: (index) async{
                  await AppShared.prefs.setInt(_currentTabKey, index);
                  ['cIndex',AppShared.prefs.getInt(_currentTabKey)].print();
                  setState(() {
                    tabs[index].isLoaded = true;
                    if (index == currentIndex) {
                      Navigator.of(tabs[index].key.currentContext!)
                          .popUntil((route) => route.isFirst);
                    } else {
                      currentIndex = index;
                    }
                  });
                },
                selectedItemColor: getColorScheme().primary,
                unselectedItemColor: getColorScheme().outline,
                unselectedFontSize: 11,
                selectedFontSize: 11,
                elevation: 2,
                backgroundColor: ProjectMainTheme.surface,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
              )),
          body: Stack(
            children: [
              IndexedStack(
                  index: currentIndex,
                  children: tabs.map((e) => e.getWidget()).toList()),
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 80, right: 10),
                child: kDebugMode
                    ? const Column(
                        children: [
                          // Text("v.0.0.14",style: getTextStyle(context).bodySmall?.copyWith(fontSize: 8),),
                        ],
                      )
                    : Container(),
              ),
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: IgnorePointer(
                  child: Container(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).viewPadding.top,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                getColorScheme().surface.withAlpha(0),
                                getColorScheme().surface.withAlpha(200),
                                getColorScheme().surface.withAlpha(255),
                              ],
                              begin: Alignment.bottomCenter,
                              end: AlignmentGeometry.topCenter,
                              stops: const [0, 0.2, 0.6]))),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.bottomRight,
                child: GestureDetector(
                  onTap: (){
                    ['tap'].print();
                    showInstantNotification();
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.red,
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TabItem {
  bool isLoaded = false;
  final String icon;
  final String Function() title;
  final WidgetBuilder screenBuilder;
  late Widget widget;
  final int index;
  final List<NavigatorObserver>? observer;
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  final String tag;
  int notification = 0;
  bool showNotificationAmount = false;

  TabItem(
      {required this.icon,
      required this.title,
      required this.tag,
      this.observer,
      required this.screenBuilder,
      required this.index,
      this.showNotificationAmount = false,
      this.notification = 0}) {
    widget = Navigator(
      observers: observer ?? List<NavigatorObserver>.empty(growable: true),
      key: key,
      onGenerateRoute: (settings) {
        debugPrint("currentRoute = ${settings.name}");
        currentRoute = settings.name;
        return MaterialPageRoute(
            builder: screenBuilder, settings: RouteSettings(name: tag));
      },
    );
  }

  BottomNavigationBarItem getBottomBarItem(int currentIndex) {
    return BottomNavigationBarItem(
        icon: IntrinsicWidth(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 3),
            child: SvgPicture.asset(
              icon,
              colorFilter: (currentIndex == index
                      ? getColorScheme().primary
                      : getColorScheme().outline)
                  .defaultFilter(),
              height: 20,
            ),
          ),
        ),
        backgroundColor: getColorScheme().primaryContainer,
        label: title());
  }

  Widget getWidget() {
    return isLoaded ? widget : Container();
  }
}

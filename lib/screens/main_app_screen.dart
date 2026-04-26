import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/database/tasks_database.dart';
import 'package:task_calendar/project_module/task_board.dart';
import 'package:task_calendar/project_module/project_main_theme.dart';
import 'package:task_calendar/project_module/task_loader_screen.dart';
import 'package:task_calendar/screens/lists/main_list_screen.dart';
import 'package:task_calendar/screens/log_list.dart';
import 'package:task_calendar/screens/menu/menu_page.dart';
import 'package:task_calendar/screens/skills/skills_list.dart';
import 'package:task_calendar/screens/stub_screen.dart';
import 'package:task_calendar/utils/enum/screen_tag.dart';
import 'package:task_calendar/utils/shared_preference.dart';
import 'package:task_calendar/utils/utils.dart';

String? currentRoute;

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
    tasksDatabase.init();
    initTabs();
    ['cIndex',AppShared.prefs.getInt(_currentTabKey)].print();
    currentIndex = AppShared.prefs.getInt(_currentTabKey)??3;
    tabs[currentIndex].isLoaded = true;
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

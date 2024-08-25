import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_calendar/screens/lists/main_custom_list_screen.dart';
import 'package:task_calendar/screens/lists/main_list_screen.dart';
import 'package:task_calendar/screens/stub_screen.dart';
import 'package:task_calendar/utils/enum/screen_tag.dart';
import 'package:task_calendar/utils/utils.dart';


String? currentRoute;

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPage();
}

class _MainAppPage extends State<MainAppPage> {
  int currentIndex = 0;

  List<TabItem> tabs = [];

  @override
  void initState() {
    super.initState();
    initTabs();
    tabs[0].isLoaded = true;
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
          title: () => getString().menu_calendar,
          tag: ScreenTag.MAIN_CALENDAR.name,
          screenBuilder: (context) => const MainCustomListScreen(),
          index: 1),
      TabItem(
          icon: "assets/svg/menu_settings.svg",
          title: () => getString().menu_settings,
          tag: ScreenTag.MAIN_SETTINGS.name,
          screenBuilder: (context) => StubScreen(getString().menu_settings),
          index: 2),
    ];
  }

  void onSwitchTabClick(int index, {bool forcePop = false}) {
    debugPrint("onSwitchTabClick($index,$forcePop)");
    setState(() {
      tabs[index].isLoaded = true;
    });
    if (index == currentIndex) {
      Navigator.of(tabs[index].key.currentContext!)
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentIndex = index;
      });
    }
    if (forcePop) {
      Navigator.of(tabs[index].key.currentContext!)
          .popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
      BottomNavigationBar(
              currentIndex: currentIndex,
              items: tabs.map((e) => e.getBottomBarItem(currentIndex)).toList(),
              onTap: (index) {
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
              backgroundColor: getColorScheme().surface,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
      body: SafeArea(
        child: Stack(
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
          ],
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
    widget = WillPopScope(
      child: Navigator(
        observers: observer ?? List<NavigatorObserver>.empty(growable: true),
        key: key,
        onGenerateRoute: (settings) {
          debugPrint("currentRoute = ${settings.name}");
          currentRoute = settings.name;
          return MaterialPageRoute(
              builder: screenBuilder, settings: RouteSettings(name: tag));
        },
      ),
      onWillPop: () async {
        debugPrint("route: $currentRoute");
        var navigation = Navigator.of(key.currentContext!);
        if (navigation.canPop()) {
          navigation.pop();
          return false;
        }
        return true;
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
              color: currentIndex == index
                  ? getColorScheme().primary
                  : getColorScheme().onPrimary,
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
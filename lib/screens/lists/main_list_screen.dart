import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utills.dart';
import 'package:task_calendar/screens/lists/components/list_date_time_item.dart';
import 'package:task_calendar/screens/lists/components/main_list_controller.dart';
import 'package:task_calendar/screens/lists/unsigned_tasks.dart';
import 'package:task_calendar/utils/utils.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    return Stack(
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
            showPlan: showPlans,
            update: () => setState(() {}),
            hideScreen: () => showPlans = false,
            listController: listController),
        Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(30),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  showPlans = !showPlans;
                });
              },
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task_calendar/screens/lists/components/list_date_time_item.dart';
import 'package:task_calendar/utils/utils.dart';

class MainListScreen extends StatefulWidget {
  const MainListScreen({super.key});

  @override
  State<MainListScreen> createState() => _MainListScreenState();
}

class _MainListScreenState extends State<MainListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(60, (i){
        return ListDateTimeItem(formatDate.format(DateTime.now().add(Duration(days: i))));
      }),
    );
  }
}

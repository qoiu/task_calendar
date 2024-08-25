import 'package:flutter/material.dart';
import 'package:task_calendar/screens/lists/components/list_date_item.dart';
import 'package:task_calendar/screens/lists/components/list_time_Item.dart';

class ListDateTimeItem extends StatefulWidget {
  final String date;
  const ListDateTimeItem(this.date, {super.key});

  @override
  State<ListDateTimeItem> createState() => _ListDateTimeItemState();
}

class _ListDateTimeItemState extends State<ListDateTimeItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListDateItem(widget.date),
        ...List.generate(24, (i)=>ListTimeItem("${i.toString().padLeft(2,'0')}:00"))
      ],
    );
  }
}

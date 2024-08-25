import 'package:flutter/material.dart';
import 'package:task_calendar/components/text_builder.dart';
import 'package:task_calendar/utils/utils.dart';

class ListDateItem extends StatelessWidget {
  final String date;
  const ListDateItem(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: getColorScheme().primary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20)
        ),
        padding: const EdgeInsets.all(5),
        child: TextBuilder(date).build(),
      ),
    );
  }
}

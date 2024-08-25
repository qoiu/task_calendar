import 'package:flutter/material.dart';
import 'package:task_calendar/components/text_builder.dart';
import 'package:task_calendar/utils/utils.dart';

class ListTimeItem extends StatelessWidget {
  final String time;

  const ListTimeItem(this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextBuilder(time).build()),
        Divider(
          color: getColorScheme().onPrimary,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/utils/utils.dart';

class ListDateItem extends StatelessWidget {
  final String date;
  const ListDateItem(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    var weekday = formatDate.tryParse(date)?.let((e)=>formatDateWithWeekday.format(e))??date;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: getColorScheme().outline, width: 0.5),
        color: getColorScheme().outline.withAlpha(90),
        borderRadius: BorderRadius.circular(5)
      ),
      padding: const EdgeInsets.all(5),
      child: TextBuilder((weekday).replaceRange(0, 1, weekday.substring(0,1).toUpperCase())).style(getTextStyle().bodyMedium).color(getColorScheme().surfaceContainer).fontSize(12).build(),
    );
  }
}

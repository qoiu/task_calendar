import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/database/log_queries.dart';
import 'package:task_calendar/database/skill_queries.dart';
import 'package:task_calendar/modals/create_skill/create_skill_modal.dart';
import 'package:task_calendar/modals/skill_progress_modal.dart';
import 'package:task_calendar/models/calendar_log.dart';
import 'package:task_calendar/models/skill.dart';
import 'package:task_calendar/screens/skills/components/skill_item.dart';
import 'package:task_calendar/utils/utils.dart';

class LogList extends StatefulWidget {
  const LogList({super.key});

  @override
  State<LogList> createState() => _LogListState();
}

class _LogListState extends State<LogList> {
  List<CalendarLog> logs = [];

  @override
  void initState() {
    super.initState();
    loadSkills();
  }

  loadSkills() async {
    logs = await logQueries.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
    ListView(
      padding: EdgeInsets.all(20),
      children: logs
          .indexedMap((index, log) => [
                Text(log.message),
                log.postDate?.let((e) => Text(formatDateTime.format(e),
                        style: getTextStyle().bodySmall)) ??
                    Container(),
                const SizedBox(height: 6),
              ])
          .expand((e) => e)
          .toList(),
    ),
    Container(
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: () async {
              var result = await const CreateSkillModal().show();
              if (result == true) {
                loadSkills();
              }
            },
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        )),
          ],
        );
  }
}

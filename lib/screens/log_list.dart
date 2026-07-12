import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/modals/create_skill/create_skill_modal.dart';
import 'package:task_calendar/models/calendar_log.dart';
import 'package:task_calendar/utils/utils.dart';

import '../database/main_database.dart';

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
    logs = await DB.logs.getAll();
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
                    index == 0
                        ? Container(
                            height: MediaQuery.of(context).viewPadding.top + 10)
                        : Container(),
                    Text(log.message),
                    log.postDate?.let((e) => Align(
                      alignment: AlignmentGeometry.topRight,
                      child: Text(formatDateTime.format(e),
                              style: getTextStyle().bodySmall),
                    )) ??
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
                backgroundColor: getColorScheme().primary,
                shape: const CircleBorder(),
                child: Icon(
                  Icons.add,
                  color: getColorScheme().onPrimary,
                ),
              ),
            )),
      ],
    );
  }
}

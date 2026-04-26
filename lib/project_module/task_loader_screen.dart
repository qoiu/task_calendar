import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:task_calendar/project_module/database/project_database.dart';
import 'package:task_calendar/project_module/models/project_data.dart';
import 'package:task_calendar/project_module/task_board.dart';
import 'package:task_calendar/project_module/utils/project_shared.dart';
import 'package:task_calendar/screens/lists/components/main_button.dart';
import 'package:task_calendar/utils/shared_preference.dart';

class TaskLoaderScreen extends StatefulWidget {
  const TaskLoaderScreen({super.key});

  @override
  State<TaskLoaderScreen> createState() => _TaskLoaderScreenState();
}

class _TaskLoaderScreenState extends State<TaskLoaderScreen> {
  bool isLoading = true;
  ProjectData? project;
  List<ProjectData> projects = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    projects = await ProjectDatabase.projects.getAll();
    if (projects.isEmpty) {
      var id = await ProjectDatabase.projects.add({'title': "Новый проект"});
      project = (await ProjectDatabase.projects.getById(id));
      project?.let((e)=>AppSharedProject.saveLastOpenProjectID(e.id));
    } else {
      var lastId = AppSharedProject.getLastOpenProjectID();
      if(projects.map((e)=>e.id).contains(lastId)) {
        // projectId = lastId;
        project = projects.where((e)=>e.id==lastId).first;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : project != null
            ? TaskBoard(project!)
            : ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      child: MainButton(projects[index].title, () {
                        setState(() {
                          project = projects[index];
                        });
                        project?.let((e)=>AppSharedProject.saveLastOpenProjectID(e.id));
                      }),
                    ));
  }
}

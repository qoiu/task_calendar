import 'package:task_calendar/models/task.dart';
import 'package:task_calendar/screens/lists/components/update_inherited.dart';

class MainListController{

  Task? taskTime;
  bool get selected => taskTime!=null;

  UpdateController refreshData = UpdateController();
}
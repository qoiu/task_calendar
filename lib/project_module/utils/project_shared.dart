import 'package:task_calendar/utils/shared_preference.dart';

const String _dbList = 'projects_list';
const String _dbLast = 'projects_last';

abstract class AppSharedProject {
  static List<String> getTitles() {
    var res = AppShared.prefs.getString(_dbList);
    return res?.split(',') ?? [];
  }

  static int? getLastOpenProjectID() {
    return AppShared.prefs.getInt(_dbLast);
  }

  static saveLastOpenProjectID(int id)async{
    await AppShared.prefs.setInt(_dbLast, id);
  }
}

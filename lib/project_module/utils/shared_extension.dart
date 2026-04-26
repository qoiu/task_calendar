import 'package:task_calendar/utils/shared_preference.dart';

const String _dbList = 'projects_list';

extension ProjectShared on AppShared {
  static List<String> getTitles() {
    var res = AppShared.prefs.getString(_dbList);
    return res?.split(',') ?? [];
  }
}

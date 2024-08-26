class Task {
  String title;
  String? description;
  DateTime start;
  DateTime end;

  Task(
      {required this.title,
      this.description,
      required this.start,
      required this.end});

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        start = json['start'],
        end = json['end'];

  Map<String, Object?> toDb() => {
        'title': title,
        'description': description,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch
      };
}

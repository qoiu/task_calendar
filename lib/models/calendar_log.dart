class CalendarLog {
  final int? id;
  final int priority;
  final String message;
  final DateTime? eventDate;
  final DateTime? postDate;
  final String? extra;

  CalendarLog(
      this.message,{
    this.id,
    this.eventDate,
    this.extra,
    this.priority=3
  }):postDate = DateTime.now();

  CalendarLog._({
    this.id,
    this.eventDate,
    this.extra,
    this.postDate,
    required this.message,
    this.priority=3
  });

  factory CalendarLog.fromMap(Map<String, dynamic> map) {
    return CalendarLog._(
      id: map['id'] as int,
      eventDate: map['event_date']!=null?DateTime.fromMillisecondsSinceEpoch(map['event_date'] as int):null,
      postDate: map['post_date']!=null?DateTime.fromMillisecondsSinceEpoch(map['post_date'] as int):null,
      extra: map['extra'] as String?,
      message: map['message'] as String,
      priority: map['priority'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'event_date': eventDate?.millisecondsSinceEpoch,
    'post_date': postDate?.millisecondsSinceEpoch,
    'extra': extra,
    'message': message,
    'priority': priority,
  };
}

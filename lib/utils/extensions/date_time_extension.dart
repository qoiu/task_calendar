extension DateTimeExtension on DateTime {
  bool sameDay(DateTime? other) {
    if(other==null)return false;
    return year == other.year &&
        month == other.month &&
        day == other.day;
  }
}
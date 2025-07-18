import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:qoiu_utils/navigation.dart';
import 'package:task_calendar/screens/lists/models/custom_data.dart';
import 'package:task_calendar/themes.dart';

AppLocalizations getString([BuildContext? context]) =>
    AppLocalizations.of(context ?? rootNavigatorKey.currentContext!);

DateFormat formatDate = DateFormat("dd.MM.yyyy");
DateFormat formatTime = DateFormat("HH:mm");
DateFormat formatDateTime = DateFormat("dd.MM.yyyy HH:mm");

extension OppositeColor on Color {
  Color oppositeColor() {
    var sum = (red + green + blue) / 3;
    return sum > 128 ? MainTheme.textColor : MainTheme.textColorWhite;
  }
}

DateTime? tryToGetTime(dynamic data){
  if(data is UiTime)return data.time;
  if(data is UiTask)return data.task.start;
  return null;
}

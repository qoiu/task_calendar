
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

ColorScheme getColorScheme([BuildContext? context]) =>
    Theme.of(context ?? rootNavigatorKey.currentContext!).colorScheme;

TextTheme getTextStyle([BuildContext? context]) =>
    Theme.of(context ?? rootNavigatorKey.currentContext!).textTheme;

AppLocalizations getString([BuildContext? context]) =>
    AppLocalizations.of(context ?? rootNavigatorKey.currentContext!);


DateFormat formatDate = DateFormat("dd.MM.yyyy");



extension PrintString on String {
  String dpRed() => "\x1B[31m$this\x1B[0m";
  String dpGreen() => "\x1B[32m$this\x1B[0m";
  String dpYellow() => "\x1B[33m$this\x1B[0m";
  String dpBlue() => "\x1B[34m$this\x1B[0m";
  print() => debugPrint(this);
  printLong() => debugPrint(this, wrapWidth: 1024);
}
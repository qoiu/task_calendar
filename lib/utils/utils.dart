
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

ColorScheme getColorScheme([BuildContext? context]) =>
    Theme.of(context ?? rootNavigatorKey.currentContext!).colorScheme;

TextTheme getTextStyle([BuildContext? context]) =>
    Theme.of(context ?? rootNavigatorKey.currentContext!).textTheme;

AppLocalizations getString([BuildContext? context]) =>
    AppLocalizations.of(context ?? rootNavigatorKey.currentContext!);
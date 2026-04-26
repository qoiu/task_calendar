// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get app_name => 'Qoiu Tasks';

  @override
  String get save => 'Сохранить';

  @override
  String get add => 'Добавить';

  @override
  String get apply => 'Применить';

  @override
  String get delete => 'Удалить';

  @override
  String get enter_text => 'Введите текст';

  @override
  String get error_message => 'Произошла ошибка';

  @override
  String get page_develop => 'Страница находится в разработке';

  @override
  String get menu_lists => 'Списки';

  @override
  String get menu_calendar => 'Календарь';

  @override
  String get menu_settings => 'Настройки';

  @override
  String get menu_settings_category => 'Настройка категорий';

  @override
  String get menu_settings_task => 'Настройка задач';

  @override
  String get menu_settings_currency => 'Настройка валют';
}

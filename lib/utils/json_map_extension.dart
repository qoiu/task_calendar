import 'dart:convert';

import 'package:qoiu_utils/qoiu_utils.dart';
import 'package:qoiu_utils/typedef.dart';

extension JsonMapExtension on JsonMap{
  JsonMap? get extra => (this['extra'] as String?)?.let((e)=>jsonDecode(this['extra']));
}
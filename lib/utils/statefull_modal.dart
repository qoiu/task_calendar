

import 'package:flutter/material.dart';
import 'package:task_calendar/utils/utils.dart';

abstract class StatefulModal extends StatefulWidget implements TaggedWidget{
  @override
  abstract final String tag;
  final bool isScrolled;
  final bool useSafeArea;

  const StatefulModal({this.isScrolled=true, this.useSafeArea=true, super.key});

  Future<T?> show<T>({BuildContext? context}) {
    return showModalBottomSheet(
        context: context??rootNavigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        useSafeArea: useSafeArea,
        isScrollControlled: isScrolled,
        builder: (context) => this,
        routeSettings: RouteSettings(name: tag));
  }
}

showModal(TaggedWidget modal, {BuildContext? context})async{
  debugPrint("showModal ${modal.tag}");
  await showModalBottomSheet(
      context: context??rootNavigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => modal as Widget,
      routeSettings: RouteSettings(name: modal.tag));
}

abstract class StatelessModal extends StatelessWidget implements TaggedWidget{
  @override
  abstract final String tag;

  const StatelessModal({super.key});

  Future<T?> show<T>({BuildContext? context}) async{
    return await showModalBottomSheet(
        context: context??rootNavigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (context) => this,
        routeSettings: RouteSettings(name: tag));
  }
}

abstract class TaggedWidget{
  abstract final String tag;
}
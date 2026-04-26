import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

class MainUpdateWidget extends InheritedWidget {
  final Function(VoidCallback fn) _setState;

  const MainUpdateWidget(
      {super.key,
      required super.child,
      required Function(VoidCallback fn) setState})
      : _setState = setState;

  update() {
    _setState(() {});
  }

  static MainUpdateWidget of(BuildContext context) {
    final MainUpdateWidget? result =
        context.dependOnInheritedWidgetOfExactType<MainUpdateWidget>();
    assert(result != null, 'No ChatInherit found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class UpdateController {
  VoidCallback _update = () {};
  Map<State, VoidCallback> _stateMap = {};

  subscribe(State state, VoidCallback update) {
    _stateMap.addAll({state: update});
  }

  dispose(State state) {
    'dispose update controller'.dpRed().print();
    _stateMap.remove(state);
    _update = () {};
  }

  update() {
    _stateMap.entries.forEach((e) => e.value());
  }
}

mixin UpdaterMixin<T extends StatefulWidget> on State<T> {
  late UpdateController updateController;

  @override
  void initState() {
    super.initState();
    subscribeUpdateController();
  }

  void subscribeUpdateController() {
    'subscribe'.dpRed().print();
    updateController.subscribe(this, onUpdate);
  }

  @override
  dispose() {
    super.dispose();
    updateController.dispose(this);
  }

  onUpdate() {
    'update'.print();
    setState(() {});
  }
}

class ValueUpdater {
  final ValueNotifier<DateTime> _updater = ValueNotifier(DateTime.now());
  final int delay;

  ValueUpdater({this.delay = 0});

  update() {
    var now = DateTime.now();
    if (now.millisecondsSinceEpoch - _updater.value.millisecondsSinceEpoch >
        delay) {
      _updater.value = now;
    }
  }

  subscribe(VoidCallback listener) {
    _updater.addListener(listener);
  }

  unsubscribe(VoidCallback listener) {
    _updater.removeListener(listener);
  }
}

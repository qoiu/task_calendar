import 'package:flutter/material.dart';
import 'package:qoiu_utils/qoiu_utils.dart';

class TaskContainer extends StatelessWidget {
  final Widget child;
  final double thin;
  final double? size;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final Color? color;

  const TaskContainer({
    required this.child,
    this.thin = 2,
    this.size,
    this.width,
    this.height,
    this.color,
    this.padding = const EdgeInsets.all(5),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??size,
      height: height??size,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color??getColorScheme().primary, width: thin),
      ),
      child: child,
    );
  }
}

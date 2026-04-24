import 'package:flutter/material.dart';
import 'package:qoiu_utils/components/common_text_builder.dart';
import 'package:task_calendar/themes.dart';
import 'package:task_calendar/utils/utils.dart';

class CloudButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const CloudButton(this.text,
      {required this.onTap, this.color = MainTheme.accent, super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(colors: [
                  color,
                  color.oppositeExtraColor(0.05),
                  color
                ], stops: const [
                  0.2,
                  0.5,
                  0.8,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextBuilder(text).labelLarge().color(color.oppositeColor()).build())),
      ),
    );
  }
}

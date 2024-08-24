import 'package:flutter/material.dart';
import 'package:task_calendar/components/text_builder.dart';

class StubScreen extends StatelessWidget {
  final String text;
  const StubScreen(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextBuilder(text).build(),
    );
  }
}
